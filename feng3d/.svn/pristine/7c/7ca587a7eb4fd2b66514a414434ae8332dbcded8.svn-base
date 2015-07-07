package me.feng3d.animators.skeleton.data
{
	import me.feng.events.FEventDispatcher;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	
	
	/**
	 * 骨骼数据
	 * @author warden_feng 2014-5-20
	 */
	public class Skeleton extends FEventDispatcher implements IAsset
	{
		/** 骨骼关节数据列表 */
		public var joints:Vector.<SkeletonJoint>;
		
		public function Skeleton()
		{
			joints = new Vector.<SkeletonJoint>();
		}
		
		public function get numJoints():uint
		{
			return joints.length;
		}
		
		public function get assetType():String
		{
			return AssetType.SKELETON;
		}
	}
}