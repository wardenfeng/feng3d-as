package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;

	import me.feng3d.arcanefagal;

	use namespace arcanefagal;

	/**
	 * 深度测试缓存
	 * @author warden_feng 2014-8-28
	 */
	public class DepthTestBuffer extends Context3DBuffer
	{
		arcanefagal var depthMask:Boolean;
		arcanefagal var passCompareMode:String;

		/**
		 * 创建一个深度测试缓存
		 * @param dataTypeId 		数据缓存编号
		 * @param updateFunc 		更新回调函数
		 */
		public function DepthTestBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		/**
		 * @inheritDoc
		 */
		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			context3D.setDepthTest(depthMask, passCompareMode);
		}

		/**
		 * 更新
		 * @param depthMask
		 * @param passCompareMode
		 */
		public function update(depthMask:Boolean, passCompareMode:String):void
		{
			this.depthMask = depthMask;
			this.passCompareMode = passCompareMode;
		}
	}
}
