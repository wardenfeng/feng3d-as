package me.feng3d.containers
{
	import flash.utils.Dictionary;

	import me.feng3d.arcane;
	import me.feng3d.core.base.Object3D;
	import me.feng3d.core.partition.node.NodeBase;
	import me.feng3d.core.partition.Partition3D;
	import me.feng3d.core.traverse.PartitionTraverser;
	import me.feng3d.entities.Entity;

	use namespace arcane;

	/**
	 * 3d场景
	 * @author feng 2014-3-17
	 */
	public class Scene3D extends Container3D
	{
		private var _partitions:Vector.<Partition3D>;

		/** 实体字典 */
		private var _entityDic:Dictionary;

		private var _displayEntityDic:Dictionary;

		private var _mouseCollisionEntitys:Vector.<Entity>;

		/**
		 * 创建一个3d场景
		 */
		public function Scene3D()
		{
			_isRoot = true;
			_scene = this;

			_entityDic = new Dictionary();
			_displayEntityDic = new Dictionary();
			_mouseCollisionEntitys = new Vector.<Entity>();

			_partitions = new Vector.<Partition3D>();

			partition = new Partition3D(new NodeBase());
		}

		/** 显示实体字典 */
		public function get displayEntityDic():Dictionary
		{
			return _displayEntityDic;
		}

		/**
		 * 添加对象到场景
		 * @param object3D		3d对象
		 */
		arcane function addedObject3d(object3D:Object3D):void
		{
			if (object3D is Entity)
			{
				_entityDic[object3D.name] = object3D;
				if (object3D.visible)
				{
					_displayEntityDic[object3D.name] = object3D;
				}
			}
		}

		/**
		 * 从场景中移除对象
		 * @param object3D	3d对象
		 */
		arcane function removedObject3d(object3D:Object3D):void
		{
			delete _entityDic[object3D.name];
			delete _displayEntityDic[object3D.name];
		}

		/**
		 * 收集需要检测鼠标碰撞的实体
		 */
		public function collectMouseCollisionEntitys():void
		{
			_mouseCollisionEntitys.length = 0;

			//3d对象堆栈
			var mouseCollisionStack:Vector.<Object3D> = new Vector.<Object3D>();
			mouseCollisionStack.push(this);

			var object3D:Object3D;
			var entity:Entity;
			var container3D:Container3D;
			//遍历堆栈中需要检测鼠标碰撞的实体
			while (mouseCollisionStack.length > 0)
			{
				object3D = mouseCollisionStack.pop();
				if (!object3D.visible)
					continue;
				entity = object3D as Entity;
				container3D = object3D as Container3D;
				//收集需要检测鼠标碰撞的实体到检测列表
				if (entity && entity.mouseEnabled)
				{
					_mouseCollisionEntitys.push(object3D as Entity);
				}
				//收集容器内子对象到堆栈
				if (container3D && container3D.mouseChildren)
				{
					var len:uint = container3D.numChildren;
					for (var i:int = 0; i < len; i++)
					{
						mouseCollisionStack.push(container3D.getChildAt(i));
					}
				}
			}
		}

		/**
		 * 需要检测鼠标碰撞的实体
		 */
		public function get mouseCollisionEntitys():Vector.<Entity>
		{
			return _mouseCollisionEntitys;
		}

		/**
		 * 横穿分区
		 * @param traverser 横越者
		 */
		public function traversePartitions(traverser:PartitionTraverser):void
		{
			var i:uint;
			var len:uint = _partitions.length;

			traverser.scene = this;

			while (i < len)
			{
				_partitions[i].traverse(traverser);
				i = i + 1;
			}
		}

		/**
		 * 注销实体
		 * @param entity	实体
		 */
		arcane function unregisterEntity(entity:Entity):void
		{
			entity.implicitPartition.removeEntity(entity);
		}

		/**
		 * 注册实体
		 * @param entity		实体
		 */
		arcane function registerEntity(entity:Entity):void
		{
			var partition:Partition3D = entity.implicitPartition;
			addPartitionUnique(partition);

			partition.markForUpdate(entity);
		}

		/**
		 * 添加分区，如果不在列表中
		 * @param partition		分区
		 */
		protected function addPartitionUnique(partition:Partition3D):void
		{
			if (_partitions.indexOf(partition) == -1)
				_partitions.push(partition);
		}

		/**
		 * 注册分区
		 * @param entity	注册分区的实体
		 */
		arcane function registerPartition(entity:Entity):void
		{
			addPartitionUnique(entity.implicitPartition);
		}

		/**
		 * 注销分区
		 * @param entity	注销分区的实体
		 */
		arcane function unregisterPartition(entity:Entity):void
		{
			// todo: wait... is this even correct?
			// shouldn't we check the number of children in implicitPartition and remove partition if 0?
			entity.implicitPartition.removeEntity(entity);
		}
	}
}
