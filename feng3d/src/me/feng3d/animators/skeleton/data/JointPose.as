package me.feng3d.animators.skeleton.data
{
	import flash.geom.Vector3D;

	import me.feng3d.mathlib.Quaternion;

	/**
	 * 关节pose
	 * @author feng 2014-5-20
	 */
	public class JointPose
	{
		/** 旋转信息 */
		public var orientation:Quaternion = new Quaternion();

		/** 位移信息 */
		public var translation:Vector3D = new Vector3D();

		public function JointPose()
		{
		}
	}
}
