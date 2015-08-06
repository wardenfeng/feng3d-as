package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 粒子颜色节点顶点渲染程序
	 * @author warden_feng 2015-1-20
	 */
	public function V_ParticleColorGlobal(startMultiplierValue:Register, deltaMultiplierValue:Register, startOffsetValue:Register, deltaOffsetValue:Register, inCycleTimeTemp:Register, colorMulTarget:Register, colorAddTarget:Register):void
	{
		var _:* = FagalRE.instance.space;

		var temp:Register = getFreeTemp();

//			if (animationRegisterCache.needFragmentAnimation) {
//				var temp:ShaderRegisterElement = animationRegisterCache.getFreeVertexVectorTemp();

//				if (_usesCycle) {
//					var cycleConst:ShaderRegisterElement = animationRegisterCache.getFreeVertexConstant();
//					animationRegisterCache.setRegisterIndex(this, CYCLE_INDEX, cycleConst.index);
//					
//					animationRegisterCache.addVertexTempUsages(temp, 1);
//					var sin:ShaderRegisterElement = animationRegisterCache.getFreeVertexSingleTemp();
//					animationRegisterCache.removeVertexTempUsage(temp);
//					
//					code += "mul " + sin + "," + animationRegisterCache.vertexTime + "," + cycleConst + ".x\n";
//					
//					if (_usesPhase)
//						code += "add " + sin + "," + sin + "," + cycleConst + ".y\n";
//					
//					code += "sin " + sin + "," + sin + "\n";
//				}

//				if (_usesMultiplier) {
//					var startMultiplierValue:ShaderRegisterElement = (_mode == ParticlePropertiesMode.GLOBAL)? animationRegisterCache.getFreeVertexConstant() : animationRegisterCache.getFreeVertexAttribute();
//					var deltaMultiplierValue:ShaderRegisterElement = (_mode == ParticlePropertiesMode.GLOBAL)? animationRegisterCache.getFreeVertexConstant() : animationRegisterCache.getFreeVertexAttribute();
//					
//					animationRegisterCache.setRegisterIndex(this, START_MULTIPLIER_INDEX, startMultiplierValue.index);
//					animationRegisterCache.setRegisterIndex(this, DELTA_MULTIPLIER_INDEX, deltaMultiplierValue.index);

		_.mul(temp, deltaMultiplierValue, inCycleTimeTemp.y);
		_.add(temp, temp, startMultiplierValue);
		_.mul(colorMulTarget, temp, colorMulTarget);
//				}

//				if (_usesOffset) {
//					var startOffsetValue:ShaderRegisterElement = (_mode == ParticlePropertiesMode.LOCAL_STATIC)? animationRegisterCache.getFreeVertexAttribute() : animationRegisterCache.getFreeVertexConstant();
//					var deltaOffsetValue:ShaderRegisterElement = (_mode == ParticlePropertiesMode.LOCAL_STATIC)? animationRegisterCache.getFreeVertexAttribute() : animationRegisterCache.getFreeVertexConstant();
//					
//					animationRegisterCache.setRegisterIndex(this, START_OFFSET_INDEX, startOffsetValue.index);
//					animationRegisterCache.setRegisterIndex(this, DELTA_OFFSET_INDEX, deltaOffsetValue.index);

		_.mul(temp, deltaOffsetValue, inCycleTimeTemp.y);
		_.add(temp, temp, startOffsetValue);
		_.add(colorAddTarget, temp, colorAddTarget);
//				}
//			}

	}
}
