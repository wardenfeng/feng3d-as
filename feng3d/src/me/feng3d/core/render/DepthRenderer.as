package me.feng3d.core.render
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.core.data.RenderableListItem;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.core.traverse.EntityCollector;
	import me.feng3d.materials.MaterialBase;
	import me.feng3d.passes.DepthMapPass;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 *
	 * @author warden_feng 2015-5-28
	 */
	public class DepthRenderer extends RendererBase
	{
		private var _activeMaterial:MaterialBase;
		private var _distanceBased:Boolean;

		/**
		 * Creates a new DepthRenderer object.
		 * @param renderBlended Indicates whether semi-transparent objects should be rendered.
		 * @param distanceBased Indicates whether the written depth value is distance-based or projected depth-based
		 */
		public function DepthRenderer(renderBlended:Boolean = false, distanceBased:Boolean = false)
		{
			super();
			_backgroundR = 1;
			_backgroundG = 1;
			_backgroundB = 1;
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, target:TextureProxyBase):void
		{
			var _context:Context3D = stage3DProxy.context3D;

			_context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			_context.setDepthTest(true, Context3DCompareMode.LESS);
			drawRenderables(stage3DProxy, entityCollector.opaqueRenderableHead, entityCollector, target);

			if (_activeMaterial)
				_activeMaterial.deactivateForDepth();

			_activeMaterial = null;
		}

		/**
		 * Draw a list of renderables.
		 * @param renderables The renderables to draw.
		 * @param entityCollector The EntityCollector containing all potentially visible information.
		 */
		private function drawRenderables(stage3DProxy:Stage3DProxy, item:RenderableListItem, entityCollector:EntityCollector, target:TextureProxyBase):void
		{
			var camera:Camera3D = entityCollector.camera;
			var item2:RenderableListItem;

			while (item)
			{
				_activeMaterial = item.renderable.material;

				var depthPass:DepthMapPass = _activeMaterial.depthPass;
				//初始化渲染参数
				depthPass.shaderParams.initParams();
				//激活渲染通道
				depthPass.activate(camera);

				depthPass.depthMap = target;

				item2 = item;
				do
				{
					var context3dCache:Context3DCache = item2.renderable.context3dCache;

					depthPass.activateContext3DBuffer(context3dCache);

					//设置渲染参数
					context3dCache.shaderParams = depthPass.shaderParams;

					depthPass.render(item2.renderable, camera);

					//绘制图形
					context3dCache.render(stage3DProxy.context3D);

//					depthPass.deActivateContext3DBuffer(context3dCache);

					item2 = item2.next;
				} while (item2 && item2.renderable.material == _activeMaterial);
				_activeMaterial.deactivateForDepth();
				item = item2;
			}
		}
	}
}
