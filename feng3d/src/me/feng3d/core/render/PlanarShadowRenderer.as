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
	import me.feng3d.passes.PlanarShadowPass;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * 平面阴影渲染器
	 * @author warden_feng 2015-8-23
	 */
	public class PlanarShadowRenderer extends RendererBase
	{
		private var _activeMaterial:MaterialBase;

		/**
		 * 创建一个深度渲染器
		 */
		public function PlanarShadowRenderer()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function executeRender(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, target:TextureProxyBase = null):void
		{
			var _context:Context3D = stage3DProxy.context3D;

			if (_renderableSorter)
				_renderableSorter.sort(entityCollector);

			_context.setDepthTest(false, Context3DCompareMode.ALWAYS);

			//绘制
			draw(stage3DProxy, entityCollector, target);
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

				var planarShadowPass:PlanarShadowPass = _activeMaterial.planarShadowPass;

				//初始化渲染参数
				planarShadowPass.shaderParams.initParams();
				//激活渲染通道
				planarShadowPass.activate(camera, target);

				item2 = item;
				do
				{
					if (item2.renderable.castsShadows)
					{
						planarShadowPass.render(item2.renderable, stage3DProxy, camera, _renderIndex++);
					}
					item2 = item2.next;
				} while (item2 && item2.renderable.material == _activeMaterial);
				planarShadowPass.deactivate();

				item = item2;
			}
		}

	}
}
