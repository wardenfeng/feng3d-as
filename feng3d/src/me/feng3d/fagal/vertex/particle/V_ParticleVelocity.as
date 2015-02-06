package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;

	/**
	 * 粒子速度节点顶点渲染程序
	 * @author warden_feng 2014-12-26
	 */
	public class V_ParticleVelocity extends FagalVertexMethod
	{
		[Register(regName = "particleVelocity_va_3", regType = "in", description = "粒子速度数据")]
		public var particleVelocity:Register;
		
		[Register(regName = "positionTemp_vt_4", regType = "in", description = "偏移坐标临时寄存器")]
		public var positionTemp:Register;
		
		[Register(regName = "inCycleTime_vt_4", regType = "out", description = "粒子周期内时间临时寄存器")]
		public var inCycleTimeTemp:Register;
		
		override public function runFunc():void
		{
			var vt3:Register = getFreeTemp();

			//计算速度
			mul(vt3, inCycleTimeTemp.x, particleVelocity); //时间*速度
			add(positionTemp.xyz, vt3, positionTemp.xyz); //计算偏移量
		}
	}
}
