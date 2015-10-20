package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 粒子缩放节点顶点渲染程序
	 * @param scaleRegister				粒子缩放常数数据
	 * @param inCycleTimeTemp			粒子周期内时间临时寄存器
	 * @param animatedPosition			动画后的顶点坐标数据
	 * @author feng 2014-12-26
	 */
	public function V_ParticleScaleGlobal(scaleRegister:Register, inCycleTimeTemp:Register, animatedPosition:Register):void
	{
		var _:* = FagalRE.instance.space;

		var temp:Register = _.getFreeTemp();

//			if (_usesCycle) {
//				code += "mul " + temp + "," + animationRegisterCache.vertexTime + "," + scaleRegister + ".z\n";
//				
//				if (_usesPhase)
//					code += "add " + temp + "," + temp + "," + scaleRegister + ".w\n";
//				
//				code += "sin " + temp + "," + temp + "\n";
//			}

		_.mul(temp, scaleRegister.y, inCycleTimeTemp.y); //计算  随时间增量  = 差值 * 本周期比例
		_.add(temp, scaleRegister.x, temp); //缩放值 = 最小值 + 随时间增量
		_.mul(animatedPosition.xyz, animatedPosition.xyz, temp); //缩放应用到顶点坐标上

	}
}
