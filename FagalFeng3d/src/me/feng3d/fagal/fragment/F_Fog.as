package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 雾片段着色器
	 * @author warden_feng 2015-8-27
	 */
	public function F_Fog():void
	{
		var _:* = FagalRE.instance.space;

		var temp2:Register = _.getFreeTemp("");
		var temp:Register = _.getFreeTemp("");

		_.sub(temp2.w, _.positionProjected_v.z, _.fogCommonData_fc_vector.x); //
		_.mul(temp2.w, temp2.w, _.fogCommonData_fc_vector.y); //
		_.sat(temp2.w, temp2.w); //
		_.sub(temp, _.fogColor_fc_vector, _.finalColor_ft_4); // (fogColor- col)
		_.mul(temp, temp, temp2.w); // (fogColor- col)*fogRatio
		_.add(_.finalColor_ft_4, _.finalColor_ft_4, temp); // fogRatio*(fogColor- col) + col
	}
}
