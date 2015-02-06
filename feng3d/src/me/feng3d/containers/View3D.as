package me.feng3d.containers
{
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.manager.Mouse3DManager;
	import me.feng3d.core.manager.Stage3DManager;
	import me.feng3d.core.math.Ray3D;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.core.render.Renderer;

	use namespace arcane;

	/**
	 * 3D视图
	 * @author warden_feng 2014-3-17
	 */
	public class View3D extends Sprite
	{
		private var _width:Number = 0;
		private var _height:Number = 0;

		private var _globalPosDirty:Boolean;
		protected var _backBufferInvalid:Boolean = true;

		private var _camera:Camera3D;

		private var _scene:Scene3D;

		private var _stage3DProxy:Stage3DProxy;

		protected var _renderer:Renderer;

		private var isInit:Boolean = false;

		private var _backgroundColor:uint = 0x000000;

		protected var _mouse3DManager:Mouse3DManager;

		private var _hitField:Sprite;

		/**
		 * 创建一个3D视图
		 * @param scene 场景
		 * @param camera 照相机
		 * @param stage3DProxy
		 */
		public function View3D(scene:Scene3D = null, camera:Camera3D = null, stage3DProxy:Stage3DProxy = null)
		{
			_scene = scene || new Scene3D();
			_camera = camera || new Camera3D();
			_renderer = new Renderer();
			_renderer.camera = _camera;
			_stage3DProxy = stage3DProxy;

			initHitField();

			_mouse3DManager = new Mouse3DManager();
			_mouse3DManager.enableMouseListeners(this);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromeStage, false, 0, true);
		}

		/**
		 * 照相机
		 */
		public function get camera():Camera3D
		{
			return _camera;
		}

		public function set camera(value:Camera3D):void
		{
			if (value)
			{
				_camera = value;
				_renderer.camera = _camera;
			}
		}

		private function onAddedToStage(event:Event):void
		{
			init();
			_stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onRemoveFromeStage(event:Event):void
		{
			_stage3DProxy.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function init():void
		{
			if (isInit)
				return;
			isInit = true;

			if (!_stage3DProxy)
			{
				_stage3DProxy = Stage3DManager.getInstance(stage).getFreeStage3DProxy();
			}

			_renderer.stage3DProxy = _stage3DProxy;

		}

		private function initHitField():void
		{
			_hitField = new Sprite();
			_hitField.alpha = 0;
			_hitField.doubleClickEnabled = true;
			_hitField.graphics.beginFill(0x000000);
			_hitField.graphics.drawRect(0, 0, 100, 100);
			addChild(_hitField);
		}

		private function onEnterFrame(e:Event):void
		{
			render();
		}

		public function addSourceURL(url:String):void
		{

		}

		public function render():void
		{
			var context3D:Context3D = stage3DProxy.context3D;
			if (context3D == null)
				return;

			// reset or update render settings
			if (_backBufferInvalid)
				updateBackBuffer();

			if (_globalPosDirty)
				updateGlobalPos();

			//渲染显示对象
			_renderer.render1(_scene.displayEntityDic);

			//收集场景显示对象
			_scene.collectMouseCollisionEntitys();

			//获取鼠标射线
			var mouseRay3D:Ray3D = getMouseRay3D();
			//更新鼠标碰撞
			_mouse3DManager.fireMouseEvents(mouseRay3D, _scene.mouseCollisionEntitys);
		}

		/** 3d场景 */
		public function get scene():Scene3D
		{
			return _scene;
		}

		/**
		 * @private
		 */
		public function set scene(value:Scene3D):void
		{
			_scene = value;
		}

		public function get stage3DProxy():Stage3DProxy
		{
			return _stage3DProxy;
		}

		public function set stage3DProxy(value:Stage3DProxy):void
		{
			_stage3DProxy = value;

			if (_stage3DProxy)
			{
				_stage3DProxy.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}

			_stage3DProxy = stage3DProxy;

			_stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			_renderer.stage3DProxy = _stage3DProxy;
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			// Backbuffer limitation in software mode. See comment in updateBackBuffer()
			if (_stage3DProxy && _stage3DProxy.usesSoftwareRendering && value > 2048)
				value = 2048;

			if (_width == value)
				return;

			_hitField.width = value;
			_width = value;

			_backBufferInvalid = true;
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			// Backbuffer limitation in software mode. See comment in updateBackBuffer()
			if (_stage3DProxy && _stage3DProxy.usesSoftwareRendering && value > 2048)
				value = 2048;

			if (_height == value)
				return;

			_hitField.height = value;
			_height = value;

			_backBufferInvalid = true;
		}

		/**
		 * 渲染面数
		 */
		public function get renderedFacesCount():uint
		{
			return 0;
		}

		/**
		 * Updates the backbuffer dimensions.
		 */
		protected function updateBackBuffer():void
		{
			// No reason trying to configure back buffer if there is no context available.
			// Doing this anyway (and relying on _stage3DProxy to cache width/height for 
			// context does get available) means usesSoftwareRendering won't be reliable.
			if (_stage3DProxy.context3D)
			{
				if (_width && _height)
				{
					// Backbuffers are limited to 2048x2048 in software mode and
					// trying to configure the backbuffer to be bigger than that
					// will throw an error. Capping the value is a graceful way of
					// avoiding runtime exceptions for developers who are unable
					// to test their Away3D implementation on screens that are 
					// large enough for this error to ever occur.
					if (_stage3DProxy.usesSoftwareRendering)
					{
						// Even though these checks where already made in the width
						// and height setters, at that point we couldn't be sure that
						// the context had even been retrieved and the software flag
						// thus be reliable. Make checks again.
						if (_width > 2048)
							_width = 2048;
						if (_height > 2048)
							_height = 2048;
					}

					_stage3DProxy.configureBackBuffer(_width, _height, 0);
					_backBufferInvalid = false;
				}
				else
				{
					width = stage.stageWidth;
					height = stage.stageHeight;
				}
			}
		}

		override public function set x(value:Number):void
		{
			if (x == value)
				return;
			super.x = value;

			_globalPosDirty = true;
		}

		override public function set y(value:Number):void
		{
			if (y == value)
				return;
			super.y = value;

			_globalPosDirty = true;
		}

		protected function updateGlobalPos():void
		{
			if (!_stage3DProxy)
				return;

			_stage3DProxy.x = x;
			_stage3DProxy.y = y;

			_globalPosDirty = false;
		}

		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			_renderer.backgroundR = ((value >> 16) & 0xff) / 0xff;
			_renderer.backgroundG = ((value >> 8) & 0xff) / 0xff;
			_renderer.backgroundB = (value & 0xff) / 0xff;
		}

		/**
		 * 投影坐标（世界坐标转换为场景坐标）
		 * @param point3d 世界坐标
		 * @return 屏幕的绝对坐标
		 */
		public function project(point3d:Vector3D):Vector3D
		{
			var v:Vector3D = _camera.project(point3d);

			v.x = (v.x + 1.0) * _width / 2.0;
			v.y = (v.y + 1.0) * _height / 2.0;

			return v;
		}

		/**
		 * 屏幕坐标投影到场景坐标
		 * @param nX 屏幕坐标X ([0-width])
		 * @param nY 屏幕坐标Y ([0-height])
		 * @param sZ 到屏幕的距离
		 * @param v 场景坐标（输出）
		 * @return 场景坐标
		 */
		public function unproject(sX:Number, sY:Number, sZ:Number, v:Vector3D = null):Vector3D
		{
			var gpuPos:Point = screenToGpuPosition(new Point(sX, sY));
			return _camera.unproject(gpuPos.x, gpuPos.y, sZ, v);
		}

		/**
		 * 屏幕坐标转GPU坐标
		 * @param screenPos 屏幕坐标 (x:[0-width],y:[0-height])
		 * @return GPU坐标 (x:[-1,1],y:[-1-1])
		 */
		public function screenToGpuPosition(screenPos:Point):Point
		{
			var gpuPos:Point = new Point();
			gpuPos.x = (screenPos.x * 2 - _width) / _stage3DProxy.width;
			gpuPos.y = (screenPos.y * 2 - _height) / _stage3DProxy.height;
			return gpuPos;
		}

		private static const tempRayPosition:Vector3D = new Vector3D();
		private static const tempRayDirection:Vector3D = new Vector3D();

		/**
		 * 获取鼠标射线（与鼠标重叠的摄像机射线）
		 */
		public function getMouseRay3D():Ray3D
		{
			return getRay3D(mouseX, mouseY);
		}

		/**
		 * 获取与坐标重叠的射线
		 * @param x view3D上的X坐标
		 * @param y view3D上的X坐标
		 * @return
		 */
		public function getRay3D(x:Number, y:Number):Ray3D
		{
			var rayPosition:Vector3D = unproject(x, y, 0, tempRayPosition);
			var rayDirection:Vector3D = unproject(x, y, 1, tempRayDirection);
			rayDirection.x = rayDirection.x - rayPosition.x;
			rayDirection.y = rayDirection.y - rayPosition.y;
			rayDirection.z = rayDirection.z - rayPosition.z;
			rayDirection.normalize();
			var ray3D:Ray3D = new Ray3D(rayPosition, rayDirection);
			return ray3D;
		}

		public function get renderer():Renderer
		{
			return _renderer;
		}

		public function set renderer(value:Renderer):void
		{
			_renderer = value;
		}

	}
}
