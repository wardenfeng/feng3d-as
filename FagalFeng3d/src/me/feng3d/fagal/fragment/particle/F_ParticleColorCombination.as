package me.feng3d.fagal.fragment.particle
{
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagalRE.FagalRE;


	/**
	 *
	 * @author warden_feng 2015-1-21
	 */
	public function F_ParticleColorCombination():void
	{
		var _:* = FagalRE.instance.space;

//			if (hasColorMulNode)
		mul(_.finalColor_ft_4, _.finalColor_ft_4, _.particleColorMultiplier_v);
//			if (hasColorAddNode)
		add(_.finalColor_ft_4, _.finalColor_ft_4, _.particleColorOffset_v);
	}
}
