package me.feng3d.core.buffer
{
	import flash.utils.Dictionary;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.IContext3DBufferOwner;
	import me.feng3d.core.buffer.context3d.Context3DBuffer;
	import me.feng3d.events.Context3DBufferOwnerEvent;

	use namespace arcanefagal;

	/**
	 * 3D环境缓冲收集器
	 * @author warden_feng 2015-7-18
	 */
	public class Context3DBufferCollector
	{
		/** 根3D环境缓冲拥有者 */
		private var _rootBufferOwner:IContext3DBufferOwner;

		/** 所有数据缓存 */
		private var bufferDic:Dictionary = new Dictionary();

		/**
		 * 创建3D环境缓冲收集器
		 * @bufferOwner		缓冲拥有者
		 */
		public function Context3DBufferCollector()
		{
		}

		/**
		 * 根3D环境缓冲拥有者
		 */
		private function get rootBufferOwner():IContext3DBufferOwner
		{
			if (_rootBufferOwner == null)
			{
				_rootBufferOwner = new Context3DBufferOwner();
				//添加事件
				_rootBufferOwner.addEventListener(Context3DBufferOwnerEvent.ADD_CONTEXT3DBUFFER, onAddContext3DBuffer);
				_rootBufferOwner.addEventListener(Context3DBufferOwnerEvent.REMOVE_CONTEXT3DBUFFER, onRemoveContext3DBuffer);
				_rootBufferOwner.addEventListener(Context3DBufferOwnerEvent.ADDCHILD_CONTEXT3DBUFFEROWNER, onAddChildContext3DBufferOwner);
				_rootBufferOwner.addEventListener(Context3DBufferOwnerEvent.REMOVECHILD_CONTEXT3DBUFFEROWNER, onRemoveChildContext3DBufferOwner);
			}
			return _rootBufferOwner;
		}

		/**
		 * 添加子项缓存拥有者
		 * @param childBufferOwner
		 */
		public function addChildBufferOwner(childBufferOwner:IContext3DBufferOwner):void
		{
			rootBufferOwner.addChildBufferOwner(childBufferOwner);
		}

		/**
		 * 移除子项缓存拥有者
		 * @param childBufferOwner
		 */
		public function removeChildBufferOwner(childBufferOwner:IContext3DBufferOwner):void
		{
			rootBufferOwner.removeChildBufferOwner(childBufferOwner);
		}

		/**
		 * 添加数据缓存
		 * @param context3DDataBuffer 数据缓存
		 */
		arcanefagal function addDataBuffer(context3DDataBuffer:Context3DBuffer):void
		{
			var dataTypeId:String = context3DDataBuffer.dataTypeId;
			if (bufferDic[dataTypeId])
				trace("重复提交数据" + context3DDataBuffer);
			bufferDic[dataTypeId] = context3DDataBuffer;
		}

		/**
		 * 移除数据缓存
		 * @param dataTypeId 数据缓存类型编号
		 */
		arcanefagal function removeDataBuffer(context3DDataBuffer:Context3DBuffer):void
		{
			var dataTypeId:String = context3DDataBuffer.dataTypeId;
			if (bufferDic[dataTypeId] != context3DDataBuffer)
				throw new Error("移除数据缓存错误");
			delete bufferDic[dataTypeId];
		}

		/**
		 * 处理添加缓冲拥有者事件
		 */
		private function onAddChildContext3DBufferOwner(event:Context3DBufferOwnerEvent):void
		{
			addContext3DBufferOwer(event.data);
		}

		/**
		 * 处理移除缓冲拥有者事件
		 */
		private function onRemoveChildContext3DBufferOwner(event:Context3DBufferOwnerEvent):void
		{
			removeContext3DBufferOwer(event.data);
		}

		/**
		 * 处理添加缓冲事件
		 */
		private function onAddContext3DBuffer(event:Context3DBufferOwnerEvent):void
		{
			addDataBuffer(event.data);
		}


		/**
		 * 处理移除缓冲事件
		 */
		private function onRemoveContext3DBuffer(event:Context3DBufferOwnerEvent):void
		{
			removeDataBuffer(event.data);
		}

		/**
		 * 添加缓冲拥有者
		 * @param bufferOwer		缓冲拥有者
		 */
		private function addContext3DBufferOwer(bufferOwer:IContext3DBufferOwner):void
		{
			var allBufferList:Vector.<Context3DBuffer> = bufferOwer.getAllBufferList();
			for (var i:int = 0; i < allBufferList.length; i++)
			{
				addDataBuffer(allBufferList[i]);
			}
		}

		/**
		 * 移除缓冲拥有者
		 * @param bufferOwer		缓冲拥有者
		 */
		private function removeContext3DBufferOwer(bufferOwer:IContext3DBufferOwner):void
		{
			var allBufferList:Vector.<Context3DBuffer> = bufferOwer.getAllBufferList();
			for (var i:int = 0; i < allBufferList.length; i++)
			{
				removeDataBuffer(allBufferList[i]);
			}
		}

		/**
		 * 销毁
		 */
		public function dispose():void
		{
			//移除事件
			if (_rootBufferOwner != null)
			{
				_rootBufferOwner.removeEventListener(Context3DBufferOwnerEvent.ADD_CONTEXT3DBUFFER, onAddContext3DBuffer);
				_rootBufferOwner.removeEventListener(Context3DBufferOwnerEvent.REMOVE_CONTEXT3DBUFFER, onRemoveContext3DBuffer);
				_rootBufferOwner.removeEventListener(Context3DBufferOwnerEvent.ADDCHILD_CONTEXT3DBUFFEROWNER, onAddChildContext3DBufferOwner);
				_rootBufferOwner.removeEventListener(Context3DBufferOwnerEvent.REMOVECHILD_CONTEXT3DBUFFEROWNER, onRemoveChildContext3DBufferOwner);
			}
			_rootBufferOwner = null;
		}
	}
}
