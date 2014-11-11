package me.feng3d.entities.segment
{

	import flash.display3D.Context3DVertexBufferFormat;

	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.buffer.context3d.VABuffer;
	import me.feng3d.core.proxy.Context3DCache;

	/**
	 * 线段渲染数据缓冲
	 * @author warden_feng 2014-5-9
	 */
	public class SegmentSubGeometry extends SubGeometry
	{
		protected var _seg0Buffer:VABuffer;
		protected var _seg1Buffer:VABuffer;
		protected var _seg2Buffer:VABuffer;
		protected var _seg3Buffer:VABuffer;

		/** 更新回调函数 */
		protected var _updateFunc:Function;

		public function SegmentSubGeometry(updateFunc:Function)
		{
			super();
			_updateFunc = updateFunc;
		}

		override protected function initBuffers():void
		{
			// TODO Auto Generated method stub
			super.initBuffers();

			_seg0Buffer = new VABuffer(SegmentContext3DBufferTypeID.SEGMENTSTART_VA_3, updateSegment0);
			_seg1Buffer = new VABuffer(SegmentContext3DBufferTypeID.SEGMENTEND_VA_3, updateSegment1);
			_seg2Buffer = new VABuffer(SegmentContext3DBufferTypeID.SEGMENTTHICKNESS_VA_1, updateSegment2);
			_seg3Buffer = new VABuffer(SegmentContext3DBufferTypeID.SEGMENTCOLOR_VA_4, updateSegment3);

			_seg0Buffer.dataBuffer = _seg1Buffer.dataBuffer = _seg2Buffer.dataBuffer = _seg3Buffer.dataBuffer = _vertexBuffer.dataBuffer;
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);

			context3dCache.addDataBuffer(_seg0Buffer);
			context3dCache.addDataBuffer(_seg1Buffer);
			context3dCache.addDataBuffer(_seg2Buffer);
			context3dCache.addDataBuffer(_seg3Buffer);
		}

		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);

			context3dCache.removeDataBuffer(_seg0Buffer);
			context3dCache.removeDataBuffer(_seg1Buffer);
			context3dCache.removeDataBuffer(_seg2Buffer);
			context3dCache.removeDataBuffer(_seg3Buffer);
		}

		override protected function updateIndexBuffer():void
		{
			doUpdateFunc();
			super.updateIndexBuffer();
		}

		protected function updateSegment0():void
		{
			doUpdateFunc();
			_seg0Buffer.update(vertexData, numVertices, vertexStride, 0, Context3DVertexBufferFormat.FLOAT_3);
		}

		protected function updateSegment1():void
		{
			doUpdateFunc();
			_seg1Buffer.update(vertexData, numVertices, vertexStride, 3, Context3DVertexBufferFormat.FLOAT_3);
		}

		protected function updateSegment2():void
		{
			doUpdateFunc();
			_seg2Buffer.update(vertexData, numVertices, vertexStride, 6, Context3DVertexBufferFormat.FLOAT_1);
		}

		protected function updateSegment3():void
		{
			doUpdateFunc();
			_seg3Buffer.update(vertexData, numVertices, vertexStride, 7, Context3DVertexBufferFormat.FLOAT_4);
		}

		override public function get vertexStride():uint
		{
			return 11;
		}

		/** 线段数据是否脏了 */
		private var _segmentDataDirty:Boolean = true;

		protected function doUpdateFunc():void
		{
			if (_updateFunc && _segmentDataDirty)
			{
				_updateFunc();
				_segmentDataDirty = false;
			}
		}

		public function invalid():void
		{
			_segmentDataDirty = true;

			_indexBuffer.invalid();
			_seg0Buffer.invalid();
			_seg1Buffer.invalid();
			_seg2Buffer.invalid();
			_seg3Buffer.invalid();
		}
	}
}
