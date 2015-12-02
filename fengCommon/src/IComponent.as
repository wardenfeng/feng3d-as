package
{
	import flash.events.IEventDispatcher;

	import me.feng.component.IComponentContainer;

	/**
	 * 组件接口
	 * @author warden_feng 2015-12-2
	 */
	public interface IComponent extends IEventDispatcher
	{
		/**
		 * 组件名称
		 */
		function get componentName():String;
		function set componentName(value:String):void;

		/**
		 * 组件所在容器
		 */
		function get container():IComponentContainer;
		function set container(value:IComponentContainer):void;
	}
}
