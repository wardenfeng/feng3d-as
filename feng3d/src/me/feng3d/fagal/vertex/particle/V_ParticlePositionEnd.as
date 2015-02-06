package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;
	
	/**
	 * 粒子结算偏移坐标渲染程序
	 * @author warden_feng 2014-12-26
	 */
	public class V_ParticlePositionEnd extends FagalVertexMethod
	{
		[Register(regName = "animatedPosition_vt_4", regType = "in", description = "动画后的顶点坐标数据")]
		public var animatedPosition:Register;
		
		[Register(regName = "positionTemp_vt_4", regType = "in", description = "偏移坐标临时寄存器")]
		public var positionTemp:Register;
		
		override public function runFunc():void
		{
			add(animatedPosition.xyz, animatedPosition.xyz, positionTemp.xyz); //得到最终坐标
		}
	}
}