package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * blinn-phong half vector model
	 * @author feng 2015-9-24
	 */
	public function F_Blinn_Phong(singleSpecularColorReg:Register, lightDirReg:Register):void
	{
		var _:* = FagalRE.instance.space;

		//入射光与视线方向的和 = 光照场景方向 add 标准视线方向
		_.add(singleSpecularColorReg, lightDirReg, _.viewDir_ft_4);
		//标准化入射光与视线的和
		_.nrm(singleSpecularColorReg.xyz, singleSpecularColorReg);
		//镜面反射光强度 = 法线 dp3 入射光与视线方向的和
		_.dp3(singleSpecularColorReg.w, _.normal_ft_4, singleSpecularColorReg);
		//镜面反射光强度 锁定在0-1之间
		_.sat(singleSpecularColorReg.w, singleSpecularColorReg.w);
	}
}
