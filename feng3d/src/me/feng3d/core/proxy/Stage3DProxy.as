package me.feng3d.core.proxy
{
	import flash.display.Shape;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	import me.feng3d.arcane;
	import me.feng3d.core.manager.Stage3DManager;
	import me.feng3d.debug.Debug;
	import me.feng3d.events.Stage3DEvent;

	use namespace arcane;

	[Event(name = "enterFrame", type = "flash.events.Event")]
	[Event(name = "exitFrame", type = "flash.events.Event")]

	/**
	 * 3D舞台代理
	 */
	public class Stage3DProxy extends EventDispatcher
	{
		private var _frameEventDriver:Shape = new Shape();

		private var _context3D:Context3D;
		private var _stage3DIndex:int = -1;

		private var _usesSoftwareRendering:Boolean;
		private var _profile:String;
		private var _stage3D:Stage3D;
		private var _stage3DManager:Stage3DManager;
		private var _backBufferWidth:int;
		private var _backBufferHeight:int;
		private var _antiAlias:int;
		private var _backBufferEnableDepthAndStencil:Boolean = true;
		private var _contextRequested:Boolean;
		private var _scissorRect:Rectangle;
		private var _backBufferDirty:Boolean;
		private var _viewPort:Rectangle;
		private var _enterFrame:Event;
		private var _exitFrame:Event;
		private var _viewportUpdated:Stage3DEvent;
		private var _viewportDirty:Boolean;
		private var _bufferClear:Boolean;
		private var _color:uint;

		/**
		 * 创建一个3D舞台代理
		 * @param stage3DIndex		被代理3D舞台编号
		 * @param stage3D			被代理的3D舞台
		 * @param stage3DManager	3D舞台管理类
		 * @param forceSoftware		是否强制软件渲染
		 * @param profile
		 */
		public function Stage3DProxy(stage3DIndex:int, stage3D:Stage3D, stage3DManager:Stage3DManager, forceSoftware:Boolean = false, profile:String = "baseline")
		{
			_stage3DIndex = stage3DIndex;
			_stage3D = stage3D;
			_stage3D.x = 0;
			_stage3D.y = 0;
			_stage3D.visible = true;
			_stage3DManager = stage3DManager;
			_viewPort = new Rectangle();

			_stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DUpdate, false, 1000, false);
			requestContext(forceSoftware, profile);
		}

		/**
		 * The background color of the Stage3D.
		 */
		public function get color():uint
		{
			return _color;
		}

		public function set color(color:uint):void
		{
			_color = color;
		}

		/**
		 * 通知视窗发生变化
		 */
		private function notifyViewportUpdated():void
		{
			if (_viewportDirty)
				return;

			_viewportDirty = true;

			if (!hasEventListener(Stage3DEvent.VIEWPORT_UPDATED))
				return;

			_viewportUpdated = new Stage3DEvent(Stage3DEvent.VIEWPORT_UPDATED);

			dispatchEvent(_viewportUpdated);
		}

		/**
		 * 通知进入帧事件
		 */
		private function notifyEnterFrame():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				return;

			if (!_enterFrame)
				_enterFrame = new Event(Event.ENTER_FRAME);

			dispatchEvent(_enterFrame);
		}

		/**
		 * 通知退出帧事件
		 */
		private function notifyExitFrame():void
		{
			if (!hasEventListener(Event.EXIT_FRAME))
				return;

			if (!_exitFrame)
				_exitFrame = new Event(Event.EXIT_FRAME);

			dispatchEvent(_exitFrame);
		}

		/**
		 * 释放3D舞台代理，同时释放3D舞台中的3D环境
		 */
		public function dispose():void
		{
			_stage3DManager.removeStage3DProxy(this);
			_stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContext3DUpdate);
			freeContext3D();
			_stage3D = null;
			_stage3DManager = null;
			_stage3DIndex = -1;
		}

		/**
		 * 设置渲染缓冲区的视口尺寸和其他属性
		 * @param backBufferWidth		缓冲区的宽度，以像素为单位。
		 * @param backBufferHeight		缓冲区的高度，以像素为单位。
		 * @param antiAlias				一个整数值，指定所请求的消除锯齿品质。该值与消除锯齿时使用的子实例的数量相关联。使用更多子实例要求执行更多的计算，尽管相对性能影响取决于特定的渲染硬件。消除锯齿的类型和是否执行消除锯齿操作取决于设备和渲染模式。软件渲染上下文完全不支持消除锯齿。
		 */
		public function configureBackBuffer(backBufferWidth:int, backBufferHeight:int, antiAlias:int):void
		{
			if (backBufferWidth < 50)
				backBufferWidth = 50;
			if (backBufferHeight < 50)
				backBufferHeight = 50;
			var oldWidth:uint = _backBufferWidth;
			var oldHeight:uint = _backBufferHeight;

			_backBufferWidth = _viewPort.width = backBufferWidth;
			_backBufferHeight = _viewPort.height = backBufferHeight;

			if (oldWidth != _backBufferWidth || oldHeight != _backBufferHeight)
				notifyViewportUpdated();

			_antiAlias = antiAlias;

			if (_context3D)
				_context3D.configureBackBuffer(backBufferWidth, backBufferHeight, antiAlias, _backBufferEnableDepthAndStencil);
		}

		/**
		 * 清除与重置缓冲区
		 */
		public function clear():void
		{
			if (!_context3D)
				return;

			if (_backBufferDirty)
			{
				configureBackBuffer(_backBufferWidth, _backBufferHeight, _antiAlias);
				_backBufferDirty = false;
			}

			_context3D.clear( //
				((_color >> 16) & 0xff) / 255.0, //
				((_color >> 8) & 0xff) / 255.0, //
				(_color & 0xff) / 255.0, //
				((_color >> 24) & 0xff) / 255.0);

			_bufferClear = true;
		}

		/**
		 * 显示渲染缓冲
		 */
		public function present():void
		{
			if (!_context3D)
				return;

			_context3D.present();
		}

		/**
		 * 添加事件侦听
		 * @param type							事件的类型
		 * @param listener						处理事件的侦听器函数
		 * @param useCapture					确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段
		 * @param priority						事件侦听器的优先级。优先级由一个带符号的 32 位整数指定。数字越大，优先级越高。优先级为 n 的所有侦听器会在优先级为 n -1 的侦听器之前得到处理。如果两个或更多个侦听器共享相同的优先级，则按照它们的添加顺序进行处理。默认优先级为 0。
		 * @param useWeakReference				确定对侦听器的引用是强引用，还是弱引用。强引用（默认值）可防止您的侦听器被当作垃圾回收。弱引用则没有此作用。
		 */
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);

			if ((type == Event.ENTER_FRAME || type == Event.EXIT_FRAME) && !_frameEventDriver.hasEventListener(Event.ENTER_FRAME))
				_frameEventDriver.addEventListener(Event.ENTER_FRAME, onEnterFrame, useCapture, priority, useWeakReference);
		}

		/**
		 * 移除事件侦听
		 * @param type				事件的类型
		 * @param listener			要删除的侦听器函数
		 * @param useCapture		指出是为捕获阶段还是为目标和冒泡阶段注册了侦听器。如果为捕获阶段以及目标和冒泡阶段注册了侦听器，则需要对 removeEventListener() 进行两次调用才能将这两个侦听器删除，一次调用将 useCapture() 设置为 true，另一次调用将 useCapture() 设置为 false。
		 */
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);

			// Remove the main rendering listener if no EnterFrame listeners remain
			if (!hasEventListener(Event.ENTER_FRAME) && !hasEventListener(Event.EXIT_FRAME) && _frameEventDriver.hasEventListener(Event.ENTER_FRAME))
				_frameEventDriver.removeEventListener(Event.ENTER_FRAME, onEnterFrame, useCapture);
		}

		/**
		 * 裁剪矩形
		 */
		public function get scissorRect():Rectangle
		{
			return _scissorRect;
		}

		public function set scissorRect(value:Rectangle):void
		{
			_scissorRect = value;
			_context3D.setScissorRectangle(_scissorRect);
		}

		/**
		 * 3D舞台编号
		 */
		public function get stage3DIndex():int
		{
			return _stage3DIndex;
		}

		/**
		 * 3D舞台
		 */
		public function get stage3D():Stage3D
		{
			return _stage3D;
		}

		/**
		 * 3D环境
		 */
		public function get context3D():Context3D
		{
			return _context3D;
		}

		/**
		 * 驱动信息
		 */
		public function get driverInfo():String
		{
			return _context3D ? _context3D.driverInfo : null;
		}

		/**
		 * 是否在软件模式渲染
		 */
		public function get usesSoftwareRendering():Boolean
		{
			return _usesSoftwareRendering;
		}

		/**
		 * 3D舞台X坐标
		 */
		public function get x():Number
		{
			return _stage3D.x;
		}

		public function set x(value:Number):void
		{
			if (_viewPort.x == value)
				return;

			_stage3D.x = _viewPort.x = value;

			notifyViewportUpdated();
		}

		/**
		 * 3D舞台Y坐标
		 */
		public function get y():Number
		{
			return _stage3D.y;
		}

		public function set y(value:Number):void
		{
			if (_viewPort.y == value)
				return;

			_stage3D.y = _viewPort.y = value;

			notifyViewportUpdated();
		}

		/**
		 * 3D舞台宽度
		 */
		public function get width():int
		{
			return _backBufferWidth;
		}

		public function set width(width:int):void
		{
			if (_viewPort.width == width)
				return;

			if (width < 50)
				width = 50;
			_backBufferWidth = _viewPort.width = width;
			_backBufferDirty = true;

			notifyViewportUpdated();
		}

		/**
		 * 3D舞台高度
		 */
		public function get height():int
		{
			return _backBufferHeight;
		}

		public function set height(height:int):void
		{
			if (_viewPort.height == height)
				return;

			if (height < 50)
				height = 50;
			_backBufferHeight = _viewPort.height = height;
			_backBufferDirty = true;

			notifyViewportUpdated();
		}

		/**
		 * 抗锯齿值
		 */
		public function get antiAlias():int
		{
			return _antiAlias;
		}

		public function set antiAlias(antiAlias:int):void
		{
			_antiAlias = antiAlias;
			_backBufferDirty = true;
		}

		/**
		 * 视窗矩形
		 */
		public function get viewPort():Rectangle
		{
			_viewportDirty = false;

			return _viewPort;
		}

		/**
		 * 是否可见
		 */
		public function get visible():Boolean
		{
			return _stage3D.visible;
		}

		public function set visible(value:Boolean):void
		{
			_stage3D.visible = value;
		}

		/**
		 * 缓冲区清理状态
		 */
		public function get bufferClear():Boolean
		{
			return _bufferClear;
		}

		public function set bufferClear(newBufferClear:Boolean):void
		{
			_bufferClear = newBufferClear;
		}

		/**
		 * 释放3D环境
		 */
		private function freeContext3D():void
		{
			if (_context3D)
			{
				_context3D.dispose();
				dispatchEvent(new Stage3DEvent(Stage3DEvent.CONTEXT3D_DISPOSED));
			}
			_context3D = null;
		}

		/**
		 * 处理3D环境变化事件
		 */
		private function onContext3DUpdate(event:Event):void
		{
			if (_stage3D.context3D)
			{
				var hadContext:Boolean = (_context3D != null);
				_context3D = _stage3D.context3D;
				_context3D.enableErrorChecking = Debug.agalDebug;

				_usesSoftwareRendering = (_context3D.driverInfo.indexOf('Software') == 0);

				// Only configure back buffer if width and height have been set,
				// which they may not have been if View3D.render() has yet to be
				// invoked for the first time.
				if (_backBufferWidth && _backBufferHeight)
					_context3D.configureBackBuffer(_backBufferWidth, _backBufferHeight, _antiAlias, _backBufferEnableDepthAndStencil);

				// Dispatch the appropriate event depending on whether context was
				// created for the first time or recreated after a device loss.
				dispatchEvent(new Stage3DEvent(hadContext ? Stage3DEvent.CONTEXT3D_RECREATED : Stage3DEvent.CONTEXT3D_CREATED));

			}
			else
				throw new Error("Rendering context lost!");
		}

		/**
		 * 请求3D环境
		 */
		private function requestContext(forceSoftware:Boolean = false, profile:String = Context3DProfile.STANDARD):void
		{
			// If forcing software, we can be certain that the
			// returned Context3D will be running software mode.
			// If not, we can't be sure and should stick to the
			// old value (will likely be same if re-requesting.)
			_usesSoftwareRendering ||= forceSoftware;
			_profile = profile;

			// ugly stuff for backward compatibility
			var renderMode:String = forceSoftware ? Context3DRenderMode.SOFTWARE : Context3DRenderMode.AUTO;
			if (profile == "baseline")
				_stage3D.requestContext3D(renderMode);
			else
			{
				try
				{
					_stage3D.requestContext3D(renderMode, profile);
				}
				catch (error:Error)
				{
					throw "An error occurred creating a context using the given profile. Profiles are not supported for the SDK this was compiled with.";
				}
			}

			_contextRequested = true;
		}

		/**
		 * 处理进入帧事件
		 */
		private function onEnterFrame(event:Event):void
		{
			if (!_context3D)
				return;

			clear();

			notifyEnterFrame();

			present();

			notifyExitFrame();
		}

		/**
		 *	判断3D环境是否可用
		 */
		public function recoverFromDisposal():Boolean
		{
			if (!_context3D)
				return false;
			if (_context3D.driverInfo == "Disposed")
			{
				_context3D = null;
				dispatchEvent(new Stage3DEvent(Stage3DEvent.CONTEXT3D_DISPOSED));
				return false;
			}
			return true;
		}
	}
}
