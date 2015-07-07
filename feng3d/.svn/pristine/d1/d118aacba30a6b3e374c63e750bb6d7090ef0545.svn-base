package me.feng3d.core.partition.node
{
	import me.feng3d.core.traverse.PartitionTraverser;
	import me.feng3d.lights.PointLight;


	/**
	 * 点光源分区节点
	 * @author warden_feng 2015-3-23
	 */
	public class PointLightNode extends EntityNode
	{
		private var _light:PointLight;

		/**
		 * 创建一个点光源分区节点
		 * @param light		点光源
		 */
		public function PointLightNode(light:PointLight)
		{
			super(light);
			_light = light;
		}

		/**
		 * 点光源
		 */
		public function get light():PointLight
		{
			return _light;
		}

		/**
		 * @inheritDoc
		 */
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if (traverser.enterNode(this))
			{
				super.acceptTraverser(traverser);
				traverser.applyPointLight(_light);
			}
		}
	}
}
