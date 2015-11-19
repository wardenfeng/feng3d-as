package me.feng3d.entities
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.bounds.AxisAlignedBoundingBox;
	import me.feng3d.bounds.BoundingVolumeBase;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.core.partition.Partition3D;
	import me.feng3d.core.partition.node.EntityNode;
	import me.feng3d.core.pick.IPickingCollider;
	import me.feng3d.core.pick.PickingCollisionVO;
	import me.feng3d.mathlib.Matrix3DUtils;
	import me.feng3d.mathlib.Ray3D;

	use namespace arcane;

	/**
	 * Entity为所有场景绘制对象提供一个基类，表示存在场景中。可以被entityCollector收集。
	 * @author feng 2014-3-24
	 */
	public class Entity extends ObjectContainer3D
	{
		private var _showBounds:Boolean;
		private var _partitionNode:EntityNode;
		private var _boundsIsShown:Boolean = false;

		protected var _bounds:BoundingVolumeBase;
		protected var _boundsInvalid:Boolean = true;

		arcane var _pickingCollisionVO:PickingCollisionVO;
		arcane var _pickingCollider:IPickingCollider;

		private var _worldBounds:BoundingVolumeBase;
		private var _worldBoundsInvalid:Boolean = true;

		/**
		 * 创建一个实体，该类为虚类
		 */
		public function Entity()
		{
			super();

			_bounds = getDefaultBoundingVolume();
			_worldBounds = getDefaultBoundingVolume();
			AbstractClassError.check(this);
		}

		/**
		 * 是否显示边界
		 */
		public function get showBounds():Boolean
		{
			return _showBounds;
		}

		public function set showBounds(value:Boolean):void
		{
			if (value == _showBounds)
				return;

			_showBounds = value;

			if (_showBounds)
				addBounds();
			else
				removeBounds();
		}

		/**
		 * 添加边界
		 */
		private function addBounds():void
		{
			if (!_boundsIsShown)
			{
				_boundsIsShown = true;
				addChild(bounds.boundingRenderable);
			}
		}

		/**
		 * 移除边界
		 */
		private function removeBounds():void
		{
			if (_boundsIsShown)
			{
				_boundsIsShown = false;
				removeChild(_bounds.boundingRenderable);
				_bounds.disposeRenderable();
			}
		}

		/**
		 * 边界
		 */
		public function get bounds():BoundingVolumeBase
		{
			if (_boundsInvalid)
				updateBounds();

			return _bounds;
		}

		/**
		 * @inheritDoc
		 */
		override protected function invalidateSceneTransform():void
		{
			super.invalidateSceneTransform();
			_worldBoundsInvalid = true;
		}

		/**
		 * 边界失效
		 */
		protected function invalidateBounds():void
		{
			_boundsInvalid = true;
		}

		/**
		 * 获取默认边界（默认盒子边界）
		 * @return
		 */
		protected function getDefaultBoundingVolume():BoundingVolumeBase
		{
			return new AxisAlignedBoundingBox();
		}

		/**
		 * 更新边界
		 */
		protected function updateBounds():void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 获取碰撞数据
		 */
		public function get pickingCollisionVO():PickingCollisionVO
		{
			if (!_pickingCollisionVO)
				_pickingCollisionVO = new PickingCollisionVO(this);

			return _pickingCollisionVO;
		}

		/**
		 * 判断射线是否穿过实体
		 * @param ray3D
		 * @return
		 */
		public function isIntersectingRay(ray3D:Ray3D):Boolean
		{
			if (!pickingCollisionVO.localNormal)
				pickingCollisionVO.localNormal = new Vector3D();

			//转换到当前实体坐标系空间
			var localRay:Ray3D = pickingCollisionVO.localRay;

			Matrix3DUtils.updateLocalRay(inverseSceneTransform, ray3D, localRay);

			//检测射线与边界的碰撞
			var rayEntryDistance:Number = bounds.rayIntersection(localRay, pickingCollisionVO.localNormal);
			if (rayEntryDistance < 0)
				return false;

			//保存碰撞数据
			pickingCollisionVO.rayEntryDistance = rayEntryDistance;
			pickingCollisionVO.ray3D = ray3D;
			pickingCollisionVO.rayOriginIsInsideBounds = rayEntryDistance == 0;

			return true;
		}

		/**
		 * 获取采集的碰撞
		 */
		public function get pickingCollider():IPickingCollider
		{
			return _pickingCollider;
		}

		public function set pickingCollider(value:IPickingCollider):void
		{
			_pickingCollider = value;
		}

		/**
		 * 碰撞前设置碰撞状态
		 * @param shortestCollisionDistance 最短碰撞距离
		 * @param findClosest 是否寻找最优碰撞
		 * @return
		 */
		arcane function collidesBefore(shortestCollisionDistance:Number, findClosest:Boolean):Boolean
		{
			return true;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function set implicitPartition(value:Partition3D):void
		{
			if (value == _implicitPartition)
				return;

			if (_implicitPartition)
				notifyPartitionUnassigned();

			super.implicitPartition = value;

			notifyPartitionAssigned();
		}

		/**
		 * 通知场景一个新分区已分配
		 */
		private function notifyPartitionAssigned():void
		{
			if (_scene)
				_scene.registerPartition(this);
		}

		/**
		 * 通知场景一个分区取消分配
		 */
		private function notifyPartitionUnassigned():void
		{
			if (_scene)
				_scene.unregisterPartition(this);
		}

		/**
		 * @inheritDoc
		 */
		override public function set scene(value:Scene3D):void
		{
			if (value == _scene)
				return;

			if (_scene)
				_scene.unregisterEntity(this);

			if (value)
				value.registerEntity(this);

			super.scene = value;
		}

		/**
		 * 获取实体分区节点
		 */
		public function getEntityPartitionNode():EntityNode
		{
			return _partitionNode ||= createEntityPartitionNode();
		}

		/**
		 * 创建实体分区节点，该函数为虚函数，需要子类重写。
		 */
		protected function createEntityPartitionNode():EntityNode
		{
			throw new AbstractMethodError();
		}


		/**
		 * 内部更新
		 */
		arcane function internalUpdate():void
		{
			if (_controller)
				_controller.update();
		}

		/**
		 * 世界边界
		 */
		public function get worldBounds():BoundingVolumeBase
		{
			if (_worldBoundsInvalid)
				updateWorldBounds();

			return _worldBounds;
		}

		/**
		 * 更新世界边界
		 */
		private function updateWorldBounds():void
		{
			_worldBounds.transformFrom(bounds, sceneTransform);
			_worldBoundsInvalid = false;
		}

		/**
		 * The transformation matrix that transforms from model to world space, adapted with any special operations needed to render.
		 * For example, assuring certain alignedness which is not inherent in the scene transform. By default, this would
		 * return the scene transform.
		 */
		public function getRenderSceneTransform(camera:Camera3D):Matrix3D
		{
			return sceneTransform;
		}
	}
}
