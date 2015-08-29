package me.feng3d.animators.particle.data
{

	/**
	 * 粒子属性模型
	 * @author warden_feng 2014-11-13
	 */
	public class ParticlePropertiesMode
	{
		/**
		 * 全局粒子属性，数据将上传至常量寄存器中
		 */
		public static const GLOBAL:uint = 0;

		/**
		 * 本地静态粒子属性，数据将上传顶点属性寄存器
		 */
		public static const LOCAL_STATIC:uint = 1;

	}
}
