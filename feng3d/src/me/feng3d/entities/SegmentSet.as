package me.feng3d.entities
{

	import me.feng3d.arcane;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.materials.SegmentMaterial;
	import me.feng3d.primitives.data.Segment;

	use namespace arcane;

	/**
	 * 线段集合
	 * @author feng 2014-4-9
	 */
	public class SegmentSet extends Mesh implements IRenderable
	{
		private var _numIndices:uint;

		protected var segmentGeometry:SegmentGeometry;

		/**
		 * 创建一个线段集合
		 */
		public function SegmentSet()
		{
			super();
//			_segmentSubGeometry = new SegmentSubGeometry(updateSegmentData);
			this.geometry = segmentGeometry = new SegmentGeometry();
			material = new SegmentMaterial();
//			geometry.addSubGeometry(_segmentSubGeometry);
		}

		/**
		 * 添加线段
		 * @param segment		线段数据
		 */
		public function addSegment(segment:Segment, needUpdateGeometry:Boolean = true):void
		{
			segmentGeometry.addSegment(segment, needUpdateGeometry);
		}

		/**
		 * @inheritDoc
		 */
		public function get context3dCache():Context3DCache
		{
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function get numTriangles():uint
		{
			return _numIndices / 3;
		}

		/**
		 * 线段不会投射阴影，始终为false
		 */
		override public function get castsShadows():Boolean
		{
			return false;
		}
	}
}
