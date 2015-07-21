package me.feng3d.core.buffer.context3d.item
{
	import flash.display3D.Context3D;
	import flash.utils.Dictionary;


	/**
	 * 顶点VA数据缓冲
	 * @author warden_feng 2014-8-28
	 */
	public class VADataBuffer
	{
		/** 要在缓存区中存储的顶点数量。单个缓存区中的最大顶点数为 65535。 */
		public var numVertices:int;
		/** 与每个顶点关联的 32 位（4 字节）数据值的数量。每个顶点的 32 位数据元素数量最多为 64 个（或 256 个字节）。请注意，顶点着色器程序在任何给定时间只能访问 8 个属性寄存器。使用 SetVertextBufferAt() 在顶点缓存区内选择属性。  */
		public var data32PerVertex:int;
		/** 顶点数据 */
		public var data:Vector.<Number>;

		/** 缓存字典 可在多个寄存器共享数据缓存时使用同一个 */
		private var bufferItemDic:Dictionary = new Dictionary();
		/** 是否无效 */
		private var invalid:Boolean = true;
		/** 缓存是否无效 */
		private var bufferInvalid:Boolean = true;

		/**
		 * 创建顶点VA数据缓冲
		 */
		public function VADataBuffer()
		{
		}

		/**
		 * 获取顶点缓冲项
		 * @param context3D		3d环境
		 * @return 				顶点缓冲项
		 */
		public function getBufferItem(context3D:Context3D):VertexBufferItem
		{
			var vertexBufferItem:VertexBufferItem;
			//处理 缓存无效标记
			if (bufferInvalid)
			{
				for each (vertexBufferItem in bufferItemDic)
				{
					vertexBufferItem
				}
				bufferItemDic = new Dictionary();
				bufferInvalid = false;
				invalid = false;
			}
			//处理 数据无效标记
			if (invalid)
			{
				for each (vertexBufferItem in bufferItemDic)
				{
					vertexBufferItem.invalid = true;
				}
				invalid = false;
			}

			vertexBufferItem = bufferItemDic[context3D];
			if (vertexBufferItem == null)
			{
				vertexBufferItem = bufferItemDic[context3D] = new VertexBufferItem(context3D, numVertices, data32PerVertex);
			}

			if (vertexBufferItem.invalid)
			{
				vertexBufferItem.uploadFromVector(data, 0, numVertices);
			}

			return vertexBufferItem;
		}

		/**
		 * 更新数据
		 * @param data 				顶点数据
		 * @param numVertices 		要在缓存区中存储的顶点数量。单个缓存区中的最大顶点数为 65535。
		 * @param data32PerVertex 	与每个顶点关联的 32 位（4 字节）数据值的数量。每个顶点的 32 位数据元素数量最多为 64 个（或 256 个字节）。请注意，顶点着色器程序在任何给定时间只能访问 8 个属性寄存器。使用 SetVertextBufferAt() 在顶点缓存区内选择属性。
		 */
		public function update(data:Vector.<Number>, numVertices:int, data32PerVertex:int):void
		{
			if (!data || numVertices == 0)
				throw new Error("顶点缓存不接收空数组");
			this.invalid = true;
			if (!this.data || this.data.length != data.length)
			{
				this.bufferInvalid = true;
			}

			this.data = data;
			this.numVertices = numVertices;
			this.data32PerVertex = data32PerVertex;
		}
	}
}
