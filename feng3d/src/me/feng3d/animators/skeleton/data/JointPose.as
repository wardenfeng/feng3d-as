package me.feng3d.animators.skeleton.data
{
	import flash.geom.Matrix3D;
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

		/**
		 * Converts the transformation to a Matrix3D representation.
		 *
		 * @param target An optional target matrix to store the transformation. If not provided, it will create a new instance.
		 * @return The transformation matrix of the pose.
		 */
		public function toMatrix3D(target:Matrix3D = null):Matrix3D
		{
			target ||= new Matrix3D();
			orientation.toMatrix3D(target);
			target.appendTranslation(translation.x, translation.y, translation.z);
			return target;
		}
	}
}
