package me.feng.error
{

	/**
	 * 抽象方法错误
	 * @author warden_feng 2015-2-13
	 */
	public class AbstractMethodError extends Error
	{
		/**
		 * 创建一个抽象方法错误
		 * @param message 与 Error 对象关联的字符串；此参数为可选。
		 * @param id 与特定错误消息关联的引用数字。
		 */
		public function AbstractMethodError(message:String = null, id:int = 0)
		{
			super(message || "子类没有重写抽象方法", id);
		}
	}
}
