package me.feng3d.core.base
{
	import flash.utils.Dictionary;

	import me.feng.core.NamedAssetBase;
	import me.feng3d.core.buffer.Context3DBufferTypeManager;
	import me.feng3d.core.buffer.context3d.Context3DBuffer;
	import me.feng.debug.assert;
	import me.feng3d.events.Context3DBufferOwnerEvent;
	import me.feng3d.fagalRE.FagalIdCenter;

	/**
	 * 添加3D环境缓冲事件
	 */
	[Event(name = "addContext3DBuffer", type = "me.feng3d.events.Context3DBufferOwnerEvent")]

	/**
	 * 移除3D环境缓冲事件
	 */
	[Event(name = "removeContext3DBuffer", type = "me.feng3d.events.Context3DBufferOwnerEvent")]

	/**
	 * 添加子项3D环境缓冲拥有者事件
	 */
	[Event(name = "addChildContext3DBufferOwner", type = "me.feng3d.events.Context3DBufferOwnerEvent")]

	/**
	 * 移除子项3D环境缓冲拥有者事件
	 */
	[Event(name = "removeChildContext3DBufferOwner", type = "me.feng3d.events.Context3DBufferOwnerEvent")]

	/**
	 * Context3D缓存拥有者
	 * @author feng 2014-11-26
	 */
	public class Context3DBufferOwner extends NamedAssetBase implements IContext3DBufferOwner
	{
		private var _bufferDic:Dictionary;
		private var _bufferList:Vector.<Context3DBuffer>;
		/**
		 * 缓冲拥有者子项列表
		 */
		private var childrenBufferOwner:Vector.<IContext3DBufferOwner>;

		private var allBufferList:Vector.<Context3DBuffer>;
		/**
		 * 所有缓冲列表是否有效
		 */
		private var bufferInvalid:Boolean = true;

		/**
		 * 创建Context3D缓存拥有者
		 */
		public function Context3DBufferOwner()
		{
			childrenBufferOwner = new Vector.<IContext3DBufferOwner>()
			initBuffers();
		}

		/**
		 * Fagal编号中心
		 */
		public function get _():FagalIdCenter
		{
			return FagalIdCenter.instance;
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferDic():Dictionary
		{
			return _bufferDic ||= new Dictionary();
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferList():Vector.<Context3DBuffer>
		{
			return _bufferList ||= new Vector.<Context3DBuffer>();
		}

		/**
		 * 初始化Context3d缓存
		 */
		protected function initBuffers():void
		{

		}

		/**
		 * 添加子项缓存拥有者
		 * @param childBufferOwner
		 */
		public function addChildBufferOwner(childBufferOwner:IContext3DBufferOwner):void
		{
			var index:int = childrenBufferOwner.indexOf(childBufferOwner);
			assert(index == -1, "不能重复添加子项缓存拥有者");
			childrenBufferOwner.push(childBufferOwner);
			//添加事件
			childBufferOwner.addEventListener(Context3DBufferOwnerEvent.ADD_CONTEXT3DBUFFER, bubbleDispatchEvent);
			childBufferOwner.addEventListener(Context3DBufferOwnerEvent.REMOVE_CONTEXT3DBUFFER, bubbleDispatchEvent);
			childBufferOwner.addEventListener(Context3DBufferOwnerEvent.ADDCHILD_CONTEXT3DBUFFEROWNER, bubbleDispatchEvent);
			childBufferOwner.addEventListener(Context3DBufferOwnerEvent.REMOVECHILD_CONTEXT3DBUFFEROWNER, bubbleDispatchEvent);
			//派发添加子项缓冲拥有者事件
			dispatchEvent(new Context3DBufferOwnerEvent(Context3DBufferOwnerEvent.ADDCHILD_CONTEXT3DBUFFEROWNER, childBufferOwner));
		}

		/**
		 * 移除子项缓存拥有者
		 * @param childBufferOwner
		 */
		public function removeChildBufferOwner(childBufferOwner:IContext3DBufferOwner):void
		{
			var index:int = childrenBufferOwner.indexOf(childBufferOwner);
			assert(index != -1, "无法移除不存在的子项缓存拥有者");
			childrenBufferOwner.splice(index, 1);
			//移除事件
			childBufferOwner.removeEventListener(Context3DBufferOwnerEvent.ADD_CONTEXT3DBUFFER, bubbleDispatchEvent);
			childBufferOwner.removeEventListener(Context3DBufferOwnerEvent.REMOVE_CONTEXT3DBUFFER, bubbleDispatchEvent);
			childBufferOwner.removeEventListener(Context3DBufferOwnerEvent.ADDCHILD_CONTEXT3DBUFFEROWNER, bubbleDispatchEvent);
			childBufferOwner.removeEventListener(Context3DBufferOwnerEvent.REMOVECHILD_CONTEXT3DBUFFEROWNER, bubbleDispatchEvent);
			//派发添加子项缓冲拥有者事件
			dispatchEvent(new Context3DBufferOwnerEvent(Context3DBufferOwnerEvent.REMOVECHILD_CONTEXT3DBUFFEROWNER, childBufferOwner));
		}

		/**
		 * 向上冒泡
		 */
		private function bubbleDispatchEvent(event:Context3DBufferOwnerEvent):void
		{
			bufferInvalid = true;
			dispatchEvent(event);
		}

		/**
		 * 标记Context3d缓存脏了
		 * @param dataTypeId
		 */
		protected function markBufferDirty(dataTypeId:String):void
		{
			var context3DBuffer:Context3DBuffer = bufferDic[dataTypeId];
			context3DBuffer.invalid();
		}

		/**
		 * @inheritDoc
		 */
		public function mapContext3DBuffer(dataTypeId:String, updateFunc:Function):Context3DBuffer
		{
			var bufferCls:Class = Context3DBufferTypeManager.getBufferClass(dataTypeId);

			var context3DBuffer:Context3DBuffer = new bufferCls(dataTypeId, updateFunc);
			bufferDic[dataTypeId] = context3DBuffer;
			bufferList.push(context3DBuffer);

			dispatchEvent(new Context3DBufferOwnerEvent(Context3DBufferOwnerEvent.ADD_CONTEXT3DBUFFER, context3DBuffer));
			return context3DBuffer;
		}

		/**
		 * @inheritDoc
		 */
		public function getAllBufferList():Vector.<Context3DBuffer>
		{
			if (bufferInvalid)
			{
				//收集本拥有者缓冲列表
				allBufferList = bufferList.concat();

				var childAllBufferList:Vector.<Context3DBuffer>;
				//遍历子项拥有者收集缓冲列表
				for (var i:int = 0; i < childrenBufferOwner.length; i++)
				{
					childAllBufferList = childrenBufferOwner[i].getAllBufferList();
					allBufferList = allBufferList.concat(childAllBufferList);
				}
				bufferInvalid = false;
			}

			return allBufferList;
		}
	}
}
