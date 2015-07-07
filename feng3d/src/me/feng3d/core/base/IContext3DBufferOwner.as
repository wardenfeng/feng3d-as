package me.feng3d.core.base
{
	import flash.utils.Dictionary;
	
	import me.feng3d.core.buffer.Context3DCache;

	/**
	 * Context3D缓存拥有者接口
	 * @author warden_feng 2014-11-24
	 */
	public interface IContext3DBufferOwner
	{
		/**
		 * 映射Context3D缓存
		 * @param dataTypeId	数据缓存编号
		 * @param bufferCls		缓存类定义
		 * @param updateFunc	更新回调函数
		 * @return				创建的数据缓存
		 */
		function mapContext3DBuffer(dataTypeId:String, bufferCls:Class, updateFunc:Function):void;

		/**
		 * 收集渲染缓存
		 * @param context3dCache	渲染缓存
		 */
		function activateContext3DBuffer(context3dCache:Context3DCache):void;

		/**
		 * 释放渲染缓存
		 * @param context3dCache	渲染缓存
		 */
		function deActivateContext3DBuffer(context3dCache:Context3DCache):void;
		
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
		 * Context3D缓存编号列表
		 */
		function get bufferDic():Dictionary;
	}
}
