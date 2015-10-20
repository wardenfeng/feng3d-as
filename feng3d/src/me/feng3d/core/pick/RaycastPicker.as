package me.feng3d.core.pick
{
	import me.feng3d.arcane;
	import me.feng3d.core.math.Ray3D;
	import me.feng3d.entities.Entity;

	use namespace arcane;

	/**
	 * 光线投射采集
	 * @author feng 2014-4-29
	 */
	public class RaycastPicker
	{
		/** 是否需要寻找最接近的 */
		private var _findClosestCollision:Boolean;

		protected var _entities:Vector.<Entity>;

		/**
		 *
		 * @param findClosestCollision 是否需要寻找最接近的
		 */
		public function RaycastPicker(findClosestCollision:Boolean)
		{
			_findClosestCollision = findClosestCollision;
		}

		/**
		 * 获取射线穿过的实体
		 * @param ray3D 射线
		 * @param entitys 实体列表
		 * @return
		 */
		public function getViewCollision(ray3D:Ray3D, entitys:Vector.<Entity>):PickingCollisionVO
		{
			_entities = new Vector.<Entity>();

			if (entitys.length == 0)
				return null;

			for each (var entity:Entity in entitys)
			{
				if (entity.isIntersectingRay(ray3D))
					_entities.push(entity);
			}
			if (_entities.length == 0)
				return null;

			return getPickingCollisionVO();
		}

		/**
		 *获取射线穿过的实体
		 */
		private function getPickingCollisionVO():PickingCollisionVO
		{
			// Sort entities from closest to furthest.
			_entities = _entities.sort(sortOnNearT);

			// ---------------------------------------------------------------------
			// Evaluate triangle collisions when needed.
			// Replaces collision data provided by bounds collider with more precise data.
			// ---------------------------------------------------------------------

			var shortestCollisionDistance:Number = Number.MAX_VALUE;
			var bestCollisionVO:PickingCollisionVO;
			var pickingCollisionVO:PickingCollisionVO;
			var entity:Entity;
			var i:uint;

			for (i = 0; i < _entities.length; ++i)
			{
				entity = _entities[i];
				pickingCollisionVO = entity._pickingCollisionVO;
				if (entity.pickingCollider)
				{
					// If a collision exists, update the collision data and stop all checks.
					if ((bestCollisionVO == null || pickingCollisionVO.rayEntryDistance < bestCollisionVO.rayEntryDistance) && entity.collidesBefore(shortestCollisionDistance, _findClosestCollision))
					{
						shortestCollisionDistance = pickingCollisionVO.rayEntryDistance;
						bestCollisionVO = pickingCollisionVO;
						if (!_findClosestCollision)
						{
							updateLocalPosition(pickingCollisionVO);
							return pickingCollisionVO;
						}
					}
				}
				else if (bestCollisionVO == null || pickingCollisionVO.rayEntryDistance < bestCollisionVO.rayEntryDistance)
				{ // A bounds collision with no triangle collider stops all checks.
					// Note: a bounds collision with a ray origin inside its bounds is ONLY ever used
					// to enable the detection of a corresponsding triangle collision.
					// Therefore, bounds collisions with a ray origin inside its bounds can be ignored
					// if it has been established that there is NO triangle collider to test
					if (!pickingCollisionVO.rayOriginIsInsideBounds)
					{
						updateLocalPosition(pickingCollisionVO);
						return pickingCollisionVO;
					}
				}
			}

			return bestCollisionVO;
		}

		/**
		 * 按与射线原点距离排序
		 */
		private function sortOnNearT(entity1:Entity, entity2:Entity):Number
		{
			return entity1.pickingCollisionVO.rayEntryDistance > entity2.pickingCollisionVO.rayEntryDistance ? 1 : -1;
		}

		/**
		 * 更新碰撞本地坐标
		 * @param pickingCollisionVO
		 */
		private function updateLocalPosition(pickingCollisionVO:PickingCollisionVO):void
		{
			pickingCollisionVO.localPosition = pickingCollisionVO.localRay.getPoint(pickingCollisionVO.rayEntryDistance);
		}
	}
}
