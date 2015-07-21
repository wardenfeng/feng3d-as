package me.feng3d.core.buffer.context3d
{

	/**
	 * 3d环境常量数据缓存
	 * @author warden_feng 2014-8-20
	 */
	public class ConstantsBuffer extends RegisterBuffer
	{
		/**
		 * 创建3d环境常量数据缓存	
		 * @param dataTypeId 		数据编号
		 * @param updateFunc 		数据更新回调函数
		 */
		public function ConstantsBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}
	}
}
