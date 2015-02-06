package me.feng3d.bounds
{
	import flash.geom.Vector3D;
	
	import me.feng3d.core.math.Ray3D;
	import me.feng3d.primitives.WireframeCube;
	import me.feng3d.primitives.WireframePrimitiveBase;

	/**
	 * 轴对称边界盒子
	 * @author warden_feng 2014-4-27
	 */
	public class AxisAlignedBoundingBox extends BoundingVolumeBase
	{
		private var _centerX:Number = 0;
		private var _centerY:Number = 0;
		private var _centerZ:Number = 0;
		private var _halfExtentsX:Number = 0;
		private var _halfExtentsY:Number = 0;
		private var _halfExtentsZ:Number = 0;

		public function AxisAlignedBoundingBox()
		{
			super();
		}

		override protected function createBoundingRenderable():WireframePrimitiveBase
		{
			return new WireframeCube(1, 1, 1, 0xffffff, 0.5);
		}

		override protected function updateBoundingRenderable():void
		{
			_boundingRenderable.scaleX = Math.max(_halfExtentsX * 2, 0.001);
			_boundingRenderable.scaleY = Math.max(_halfExtentsY * 2, 0.001);
			_boundingRenderable.scaleZ = Math.max(_halfExtentsZ * 2, 0.001);
			_boundingRenderable.x = _centerX;
			_boundingRenderable.y = _centerY;
			_boundingRenderable.z = _centerZ;
		}

		override public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void
		{
			_centerX = (maxX + minX) * .5;
			_centerY = (maxY + minY) * .5;
			_centerZ = (maxZ + minZ) * .5;
			_halfExtentsX = (maxX - minX) * .5;
			_halfExtentsY = (maxY - minY) * .5;
			_halfExtentsZ = (maxZ - minZ) * .5;
			super.fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);
		}

		override public function rayIntersection(ray3D:Ray3D, targetNormal:Vector3D):Number
		{
			var position:Vector3D = ray3D.position;
			var direction:Vector3D = ray3D.direction;
			if (containsPoint(position))
				return 0;

			var px:Number = position.x - _centerX, py:Number = position.y - _centerY, pz:Number = position.z - _centerZ;
			var vx:Number = direction.x, vy:Number = direction.y, vz:Number = direction.z;
			var ix:Number, iy:Number, iz:Number;
			var rayEntryDistance:Number;

			// ray-plane tests
			var intersects:Boolean;
			if (vx < 0)
			{
				rayEntryDistance = (_halfExtentsX - px) / vx;
				if (rayEntryDistance > 0)
				{
					iy = py + rayEntryDistance * vy;
					iz = pz + rayEntryDistance * vz;
					if (iy > -_halfExtentsY && iy < _halfExtentsY && iz > -_halfExtentsZ && iz < _halfExtentsZ)
					{
						targetNormal.x = 1;
						targetNormal.y = 0;
						targetNormal.z = 0;

						intersects = true;
					}
				}
			}
			if (!intersects && vx > 0)
			{
				rayEntryDistance = (-_halfExtentsX - px) / vx;
				if (rayEntryDistance > 0)
				{
					iy = py + rayEntryDistance * vy;
					iz = pz + rayEntryDistance * vz;
					if (iy > -_halfExtentsY && iy < _halfExtentsY && iz > -_halfExtentsZ && iz < _halfExtentsZ)
					{
						targetNormal.x = -1;
						targetNormal.y = 0;
						targetNormal.z = 0;
						intersects = true;
					}
				}
			}
			if (!intersects && vy < 0)
			{
				rayEntryDistance = (_halfExtentsY - py) / vy;
				if (rayEntryDistance > 0)
				{
					ix = px + rayEntryDistance * vx;
					iz = pz + rayEntryDistance * vz;
					if (ix > -_halfExtentsX && ix < _halfExtentsX && iz > -_halfExtentsZ && iz < _halfExtentsZ)
					{
						targetNormal.x = 0;
						targetNormal.y = 1;
						targetNormal.z = 0;
						intersects = true;
					}
				}
			}
			if (!intersects && vy > 0)
			{
				rayEntryDistance = (-_halfExtentsY - py) / vy;
				if (rayEntryDistance > 0)
				{
					ix = px + rayEntryDistance * vx;
					iz = pz + rayEntryDistance * vz;
					if (ix > -_halfExtentsX && ix < _halfExtentsX && iz > -_halfExtentsZ && iz < _halfExtentsZ)
					{
						targetNormal.x = 0;
						targetNormal.y = -1;
						targetNormal.z = 0;
						intersects = true;
					}
				}
			}
			if (!intersects && vz < 0)
			{
				rayEntryDistance = (_halfExtentsZ - pz) / vz;
				if (rayEntryDistance > 0)
				{
					ix = px + rayEntryDistance * vx;
					iy = py + rayEntryDistance * vy;
					if (iy > -_halfExtentsY && iy < _halfExtentsY && ix > -_halfExtentsX && ix < _halfExtentsX)
					{
						targetNormal.x = 0;
						targetNormal.y = 0;
						targetNormal.z = 1;
						intersects = true;
					}
				}
			}
			if (!intersects && vz > 0)
			{
				rayEntryDistance = (-_halfExtentsZ - pz) / vz;
				if (rayEntryDistance > 0)
				{
					ix = px + rayEntryDistance * vx;
					iy = py + rayEntryDistance * vy;
					if (iy > -_halfExtentsY && iy < _halfExtentsY && ix > -_halfExtentsX && ix < _halfExtentsX)
					{
						targetNormal.x = 0;
						targetNormal.y = 0;
						targetNormal.z = -1;
						intersects = true;
					}
				}
			}

			return intersects ? rayEntryDistance : -1;
		}

		override public function containsPoint(position:Vector3D):Boolean
		{
			var px:Number = position.x - _centerX, py:Number = position.y - _centerY, pz:Number = position.z - _centerZ;
			return px <= _halfExtentsX && px >= -_halfExtentsX && py <= _halfExtentsY && py >= -_halfExtentsY && pz <= _halfExtentsZ && pz >= -_halfExtentsZ;
		}
	}
}
