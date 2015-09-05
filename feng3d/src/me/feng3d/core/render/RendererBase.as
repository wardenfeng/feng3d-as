package me.feng3d.core.render
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;

	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.core.sorter.IEntitySorter;
	import me.feng3d.core.sorter.RenderableMergeSort;
	import me.feng3d.core.traverse.EntityCollector;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * 渲染器抽象基类
	 * @author warden_feng 2015-3-1
	 */
	public class RendererBase
	{
		//背景颜色
		protected var _backgroundR:Number = 0;
		protected var _backgroundG:Number = 0;
		protected var _backgroundB:Number = 0;
		protected var _backgroundColor:Number = 0;
		protected var _backgroundAlpha:Number = 1;

		protected var _viewWidth:Number;
		protected var _viewHeight:Number;

		/**
		 * 渲染对象排序类
		 */
		protected var _renderableSorter:IEntitySorter;

		protected var _textureRatioX:Number = 1;
		protected var _textureRatioY:Number = 1;

		/**
		 * 渲染编号
		 */
		protected var _renderIndex:int;

		/**
		 * 创建一个渲染创新基类
		 * @param renderToTexture		释放渲染到纹理
		 */
		public function RendererBase(renderToTexture:Boolean = false)
		{
			_renderableSorter = new RenderableMergeSort();
		}

		/**
		 * 创建一个实体收集器
		 */
		arcane function createEntityCollector():EntityCollector
		{
			return new EntityCollector();
		}

		/**
		 * 窗口宽度
		 */
		arcane function get viewWidth():Number
		{
			return _viewWidth;
		}

		arcane function set viewWidth(value:Number):void
		{
			_viewWidth = value;
		}

		/**
		 * 窗口高度
		 */
		arcane function get viewHeight():Number
		{
			return _viewHeight;
		}

		arcane function set viewHeight(value:Number):void
		{
			_viewHeight = value;
		}

		/**
		 * 背景颜色透明度部分
		 */
		arcane function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}

		arcane function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
		}

		/**
		 * 背景颜色
		 */
		arcane function get backgroundColor():Number
		{
			return _backgroundColor;
		}

		arcane function set backgroundColor(value:Number):void
		{
			_backgroundR = ((value >> 16) & 0xff) / 0xff;
			_backgroundG = ((value >> 8) & 0xff) / 0xff;
			_backgroundB = (value & 0xff) / 0xff;

			_backgroundColor = value;
		}

		/**
		 * 释放
		 */
		arcane function dispose():void
		{
		}

		/**
		 * 渲染潜在可见几何体到缓冲区或纹理
		 * @param stage3DProxy			3D舞台代理
		 * @param entityCollector 		实体收集器
		 * @param target 				目标纹理，默认为null表示渲染到缓冲区
		 */
		arcane function render(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, target:TextureProxyBase = null):void
		{
			var _context:Context3D = stage3DProxy.context3D;

			if (!stage3DProxy || !_context)
				return;

			//执行渲染
			executeRender(stage3DProxy, entityCollector, target);

			//清除3D环境缓存
			for (var i:uint = 0; i < 8; ++i)
			{
				_context.setVertexBufferAt(i, null);
				_context.setTextureAt(i, null);
			}
		}

		/**
		 * 执行渲染
		 * @param stage3DProxy			3D舞台代理
		 * @param entityCollector		实体收集器
		 * @param target				渲染目标
		 */
		protected function executeRender(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, target:TextureProxyBase = null):void
		{
			var _context:Context3D = stage3DProxy.context3D;

			if (_renderableSorter)
				_renderableSorter.sort(entityCollector);

			_renderIndex = 0;

			//重置3D环境背景颜色
			_context.clear(_backgroundR, _backgroundG, _backgroundB, _backgroundAlpha, 1, 0);
			_context.setDepthTest(false, Context3DCompareMode.ALWAYS);

			//绘制
			draw(stage3DProxy, entityCollector, target);
		}

		/**
		 * 绘制
		 * @param stage3DProxy			3D舞台代理
		 * @param entityCollector		实体收集器
		 * @param target				渲染目标
		 */
		protected function draw(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, target:TextureProxyBase):void
		{
			throw new AbstractMethodError();
		}
	}
}
