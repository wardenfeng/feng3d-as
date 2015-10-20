package me.feng3d.materials
{
	import me.feng3d.arcane;
	import me.feng3d.passes.SkyBoxPass;
	import me.feng3d.textures.CubeTextureBase;

	use namespace arcane;

	/**
	 * 天空盒材质
	 * @author feng 2014-7-11
	 */
	public class SkyBoxMaterial extends MaterialBase
	{
		private var _cubeMap:CubeTextureBase;
		private var _skyboxPass:SkyBoxPass;

		/**
		 * 创建天空盒材质实例
		 * @param cubeMap			立方体映射纹理
		 */
		public function SkyBoxMaterial(cubeMap:CubeTextureBase)
		{
			_cubeMap = cubeMap;
			addPass(_skyboxPass = new SkyBoxPass());
			_skyboxPass.cubeTexture = _cubeMap;
		}

		/**
		 * 立方体映射纹理
		 */
		public function get cubeMap():CubeTextureBase
		{
			return _cubeMap;
		}

		public function set cubeMap(value:CubeTextureBase):void
		{
			if (value && _cubeMap && (value.hasMipMaps != _cubeMap.hasMipMaps || value.format != _cubeMap.format))
				invalidatePasses(null);

			_cubeMap = value;

			_skyboxPass.cubeTexture = _cubeMap;
		}
	}
}
