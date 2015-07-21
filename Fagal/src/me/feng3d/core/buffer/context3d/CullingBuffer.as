package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;

	import me.feng3d.arcanefagal;

	use namespace arcanefagal;

	/**
	 * 三角形剔除模式缓存
	 * @author warden_feng 2014-8-14
	 */
	public class CullingBuffer extends Context3DBuffer
	{
		/** 三角形剔除模式 */
		arcanefagal var triangleFaceToCull:String;

		/**
		 * 创建一个三角形剔除模式缓存
		 * @param dataTypeId 		数据缓存编号
		 * @param updateFunc 		更新回调函数
		 */
		public function CullingBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		/**
		 * @inheritDoc
		 */
		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			context3D.setCulling(triangleFaceToCull);
		}

		/**
		 * 更新
		 * @param triangleFaceToCull
		 */
		public function update(triangleFaceToCull:String):void
		{
			this.triangleFaceToCull = triangleFaceToCull;
		}
	}
}
