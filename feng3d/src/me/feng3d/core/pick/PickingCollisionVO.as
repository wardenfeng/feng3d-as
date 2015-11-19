package me.feng3d.core.pick
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.entities.Entity;
	import me.feng3d.mathlib.Matrix3DUtils;
	import me.feng3d.mathlib.Ray3D;

	/**
	 * 采集的碰撞数据
	 * @author feng 2014-4-29
	 */
	public class PickingCollisionVO
	{
		/**
		 * 第一个穿过的物体
		 */
		public var firstEntity:Entity;

		/**
		 * 碰撞的uv坐标
		 */
		public var uv:Point;

		/**
		 * 实体上碰撞本地坐标
		 */
		public var localPosition:Vector3D;

		/**
		 * 射线顶点到实体的距离
		 */
		public var rayEntryDistance:Number;

		/**
		 * 本地坐标系射线
		 */
		public var localRay:Ray3D = new Ray3D();

		/**
		 * 本地坐标碰撞法线
		 */
		public var localNormal:Vector3D;

		/**
		 * 场景中碰撞射线
		 */
		public var ray3D:Ray3D = new Ray3D();

		/**
		 * 射线坐标是否在边界内
		 */
		public var rayOriginIsInsideBounds:Boolean;

		/**
		 * 碰撞三角形索引
		 */
		public var index:uint;

		/**
		 * 碰撞关联的渲染对象
		 */
		public var renderable:IRenderable;

		/**
		 * 创建射线拾取碰撞数据
		 * @param entity
		 */
		public function PickingCollisionVO(entity:Entity)
		{
			this.firstEntity = entity;
		}

		/**
		 * 实体上碰撞世界坐标
		 */
		public function get scenePosition():Vector3D
		{
			return Matrix3DUtils.transformVector(firstEntity.sceneTransform, localPosition);
		}
	}
}
