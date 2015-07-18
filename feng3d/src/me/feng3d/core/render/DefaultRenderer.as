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

		/**
		 * 创建一个默认渲染器
		 */
		public function DefaultRenderer()
		{
			super();
			_depthRenderer = new DepthRenderer();
		}

		/**
		 * @inheritDoc
		 */
		protected override function executeRender(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, target:TextureProxyBase = null):void
		{
			updateLights(stage3DProxy, entityCollector);
			super.executeRender(stage3DProxy, entityCollector, target);
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, target:TextureProxyBase):void
		{
			var _context:Context3D = stage3DProxy.context3D;

			_context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);

			_context.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);

			drawRenderables(stage3DProxy, entityCollector.opaqueRenderableHead, entityCollector);
			drawRenderables(stage3DProxy, entityCollector.blendedRenderableHead, entityCollector);

			_context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);

			if (_activeMaterial)
				_activeMaterial.deactivate();

			_activeMaterial = null;
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
						var context3dCache:Context3DCache = item2.renderable.context3dCache;
						pass.activateContext3DBuffer(context3dCache);
						//设置渲染参数
						context3dCache.shaderParams = pass.shaderParams;

						//渲染通道
						_activeMaterial.renderPass(j, item2.renderable, entityCollector.camera);

						//绘制图形
						context3dCache.render(stage3DProxy.context3D);

//						pass.deActivateContext3DBuffer(context3dCache);

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
