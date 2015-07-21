package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.m33;

	/**
	 * 粒子广告牌节点顶点渲染程序
	 * @param particleBillboardMtx			广告牌旋转矩阵(3个长度向量形式)
	 * @param animatedPosition				动画后的顶点坐标数据
	 * @author warden_feng 2014-12-26
	 */
	public function V_ParticleBillboard(particleBillboardMtx:Register,animatedPosition:Register):void
	{
		//使用广告牌 朝向摄像机
		m33(animatedPosition.xyz, animatedPosition.xyz, particleBillboardMtx); //计算旋转
	}
}
