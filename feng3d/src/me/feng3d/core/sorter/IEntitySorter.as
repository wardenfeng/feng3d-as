package me.feng3d.core.sorter
{
	import me.feng3d.core.traverse.EntityCollector;

	/**
	 * 实体排序接口
	 * <p>为优化渲染EntityCollector排序</p>
	 * @author feng 2015-3-6
	 */
	public interface IEntitySorter
	{
		/**
		 * 排序实体收集器中潜在显示对象
		 * @param collector		实体收集器
		 */
		function sort(collector:EntityCollector):void;
	}
}
