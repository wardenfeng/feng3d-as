package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.lights.DirectionalLight;

	use namespace arcane;

	/**
	 * 过滤的阴影映射函数
	 * @author warden_feng 2015-5-28
	 */
	public class FilteredShadowMapMethod extends SimpleShadowMapMethodBase
	{
		/**
		 * 过滤的阴影映射函数
		 * @param castingLight		投射灯光
		 */
		public function FilteredShadowMapMethod(castingLight:DirectionalLight)
		{
			super(castingLight);
		}
	}
}
