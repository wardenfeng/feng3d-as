package me.feng3d.core.render
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.data.RenderableListItem;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.core.traverse.EntityCollector;
	import me.feng3d.materials.MaterialBase;
	import me.feng3d.passes.DepthMapPass;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * 深度渲染器
	 * @author warden_feng 2015-5-28
	 */
	public class DepthRenderer extends RendererBase
	{
		private var _activeMaterial:MaterialBase;

		/**
		 * 创建一个深度渲染器
		 */
		public function DepthRenderer()
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

			_activeMaterial = null;
		}

		/**
		 * 绘制渲染列表
		 * @param stage3DProxy			3D场景代理
		 * @param item					渲染对象列表单元
		 * @param entityCollector		实体集合
		 * @param target				渲染目标
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
				depthPass.activate(camera, target);

				item2 = item;
				do
				{
					depthPass.render(item2.renderable, stage3DProxy, camera);

					item2 = item2.next;
				} while (item2 && item2.renderable.material == _activeMaterial);

				depthPass.deactivate();
				item = item2;
			}
		}
	}
}
