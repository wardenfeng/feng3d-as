package me.feng3d.animators.data
{
	
	/**
	 * 骨骼关节数据
	 * @author warden_feng 2014-5-20
	 */
	public class SkeletonJoint
	{
		/** 父关节索引 （-1说明本身是总父节点，这个序号其实就是行号了，譬如上面”origin“节点的序号就是0，无父节点； "body"节点序号是1，父节点序号是0，也就是说父节点是”origin“）*/
		public var parentIndex:int = -1;
		
		/** 关节名字 */
		public var name:String;
		
		/** bind-pose姿态下节点的位置（位移）和旋转 */
		public var inverseBindPose:Vector.<Number>;
		
		public function SkeletonJoint()
		{
		}
	}
}