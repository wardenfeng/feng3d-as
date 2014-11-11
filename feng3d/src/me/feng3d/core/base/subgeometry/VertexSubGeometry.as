package me.feng3d.core.base.subgeometry
{
	import flash.display3D.Context3DVertexBufferFormat;
	
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.VABuffer;
	import me.feng3d.core.proxy.Context3DCache;

	/**
	 * 顶点动画 子网格
	 * @author warden_feng 2014-8-28
	 */
	public class VertexSubGeometry extends SubGeometry
	{
		protected var _vertexData1:Vector.<Number>;

		/** 顶点坐标0 数据缓冲 */
		protected var _vertexBuffer0:VABuffer;

		/** 顶点坐标1 数据缓冲 */
		protected var _vertexBuffer1:VABuffer;

		public function VertexSubGeometry()
		{
			super();
		}

		public function get vertexData0():Vector.<Number>
		{
			return tvertexData;
		}

		public function get vertexData1():Vector.<Number>
		{
			return _vertexData1;
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			_vertexBuffer0 = new VABuffer(Context3DBufferTypeID.POSITION0_VA_3, updateVertexBuffer0);
			_vertexBuffer0.dataBuffer = _vertexBuffer.dataBuffer;
			_vertexBuffer1 = new VABuffer(Context3DBufferTypeID.POSITION1_VA_3, updateVertexBuffer1);
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);

			context3dCache.addDataBuffer(_vertexBuffer0);
			context3dCache.addDataBuffer(_vertexBuffer1);
		}
		
		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);
			
			context3dCache.removeDataBuffer(_vertexBuffer0);
			context3dCache.removeDataBuffer(_vertexBuffer1);
		}
		
		public function updateVertexData0(vertices:Vector.<Number>):void
		{
			super.updateVertexData(vertices);
			
			_vertexBuffer0.invalid();
		}

		public function updateVertexData1(vertices:Vector.<Number>):void
		{
			_vertexData1 = vertices;

			_vertexBuffer1.invalid();
		}

		/**
		 * 更新第零个顶点缓冲数据
		 */
		protected function updateVertexBuffer0():void
		{
			_vertexBuffer0.update(vertexData0, numVertices, vertexStride, 0, Context3DVertexBufferFormat.FLOAT_3);
		}

		/**
		 * 更新第一个顶点缓冲数据
		 */
		protected function updateVertexBuffer1():void
		{
			_vertexBuffer1.update(vertexData1, numVertices, vertexStride, 0, Context3DVertexBufferFormat.FLOAT_3);
		}

		override protected function disposeAllVertexBuffers():void
		{
			super.disposeAllVertexBuffers();

			_vertexBuffer0.invalid();
			_vertexBuffer1.invalid();
		}
	}
}
