package me.feng3d.core.partition.node
{
	import me.feng3d.core.traverse.PartitionTraverser;
	import me.feng3d.lights.DirectionalLight;

	/**
	 * 方向光分区节点
	 * @author feng 2015-3-21
	 */
	public class DirectionalLightNode extends EntityNode
	{
		private var _light:DirectionalLight;

		/**
		 * 创建一个方向光分区节点
		 * @param light 		方向光
		 */
		public function DirectionalLightNode(light:DirectionalLight)
		{
			super(light);
			_light = light;
		}

		/**
		 * 方向光
		 */
		public function get light():DirectionalLight
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
				traverser.applyDirectionalLight(_light);
			}
		}
	}
}
