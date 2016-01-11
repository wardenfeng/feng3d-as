package me.feng3d.animators.skeleton.data
{
	import me.feng.component.Component;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAsset;


	/**
	 * 骨骼pose
	 * @author feng 2014-5-20
	 */
	public class SkeletonPose extends Component implements IAsset
	{
		private var _namedAsset:NamedAsset;
		/** 关节pose列表 */
		public var jointPoses:Vector.<JointPose>;

		public function get numJointPoses():uint
		{
			return jointPoses.length;
		}

		public function SkeletonPose()
		{
			_namedAsset = new NamedAsset(this,AssetType.SKELETON_POSE);
			jointPoses = new Vector.<JointPose>();
		}

		public function get namedAsset():NamedAsset
		{
			return _namedAsset;
		}
	}
}
