package me.feng3d.core.data
{

	/**
	 * 可渲染列表元素池
	 * @author feng 2015-3-6
	 */
	public class RenderableListItemPool
	{
		private var _pool:Vector.<RenderableListItem>;
		private var _index:int;
		private var _poolSize:int;

		/**
		 * 创建可渲染列表元素池
		 */
		public function RenderableListItemPool()
		{
			_pool = new Vector.<RenderableListItem>();
		}

		/**
		 * 获取 可渲染列表元
		 */
		public function getItem():RenderableListItem
		{
			if (_index == _poolSize)
			{
				var item:RenderableListItem = new RenderableListItem();
				_pool[_index++] = item;
				++_poolSize;
				return item;
			}
			else
				return _pool[_index++];
		}

		/**
		 * 释放所有
		 */
		public function freeAll():void
		{
			_index = 0;
		}
	}
}
