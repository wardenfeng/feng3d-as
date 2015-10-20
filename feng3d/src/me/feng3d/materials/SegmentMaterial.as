package me.feng3d.materials
{
	import me.feng3d.passes.SegmentPass;

	/**
	 * 线段材质
	 * @author feng 2014-4-16
	 */
	public class SegmentMaterial extends MaterialBase
	{
		private var _screenPass:SegmentPass;
		
		public function SegmentMaterial(thickness:Number = 1.25)
		{
			super();
			bothSides = true;
			addPass(_screenPass = new SegmentPass(thickness));
		}
	}
}