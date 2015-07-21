package me.feng3d.fagal.context3dDataIds
{

	/**
	 * 粒子相关Context3D缓存id
	 * @author warden_feng 2014-11-18
	 */
	public class ParticleContext3DBufferID
	{
		/** 粒子常数数据[0,1,2,0] */
		public static const PARTICLECOMMON_VC_VECTOR:String = "particleCommon_vc_vector";

		/** 广告牌旋转矩阵 */
		public static const PARTICLEBILLBOARD_VC_MATRIX:String = "particleBillboard_vc_matrix";

		//--------------------------------
		//		缩放节点
		//--------------------------------
		/** 粒子缩放常数数据 */
		public static const PARTICLESCALE_VC_VECTOR:String = "particleScale_vc_vector";

		//--------------------------------
		//		时间节点
		//--------------------------------
		/** 粒子时间数据 */
		public static const PARTICLETIME_VA_4:String = "particleTime_va_4";

		/** 粒子时间常量数据 */
		public static const PARTICLETIME_VC_VECTOR:String = "particleTime_vc_vector";

		//--------------------------------
		//		速度节点
		//--------------------------------
		/** 粒子速度数据 */
		public static const PARTICLEVELOCITY_VA_3:String = "particleVelocity_va_3";

		/** 粒子速度常数数据 */
		public static const PARTICLEVELOCITY_VC_VECTOR:String = "particleVelocity_vc_vector";

		//--------------------------------
		//		颜色节点
		//--------------------------------
		/** 粒子颜色乘数因子起始值，用于计算粒子颜色乘数因子 */
		public static const PARTICLESTARTCOLORMULTIPLIER_VC_VECTOR:String = "particleStartColorMultiplier_vc_vector";
		
		/** 粒子颜色乘数因子增量值，用于计算粒子颜色乘数因子 */
		public static const PARTICLEDELTACOLORMULTIPLIER_VC_VECTOR:String = "particleDeltaColorMultiplier_vc_vector";

		/** 粒子颜色偏移起始值，用于计算粒子颜色偏移值 */
		public static const PARTICLESTARTCOLOROFFSET_VC_VECTOR:String = "particleStartColorOffset_vc_vector";
		
		/** 粒子颜色偏移增量值，用于计算粒子颜色偏移值 */
		public static const PARTICLEDELTACOLOROFFSET_VC_VECTOR:String = "particleDeltaColorOffset_vc_vector";
		
		/** 粒子颜色乘数因子，用于乘以纹理上的颜色值 */
		public static const PARTICLECOLORMULTIPLIER_V:String = "particleColorMultiplier_v";
		
		/** 粒子颜色乘数因子，用于乘以纹理上的颜色值 */
		public static const PARTICLECOLOROFFSET_V:String = "particleColorOffset_v";
		
	}
}
