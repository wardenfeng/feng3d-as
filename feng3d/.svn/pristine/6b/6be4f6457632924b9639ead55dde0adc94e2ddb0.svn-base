package me.feng3d.materials
{
	import me.feng3d.arcane;
	import me.feng3d.passes.SkyBoxPass;
	import me.feng3d.textures.CubeTextureProxyBase;
	
	use namespace arcane;
	
	/**
	 * 天空盒材质
	 * @author warden_feng 2014-7-11
	 */
	public class SkyBoxMaterial extends MaterialBase
	{
		private var _cubeMap:CubeTextureProxyBase;
		private var _skyboxPass:SkyBoxPass;
		
		public function SkyBoxMaterial(cubeMap:CubeTextureProxyBase)
		{
			_cubeMap = cubeMap;
			addPass(_skyboxPass = new SkyBoxPass());
			_skyboxPass.cubeTexture = _cubeMap;
		}
		
		public function get cubeMap():CubeTextureProxyBase
		{
			return _cubeMap;
		}
		
		public function set cubeMap(value:CubeTextureProxyBase):void
		{
			if (value && _cubeMap && (value.hasMipMaps != _cubeMap.hasMipMaps || value.format != _cubeMap.format))
				invalidatePasses(null);
			
			_cubeMap = value;
			
			_skyboxPass.cubeTexture = _cubeMap;
		}
	}
}