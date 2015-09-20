package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterArray;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * UV动画顶点渲染程序
	 * @author warden_feng 2015-9-5
	 */
	public function V_UVAnimation(UVSource:Register, UVTarget:Register):void
	{
		var _:* = FagalRE.instance.space;

		var tempUV:Register = _.getFreeTemp();
		var tempUV2:Register = _.getFreeTemp("用点乘代替m44运算的临时寄存器");
		var uvTranslateReg:Register = _.uvAnimatorTranslate_vc_vector;
		var uvTransformReg:RegisterArray = _.uvAnimatorMatrix2d_vc_vector;

		_.mov(tempUV, UVSource);
		_.sub(tempUV.xy, tempUV.xy, uvTranslateReg.zw);

		//使用矩阵对UV操作（使用点乘代替矩阵运算）	_.m44(tempUV, tempUV, uvTransformReg);
		_.dp3(tempUV2.x, tempUV, uvTransformReg.getReg1(0));
		_.dp3(tempUV2.y, tempUV, uvTransformReg.getReg1(1));

		_.mov(tempUV.xy, tempUV2.xy);

		//计算平移缩放
		_.add(tempUV.xy, tempUV.xy, uvTranslateReg.xy);
		_.add(tempUV.xy, tempUV.xy, uvTranslateReg.zw);
		_.mov(UVTarget, tempUV);
	}
}
