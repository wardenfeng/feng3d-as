package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 雾片段着色器
	 * @author feng 2015-8-27
	 */
	public function F_Fog():void
	{
		var _:* = FagalRE.instance.space;

		var temp2:Register = _.getFreeTemp("");
		var temp:Register = _.getFreeTemp("");

		//计算雾因子
		//fogRatio = max(0,min(1,(positionZ-minZ)/(maxZ-minZ)))
		_.sub(temp2.w, _.positionProjected_v.z, _.fogCommonData_fc_vector.x); //deltaZ=positionZ-minZ
		_.mul(temp2.w, temp2.w, _.fogCommonData_fc_vector.y); //fogRatio = deltaZ/(maxZ-minZ)
		_.sat(temp2.w, temp2.w); //fogRatio = max(0,fogRatio))

		//使用雾因子把雾颜色混合到最终颜色中
		//col = (fogColor - col) * fogRatio + col = fogRatio * fogColor + (1 - fogRatio) * col
		_.sub(temp, _.fogColor_fc_vector, _.finalColor_ft_4); // (fogColor- col)
		_.mul(temp, temp, temp2.w); // (fogColor- col)*fogRatio
		_.add(_.finalColor_ft_4, _.finalColor_ft_4, temp); // fogRatio*(fogColor- col) + col
	}
}
