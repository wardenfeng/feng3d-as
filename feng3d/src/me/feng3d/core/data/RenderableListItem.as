package me.feng3d.core.data
{
	import flash.geom.Matrix3D;

	import me.feng3d.core.base.renderable.IRenderable;

	/**
	 * 可渲染元素链表（元素）
	 * @author warden_feng 2015-3-6
	 */
	public class RenderableListItem
	{
		/**
		 * 指向下个可渲染列表元素
		 */
		public var next:RenderableListItem;
		/**
		 * 当前可渲染对象
		 */
		public var renderable:IRenderable;

		/**
		 * 材质编号
		 */
		public var materialId:int;
		/**
		 * 渲染顺序编号
		 */
		public var renderOrderId:int;
		/**
		 * Z索引
		 */
		public var zIndex:Number;
		/**
		 * 渲染场景矩阵
		 */
		public var renderSceneTransform:Matrix3D;

		/**
		 *
		 */
		public var cascaded:Boolean;

		/**
		 * 创建一个可渲染列表
		 */
		public function RenderableListItem()
		{
		}
	}
}
