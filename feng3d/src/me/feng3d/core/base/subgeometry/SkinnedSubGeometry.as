package me.feng3d.core.base.subgeometry
{
	import flash.display3D.Context3DVertexBufferFormat;
	
	import me.feng3d.arcane;
	import me.feng3d.core.base.ISubGeometry;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.VABuffer;
	import me.feng3d.core.proxy.Context3DCache;

	use namespace arcane;

	/**
	 * 蒙皮子网格
	 * 提供了关节 索引数据与权重数据
	 */
	public class SkinnedSubGeometry extends SubGeometry
	{
		private var _bufferFormat:String;
		private var _jointWeightsData:Vector.<Number>;
		private var _jointIndexData:Vector.<Number>;
		private var _animatedData:Vector.<Number>; // used for cpu fallback

		private var _jointsPerVertex:int;

		/** 蒙皮好了的动画顶点 数据缓冲 */
		protected var _animatedDataBuffer:VABuffer;

		/** 关节权重 数据缓冲 */
		protected var _jointWeightsBuffer:VABuffer;

		/** 关节索引 数据缓冲 */
		protected var _jointIndexBuffer:VABuffer;

		/**
		 * 创建蒙皮子网格
		 */
		public function SkinnedSubGeometry(jointsPerVertex:int)
		{
			super();
			_jointsPerVertex = jointsPerVertex;
			_bufferFormat = "float" + _jointsPerVertex;
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			_animatedDataBuffer = new VABuffer(Context3DBufferTypeID.ANIMATED_VA_3, updateAnimatedDataBuffer);
			_jointWeightsBuffer = new VABuffer(Context3DBufferTypeID.JOINTWEIGHTS_VA_X, updateJointWeightsBuffer);
			_jointIndexBuffer = new VABuffer(Context3DBufferTypeID.JOINTINDEX_VA_X, updateJointIndexBuffer);
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);

			context3dCache.addDataBuffer(_animatedDataBuffer);
			context3dCache.addDataBuffer(_jointWeightsBuffer);
			context3dCache.addDataBuffer(_jointIndexBuffer);
		}
		
		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);
			
			context3dCache.removeDataBuffer(_animatedDataBuffer);
			context3dCache.removeDataBuffer(_jointWeightsBuffer);
			context3dCache.removeDataBuffer(_jointIndexBuffer);
		}
		
		/**
		 * 动画顶点数据
		 */
		public function get animatedData():Vector.<Number>
		{
			return _animatedData || tvertexData.concat();
		}

		/**
		 * 更新动画顶点数据
		 */
		public function updateAnimatedData(value:Vector.<Number>):void
		{
			_animatedData = value;

			_animatedDataBuffer.invalid();
		}

		/**
		 * 克隆
		 */
		override public function clone():ISubGeometry
		{
			var clone:SkinnedSubGeometry = new SkinnedSubGeometry(_jointsPerVertex);

			clone.updateVertexData(tvertexData.concat());
			clone.updateUVData(_uvs.concat());
			clone.updateIndexData(_indices.concat());

			clone.updateJointIndexData(_jointIndexData.concat());
			clone.updateJointWeightsData(_jointWeightsData.concat());

			return clone;
		}

		/**
		 * 关节权重数据
		 */
		arcane function get jointWeightsData():Vector.<Number>
		{
			return _jointWeightsData;
		}

		/**
		 * 更新关节权重数据
		 */
		arcane function updateJointWeightsData(value:Vector.<Number>):void
		{
			_jointWeightsData = value;

			_jointWeightsBuffer.invalid();
		}

		/**
		 * 关节索引数据
		 */
		arcane function get jointIndexData():Vector.<Number>
		{
			return _jointIndexData;
		}

		/**
		 * 更新关节索引数据
		 */
		arcane function updateJointIndexData(value:Vector.<Number>):void
		{
			_jointIndexData = value;
		}

		public function get jointsPerVertex():int
		{
			return _jointsPerVertex;
		}

		public function get bufferFormat():String
		{
			return _bufferFormat;
		}

		protected function updateAnimatedDataBuffer():void
		{
			_animatedDataBuffer.update(animatedData, numVertices, vertexStride, vertexOffset, Context3DVertexBufferFormat.FLOAT_3);
		}

		protected function updateJointWeightsBuffer():void
		{
			_jointWeightsBuffer.update(jointWeightsData, numVertices, jointsPerVertex, 0, bufferFormat);
		}

		protected function updateJointIndexBuffer():void
		{
			_jointIndexBuffer.update(jointIndexData, numVertices, jointsPerVertex, 0, bufferFormat);
		}
	}
}
