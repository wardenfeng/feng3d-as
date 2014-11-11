package me.feng3d.entities
{
	import flash.geom.Vector3D;
	
	import me.feng3d.arcane;
	import me.feng3d.bounds.AxisAlignedBoundingBox;
	import me.feng3d.bounds.BoundingVolumeBase;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.core.math.Matrix3DUtils;
	import me.feng3d.core.math.Ray3D;
	import me.feng3d.core.pick.IPickingCollider;
	import me.feng3d.core.pick.PickingCollisionVO;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.errors.AbstractMethodError;

	use namespace arcane;

	/**
	 * Entity为所有场景绘制对象提供一个基类，表示存在场景中。可以被entityCollector收集。
	 * @author warden_feng 2014-3-24
	 */
	public class Entity extends ObjectContainer3D
	{
		private var _showBounds:Boolean;
		private var _boundsIsShown:Boolean = false;

		protected var _bounds:BoundingVolumeBase;
		protected var _boundsInvalid:Boolean = true;

		arcane var _pickingCollisionVO:PickingCollisionVO;
		arcane var _pickingCollider:IPickingCollider;

		public function Entity()
		{
			super();

			_bounds = getDefaultBoundingVolume();
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

		public function render(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			throw new AbstractMethodError();
		}
	}
}
