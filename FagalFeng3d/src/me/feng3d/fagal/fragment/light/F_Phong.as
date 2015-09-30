package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * phong model
	 * @author feng 2015-9-24
	 */
	public function F_Phong(singleSpecularColorReg:Register, lightDirReg:Register):void
	{
		var _:* = FagalRE.instance.space;

		// phong model
		_.dp3(singleSpecularColorReg.w, lightDirReg, _.normal_ft_4); // sca1 = light.normal

		//find the reflected light vector R
		_.add(singleSpecularColorReg.w, singleSpecularColorReg.w, singleSpecularColorReg.w); // sca1 = sca1*2
		_.mul(singleSpecularColorReg.xyz, _.normal_ft_4, singleSpecularColorReg.w); // vec1 = normal*sca1
		_.sub(singleSpecularColorReg.xyz, singleSpecularColorReg, lightDirReg); // vec1 = vec1 - light (light vector is negative)

		//smooth the edge as incidence angle approaches 90
		_.add(singleSpecularColorReg.w, singleSpecularColorReg.w, _.commonsData_fc_vector.w); // sca1 = sca1 + smoothtep;
		_.sat(singleSpecularColorReg.w, singleSpecularColorReg.w); // sca1 range 0 - 1
		_.mul(singleSpecularColorReg.xyz, singleSpecularColorReg, singleSpecularColorReg.w); // vec1 = vec1*sca1

		//find the dot product between R and V
		_.dp3(singleSpecularColorReg.w, singleSpecularColorReg, _.viewDir_ft_4); // sca1 = vec1.view
		_.sat(singleSpecularColorReg.w, singleSpecularColorReg.w);
	}
}
