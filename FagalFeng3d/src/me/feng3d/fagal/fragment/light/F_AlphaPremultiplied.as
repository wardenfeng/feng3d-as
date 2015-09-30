package me.feng3d.fagal.fragment.light
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 *
	 * @author feng 2015-9-25
	 */
	public function F_AlphaPremultiplied():void
	{
		var _:* = FagalRE.instance.space;

		_.add(_.finalColor_ft_4.w, _.finalColor_ft_4.w, _.commonsData_fc_vector.z); //
		_.div(_.finalColor_ft_4.xyz, _.finalColor_ft_4, _.finalColor_ft_4.w); //
		_.sub(_.finalColor_ft_4.w, _.finalColor_ft_4.w, _.commonsData_fc_vector.z); //
		_.sat(_.finalColor_ft_4.xyz, _.finalColor_ft_4);
	}
}
