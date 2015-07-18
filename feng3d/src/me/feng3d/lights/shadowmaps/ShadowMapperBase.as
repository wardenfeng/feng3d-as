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
	 * 阴影映射基类
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

		/**
		 * 创建阴影映射
		 */
		public function ShadowMapperBase()
		{
			_casterCollector = createCasterCollector();
		}

		/**
		 * 创建阴影投射者集合
		 */
		protected function createCasterCollector():ShadowCasterCollector
		{
			return new ShadowCasterCollector();
		}

		/**
		 * 灯光
		 */
		public function get light():LightBase
		{
			return _light;
		}

		public function set light(value:LightBase):void
		{
			_light = value;
		}

		/**
		 * 深度图
		 */
		public function get depthMap():TextureProxyBase
		{
			return _depthMap ||= createDepthTexture();
		}

		/**
		 * 是否自动更新阴影
		 */
		public function get autoUpdateShadows():Boolean
		{
			return _autoUpdateShadows;
		}

		/**
		 * 渲染深度图
		 * @param stage3DProxy			3D场景代理
		 * @param entityCollector		实体集合
		 * @param renderer				渲染器
		 */
		arcane function renderDepthMap(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, renderer:DepthRenderer):void
		{
			_shadowsInvalid = false;
			updateDepthProjection(entityCollector.camera);
			_depthMap ||= createDepthTexture();
			drawDepthMap(_depthMap, stage3DProxy, entityCollector.scene, renderer);
		}

		/**
		 * 创建深度纹理
		 */
		protected function createDepthTexture():TextureProxyBase
		{
			return new RenderTexture(_depthMapSize, _depthMapSize);
		}

		/**
		 * 更新深度投影矩阵
		 * @param viewCamera		摄像机
		 */
		protected function updateDepthProjection(viewCamera:Camera3D):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 绘制深度图
		 * @param depthMap				深度图纹理
		 * @param stage3DProxy			3D舞台代理
		 * @param scene					场景
		 * @param renderer				渲染器
		 */
		protected function drawDepthMap(depthMap:TextureProxyBase, stage3DProxy:Stage3DProxy, scene:Scene3D, renderer:DepthRenderer):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 深度图尺寸
		 */
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

		/**
		 * 销毁
		 */
		public function dispose():void
		{

		}
	}
}
