package me.feng3d.core.base
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import me.feng3d.core.buffer.context3d.Context3DBuffer;

	/**
	 * Context3D缓存拥有者接口
	 * @author feng 2014-11-24
	 */
	public interface IContext3DBufferOwner extends IEventDispatcher
	{
		/**
		 * 映射Context3D缓存
		 * @param dataTypeId	数据缓存编号
		 * @param updateFunc	更新回调函数
		 * @return				创建的数据缓存
		 */
		function mapContext3DBuffer(dataTypeId:String, updateFunc:Function):Context3DBuffer;

		/**
		 * 添加子项缓存拥有者
		 * @param childBufferOwner
		 */
		function addChildBufferOwner(childBufferOwner:IContext3DBufferOwner):void;

		/**
		 * 移除子项缓存拥有者
		 * @param childBufferOwner
		 */
		function removeChildBufferOwner(childBufferOwner:IContext3DBufferOwner):void;

		/**
		 * Context3D缓存字典
		 */
		function get bufferDic():Dictionary;

		/**
		 * Context3D缓存列表
		 */
		function get bufferList():Vector.<Context3DBuffer>;

		/**
		 * 获取所有的Context3D缓存列表（包含所有子项中的缓存）
		 */
		function getAllBufferList():Vector.<Context3DBuffer>;
	}
}
