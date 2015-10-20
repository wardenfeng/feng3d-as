package me.feng3d.core.partition.node
{
	import me.feng3d.core.math.Plane3D;
	import me.feng3d.core.traverse.PartitionTraverser;
	import me.feng3d.entities.SkyBox;

	/**
	 * 天空盒分区节点
	 * @author feng 2015-3-8
	 */
	public class SkyBoxNode extends EntityNode
	{
		private var _skyBox:SkyBox;

		/**
		 * 创建SkyBoxNode实例
		 * @param skyBox		天空盒实例
		 */
		public function SkyBoxNode(skyBox:SkyBox)
		{
			super(skyBox);
			_skyBox = skyBox;
		}

		/**
		 * @inheritDoc
		 */
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if (traverser.enterNode(this))
			{
				super.acceptTraverser(traverser);
				traverser.applySkyBox(_skyBox);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:int):Boolean
		{
			planes = planes;
			numPlanes = numPlanes;
			return true;
		}
	}
}
