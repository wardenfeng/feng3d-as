package me.feng3d.core.partition.node
{
	import me.feng3d.arcane;
	import me.feng3d.core.math.Plane3D;
	import me.feng3d.entities.Entity;

	use namespace arcane;

	/**
	 * 实体分区节点
	 * @author warden_feng 2015-3-8
	 */
	public class EntityNode extends NodeBase
	{
		/**
		 * 节点中的实体
		 */
		private var _entity:Entity;

		/**
		 * 指向队列中下个更新的实体分区节点
		 */
		arcane var _updateQueueNext:EntityNode;

		/**
		 * 创建一个实体分区节点
		 * @param entity		实体
		 */
		public function EntityNode(entity:Entity)
		{
			super();
			_entity = entity;
			_numEntities = 1;
		}

		/**
		 * 从父节点中移除
		 */
		public function removeFromParent():void
		{
			if (_parent)
				_parent.removeNode(this);

			_parent = null;
		}

		/**
		 * 实体
		 */
		public function get entity():Entity
		{
			return _entity;
		}

		/**
		 * @inheritDoc
		 */
		override public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:int):Boolean
		{
			if (!_entity.sceneVisible)
				return false;

			return _entity.worldBounds.isInFrustum(planes, numPlanes);
		}

	}
}
