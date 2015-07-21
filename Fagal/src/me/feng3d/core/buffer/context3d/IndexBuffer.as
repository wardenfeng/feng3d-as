package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.utils.Dictionary;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.context3d.item.IndexBufferItem;

	use namespace arcanefagal;

	/**
	 * 索引缓存
	 * @author warden_feng 2014-8-21
	 */
	public class IndexBuffer extends Context3DBuffer
	{
		private var _bufferItemDic:Dictionary = new Dictionary();

		/** data 中索引的数量。 */
		arcanefagal var count:int;

		/** 此 IndexBuffer3D 对象中的索引，要加载的第一个索引。不等于零的 startOffset 值可用于加载索引数据的子区域。 */
		arcanefagal var _startOffset:int;

		/** 顶点索引的矢量。仅使用每个索引值的低 16 位。矢量的长度必须大于或等于 count。 */
		arcanefagal var data:Vector.<uint>;

		/** 要在缓存区中存储的顶点数量。单个缓存区中的最大索引数为 524287。 */
		arcanefagal var numIndices:int;

		arcanefagal var firstIndex:int = 0;
		arcanefagal var numTriangles:int = -1;

		/** 是否无效 */
		private var dicInvalid:Boolean = true;

		/** 缓存无效 */
		private var bufferInvalid:Boolean = true;

		/**
		 * 创建一个索引缓存
		 * @param dataTypeId 		数据缓存编号
		 * @param updateFunc 		更新回调函数
		 */
		public function IndexBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		/**
		 * @inheritDoc
		 */
		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			var indexBufferItem:IndexBufferItem;
			//处理 缓存无效标记
			if (bufferInvalid)
			{
				for each (indexBufferItem in _bufferItemDic)
				{
					indexBufferItem
				}
				_bufferItemDic = new Dictionary();
				bufferInvalid = false;
				dicInvalid = false;
			}
			//处理 数据无效标记
			if (dicInvalid)
			{
				for each (indexBufferItem in _bufferItemDic)
				{
					indexBufferItem.invalid = true;
				}
				dicInvalid = false;
			}

			indexBufferItem = _bufferItemDic[context3D];
			if (indexBufferItem == null)
			{
				indexBufferItem = _bufferItemDic[context3D] = new IndexBufferItem(context3D, numIndices);
			}

			if (indexBufferItem.invalid)
			{
				indexBufferItem.uploadFromVector(data, _startOffset, count);
			}

			indexBufferItem.drawTriangles(firstIndex, numTriangles);
		}

		/**
		 * 销毁数据
		 */
		public function dispose():void
		{
			data = null;
			_bufferItemDic = null;
		}

		/**
		 * 更新数据
		 * @param data 顶点索引的矢量。仅使用每个索引值的低 16 位。矢量的长度必须大于或等于 count。
		 * @param numIndices 要在缓存区中存储的顶点数量。单个缓存区中的最大索引数为 524287。
		 * @param count data 中索引的数量。
		 */
		public function update(data:Vector.<uint>, numIndices:uint, count:uint, firstIndex:int = 0, numTriangles:int = -1):void
		{
			if (!data)
				throw new Error("顶点索引不接收空数组");

			this.dicInvalid = true;
			if (!this.data || this.data.length != data.length)
			{
				this.bufferInvalid = true;
			}

			this.data = data;
			this.numIndices = numIndices;
			this.count = count;
			this.firstIndex = firstIndex;
			this.numTriangles = numTriangles;
		}
	}
}
