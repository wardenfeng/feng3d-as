package me.feng3d.animators.skeleton.data
{
	import me.feng.core.NamedAsset;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;


	/**
	 * 骨骼pose
	 * @author feng 2014-5-20
	 */
	public class SkeletonPose extends NamedAsset implements IAsset
	{
		/** 关节pose列表 */
		public var jointPoses:Vector.<JointPose>;

		public function get numJointPoses():uint
		{
			return jointPoses.length;
		}

		public function SkeletonPose()
		{
			jointPoses = new Vector.<JointPose>();
		}

		public function get assetType():String
		{
			return AssetType.SKELETON_POSE;
		}
	}
}
