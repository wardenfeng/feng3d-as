package me.feng3d.core.render
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.data.RenderableListItem;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.core.traverse.EntityCollector;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.LightBase;
	import me.feng3d.lights.shadowmaps.ShadowMapperBase;
	import me.feng3d.materials.MaterialBase;
	import me.feng3d.passes.MaterialPassBase;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * 默认渲染器，使用根据材质渲染场景图
	 * @author warden_feng 2015-3-5
	 */
	public class DefaultRenderer extends RendererBase
	{
		private static var SCREEN_PASSES:int = 2;
		private static var ALL_PASSES:int = 3;
		private var _activeMaterial:MaterialBase;

		private var _depthRenderer:DepthRenderer;
		private var _planarShadowRenderer:PlanarShadowRenderer;

		/**
		 * 是否使用平面阴影
		 */
		public static var usePlanarShadow:Boolean;

		/**
		 * 创建一个默认渲染器
		 */
		public function DefaultRenderer()
		{
			super();
			_depthRenderer = new DepthRenderer();
			_planarShadowRenderer = new PlanarShadowRenderer();
		}

		/**
		 * @inheritDoc
		 */
		protected override function executeRender(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, target:TextureProxyBase = null):void
		{
			if (!usePlanarShadow)
			{
				updateLights(stage3DProxy, entityCollector);
			}
			super.executeRender(stage3DProxy, entityCollector, target);

			if (usePlanarShadow)
			{
				_planarShadowRenderer.render(stage3DProxy, entityCollector, target);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, target:TextureProxyBase):void
		{
			var _context:Context3D = stage3DProxy.context3D;

			_context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);

			if (entityCollector.skyBox)
			{
				if (_activeMaterial)
					_activeMaterial.deactivate();
				_activeMaterial = null;

				_context.setDepthTest(false, Context3DCompareMode.ALWAYS);
				drawSkyBox(stage3DProxy, entityCollector);
			}

			_context.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);

			drawRenderables(stage3DProxy, entityCollector.opaqueRenderableHead, entityCollector);
			drawRenderables(stage3DProxy, entityCollector.blendedRenderableHead, entityCollector);

			_context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);

			if (_activeMaterial)
				_activeMaterial.deactivate();

			_activeMaterial = null;
		}

		/**
		 * Draw the skybox if present.
		 * @param entityCollector The EntityCollector containing all potentially visible information.
		 */
		/**
		 * 绘制天空盒
		 * @param stage3DProxy				3D舞台代理
		 * @param entityCollector			实体收集器
		 *
		 */
		private function drawSkyBox(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector):void
		{
			var renderable:IRenderable = entityCollector.skyBox.subMeshes[0];
			var camera:Camera3D = entityCollector.camera;

			var material:MaterialBase = renderable.material;

			material.updateMaterial();
			var pass:MaterialPassBase = material.getPass(0);
			//初始化渲染参数
			pass.shaderParams.initParams();
			//激活渲染通道
			pass.activate(camera);
			pass.render(renderable, stage3DProxy, camera, _renderIndex++);
			pass.deactivate();
		}

		/**
		 * 绘制可渲染列表
		 * @param renderables 			可渲染列表
		 * @param entityCollector 		实体收集器，包含所有潜在显示实体信息
		 */
		private function drawRenderables(stage3DProxy:Stage3DProxy, item:RenderableListItem, entityCollector:EntityCollector):void
		{
			var numPasses:uint;
			var j:uint;
			var camera:Camera3D = entityCollector.camera;
			var item2:RenderableListItem;

			while (item)
			{
				_activeMaterial = item.renderable.material;
				_activeMaterial.updateMaterial();

				numPasses = _activeMaterial.numPasses;
				j = 0;

				do
				{
					item2 = item;

					var pass:MaterialPassBase = _activeMaterial.getPass(j);

					//初始化渲染参数
					pass.shaderParams.initParams();
					//激活渲染通道
					pass.activate(camera);

					do
					{
						pass.render(item2.renderable, stage3DProxy, camera, _renderIndex++);

						item2 = item2.next;
					} while (item2 && item2.renderable.material == _activeMaterial);
					_activeMaterial.deactivatePass(j);

				} while (++j < numPasses);

				item = item2;
			}
		}

		/**
		 * 更新灯光
		 * @param stage3DProxy				3D场景代理
		 * @param entityCollector			实体集合
		 */
		private function updateLights(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector):void
		{
			var dirLights:Vector.<DirectionalLight> = entityCollector.directionalLights;
			var len:uint, i:uint;
			var light:LightBase;
			var shadowMapper:ShadowMapperBase;

			len = dirLights.length;
			for (i = 0; i < len; ++i)
			{
				light = dirLights[i];
				shadowMapper = light.shadowMapper;
				if (light.castsShadows && (shadowMapper.autoUpdateShadows || shadowMapper._shadowsInvalid))
					shadowMapper.renderDepthMap(stage3DProxy, entityCollector, _depthRenderer);
			}
		}
	}
}
