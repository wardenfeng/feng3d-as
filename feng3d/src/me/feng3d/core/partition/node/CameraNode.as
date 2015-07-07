package me.feng3d.core.partition.node
{
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.traverse.PartitionTraverser;


	/**
	 * 摄像机分区节点
	 * @author warden_feng 2015-3-21
	 */
	public class CameraNode extends EntityNode
	{
		/**
		 * 创建一个摄像机分区节点
		 * @param camera		摄像机
		 */
		public function CameraNode(camera:Camera3D)
		{
			super(camera);
		}

		/**
		 * @inheritDoc
		 */
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
		}
	}
}
