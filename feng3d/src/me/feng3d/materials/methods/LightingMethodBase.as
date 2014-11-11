package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 灯光函数
	 * @author warden_feng 2014-7-1
	 */
	public class LightingMethodBase extends ShadingMethodBase
	{
		public function LightingMethodBase(pass:MaterialPassBase)
		{
			super(pass);
		}
	}
}
