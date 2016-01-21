package me.feng3d.animators.skeleton.data
{
	import me.feng.component.Component;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAsset;


	/**
	 * 骨骼数据
	 * @author feng 2014-5-20
	 */
	public class Skeleton extends Component implements IAsset
	{
		private var _namedAsset:NamedAsset;
		/** 骨骼关节数据列表 */
		public var joints:Vector.<SkeletonJoint>;

		public function Skeleton()
		{
			_namedAsset = new NamedAsset(this,AssetType.SKELETON);
			joints = new Vector.<SkeletonJoint>();
		}

		public function get numJoints():uint
		{
			return joints.length;
		}
		
		public function get namedAsset():NamedAsset
		{
			return _namedAsset;
		}
	}
}
