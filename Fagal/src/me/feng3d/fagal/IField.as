package me.feng3d.fagal
{

	/**
	 * 寄存器项
	 * @author warden_feng 2014-10-22
	 */
	public interface IField
	{
		function toString():String;

		/**
		 * 寄存器类型
		 */
		function get regType():String;
		
		/**
		 * 寄存器描述
		 */
		function get desc():String;
		
	}
}
