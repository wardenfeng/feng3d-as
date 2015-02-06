package me.feng3d.core.base
{
	
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.entities.Entity;

	/**
	 * IRenderable为对象提供一个表示可以被渲染的接口
	 * @author warden_feng 2014-4-9
	 */
	public interface IRenderable extends IMaterialOwner
	{
		/**
		 * 渲染缓存
		 */
		function get context3dCache():Context3DCache;
		
		/**
		 * 渲染实体
		 */
		function get sourceEntity():Entity;
	}
}
