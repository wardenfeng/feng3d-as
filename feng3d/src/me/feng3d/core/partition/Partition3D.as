package me.feng3d.core.partition
{
	import me.feng3d.arcane;
	import me.feng3d.core.traverse.PartitionTraverser;
	import me.feng3d.entities.Entity;
	import me.feng3d.core.partition.node.EntityNode;
	import me.feng3d.core.partition.node.NodeBase;
	import me.feng3d.core.partition.node.NullNode;

	use namespace arcane;

	/**
	 * 3D空间分区
	 * <p>用于把3D空间分区，便于搜索出有必要渲染的对象，从而优化性能</p>
	 * @author warden_feng 2015-3-5
	 */
	public class Partition3D
	{
		/**
		 * 分区根节点
		 */
		protected var _rootNode:NodeBase;
		/**
		 * 待更新链表脏标记，true表示需要更新
		 */
		private var _updatesMade:Boolean;
		/**
		 * 待更新链表
		 */
		private var _updateQueue:EntityNode;

		/**
		 * 创建一个3D空间分区
		 * @param rootNode	根节点
		 */
		public function Partition3D(rootNode:NodeBase)
		{
			_rootNode = rootNode || new NullNode();
		}

		/**
		 * 发送一个横越者穿过分区
		 * @param traverser		横越者
		 */
		public function traverse(traverser:PartitionTraverser):void
		{
			if (_updatesMade)
				updateEntities();

			//更新收集标记
			++PartitionTraverser._collectionMark;

			//接受一个穿越者来收集实体
			_rootNode.acceptTraverser(traverser);
		}

		/**
		 * 从分区树种移除实体
		 * @param entity 被移除实体
		 */
		arcane function removeEntity(entity:Entity):void
		{
			var node:EntityNode = entity.getEntityPartitionNode();
			var t:EntityNode;

			//从父节点中移除
			node.removeFromParent();

			//链表中移除节点
			if (node == _updateQueue)
				_updateQueue = node._updateQueueNext;
			else
			{
				t = _updateQueue;
				while (t && t._updateQueueNext != node)
					t = t._updateQueueNext;
				//连接删除节点的前节点与后节点
				if (t)
					t._updateQueueNext = node._updateQueueNext;
			}

			//清空删除节点的next指针
			node._updateQueueNext = null;

			if (!_updateQueue)
				_updatesMade = false;
		}

		/**
		 * 标记为待更新节点，把新节点添加到待更新节点链表表头
		 * @param entity	更新的实体
		 */
		arcane function markForUpdate(entity:Entity):void
		{
			var node:EntityNode = entity.getEntityPartitionNode();

			//链表中添加节点到表头
			var t:EntityNode = _updateQueue;

			//判断节点是否已经存在链表中
			while (t)
			{
				if (node == t)
					return;

				t = t._updateQueueNext;
			}

			//把表头添加到新节点的next指针
			node._updateQueueNext = _updateQueue;

			//把新节点设置为表头
			_updateQueue = node;
			_updatesMade = true;
		}

		/**
		 * 更新待更新节点中的实体
		 */
		private function updateEntities():void
		{
			var node:EntityNode = _updateQueue;
			var targetNode:NodeBase;
			var t:EntityNode;

			//为了重新标记实体，清除更新队列
			_updateQueue = null;
			_updatesMade = false;

			do
			{
				targetNode = _rootNode.findPartitionForEntity(node.entity);

				// 更新 待更新链表中节点的父节点
				if (node.parent != targetNode)
				{
					if (node)
						node.removeFromParent();

					targetNode.addNode(node);
				}

				//获取链表中下个节点
				t = node._updateQueueNext;
				node._updateQueueNext = null;

				//调用节点实体的内部更新
				node.entity.internalUpdate();

			} while ((node = t) != null);
		}
	}
}
