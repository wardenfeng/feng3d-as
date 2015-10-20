package me.feng3d.fagal.fragment.particle
{
	import me.feng3d.fagalRE.FagalRE;


	/**
	 *
	 * @author feng 2015-1-21
	 */
	public function F_ParticleColorCombination():void
	{
		var _:* = FagalRE.instance.space;

//			if (hasColorMulNode)
		_.mul(_.finalColor_ft_4, _.finalColor_ft_4, _.particleColorMultiplier_v);
//			if (hasColorAddNode)
		_.add(_.finalColor_ft_4, _.finalColor_ft_4, _.particleColorOffset_v);
	}
}
