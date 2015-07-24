package me.feng3d.fagal.fragment.shadowMap
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.math.blend;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.dp4;
	import me.feng3d.fagal.base.operation.frc;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.slt;
	import me.feng3d.fagal.base.operation.tex;
	import me.feng3d.fagalRE.FagalRE;


	/**
	 * 阴影图采样比较计算阴影值
	 * @author warden_feng 2015-7-17
	 */
	public function F_ShadowMapSample():void
	{
		var _:* = FagalRE.instance.space;

		var depthCol:Register = getFreeTemp("深度值临时寄存器");
		var uvReg:Register = getFreeTemp("深度图uv临时寄存器");

		mov(uvReg, _.depthMapCoord_v); //计算阴影

		tex(depthCol, _.depthMapCoord_v, _.depthMap_fs); //读取阴影图值
		dp4(depthCol.z, depthCol, _.shadowCommondata0_fc_vector);
		slt(uvReg.z, _.depthMapCoord_v.z, depthCol.z); //比较深度 // 0 if in shadow

		add(uvReg.x, _.depthMapCoord_v.x, _.shadowCommondata2_fc_vector.z); //取(1,0)位置的深度值
		tex(depthCol, uvReg, _.depthMap_fs); //读取阴影图值
		dp4(depthCol.z, depthCol, _.shadowCommondata0_fc_vector);
		slt(uvReg.w, _.depthMapCoord_v.z, depthCol.z); //与(1,0)深度做比较 // 0 if in shadow

		mul(depthCol.x, _.depthMapCoord_v.x, _.shadowCommondata2_fc_vector.y); //计算顶点在阴影图的像素x位置
		frc(depthCol.x, depthCol.x); //取出分数部分  0<分数部分<1
		blend(_.shadowValue_ft_4.w, uvReg.z, uvReg.w, depthCol.x); //混合(0,0)与(1,0)的深度结果

		//与(0,1)深度做比较
		mov(uvReg.x, _.depthMapCoord_v.x);
		add(uvReg.y, _.depthMapCoord_v.y, _.shadowCommondata2_fc_vector.z); // (0, 1)
		tex(depthCol, uvReg, _.depthMap_fs);
		dp4(depthCol.z, depthCol, _.shadowCommondata0_fc_vector);
		slt(uvReg.z, _.depthMapCoord_v.z, depthCol.z); // 0 if in shadow

		//与(1,1)深度做比较
		add(uvReg.x, _.depthMapCoord_v.x, _.shadowCommondata2_fc_vector.z); // (1, 1)
		tex(depthCol, uvReg, _.depthMap_fs);
		dp4(depthCol.z, depthCol, _.shadowCommondata0_fc_vector);
		slt(uvReg.w, _.depthMapCoord_v.z, depthCol.z); // 0 if in shadow

		//根据X方向分数部分来混合(0,1)与(1,1)的深度结果  x1-x0
		mul(depthCol.x, _.depthMapCoord_v.x, _.shadowCommondata2_fc_vector.y);
		frc(depthCol.x, depthCol.x);
		blend(uvReg.w, uvReg.z, uvReg.w, depthCol.x);

		//再次根据Y方向分数部分来混合两次X方向混合的结果
		mul(depthCol.x, _.depthMapCoord_v.y, _.shadowCommondata2_fc_vector.y);
		frc(depthCol.x, depthCol.x);
		blend(_.shadowValue_ft_4.w, _.shadowValue_ft_4.w, uvReg.w, depthCol.x);

		removeTemp(depthCol);
		removeTemp(uvReg);
	}
}
