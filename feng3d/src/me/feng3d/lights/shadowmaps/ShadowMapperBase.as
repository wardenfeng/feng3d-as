package me.feng3d.lights.shadowmaps
{
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.core.render.DepthRenderer;
	import me.feng3d.core.traverse.EntityCollector;
	import me.feng3d.core.traverse.ShadowCasterCollector;
	import me.feng3d.lights.LightBase;
	import me.feng3d.textures.RenderTexture;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 *
	 * @author warden_feng 2015-5-28
	 */
	public class ShadowMapperBase
	{
		protected var _casterCollector:ShadowCasterCollector;

		private var _depthMap:TextureProxyBase;
		protected var _depthMapSize:uint = 2048;
		protected var _light:LightBase;

		private var _autoUpdateShadows:Boolean = true;

		arcane var _shadowsInvalid:Boolean;

		public function ShadowMapperBase()
		{
			_casterCollector = createCasterCollector();
		}

		protected function createCasterCollector():ShadowCasterCollector
		{
			return new ShadowCasterCollector();
		}

		public function get light():LightBase
		{
			return _light;
		}

		public function set light(value:LightBase):void
		{
			_light = value;
		}

		public function get depthMap():TextureProxyBase
		{
			return _depthMap ||= createDepthTexture();
		}

		public function get autoUpdateShadows():Boolean
		{
			return _autoUpdateShadows;
		}

		/**
		 * Renders the depth map for this light.
		 * @param entityCollector The EntityCollector that contains the original scene data.
		 * @param renderer The DepthRenderer to render the depth map.
		 */
		arcane function renderDepthMap(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, renderer:DepthRenderer):void
		{
			_shadowsInvalid = false;
			updateDepthProjection(entityCollector.camera);
			_depthMap ||= createDepthTexture();
			drawDepthMap(_depthMap, stage3DProxy, entityCollector.scene, renderer);
		}

		protected function createDepthTexture():TextureProxyBase
		{
			return new RenderTexture(_depthMapSize, _depthMapSize);
		}

		protected function updateDepthProjection(viewCamera:Camera3D):void
		{
			throw new AbstractMethodError();
		}

		protected function drawDepthMap(depthMap:TextureProxyBase, stage3DProxy:Stage3DProxy, scene:Scene3D, renderer:DepthRenderer):void
		{
			throw new AbstractMethodError();
		}

		public function get depthMapSize():uint
		{
			return _depthMapSize;
		}

		public function set depthMapSize(value:uint):void
		{
			if (value == _depthMapSize)
				return;
			_depthMapSize = value;
		}

		public function dispose():void
		{

		}
	}
}