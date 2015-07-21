package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;

	import me.feng3d.arcanefagal;

	use namespace arcanefagal;

	/**
	 * 混合因素缓存
	 * @author warden_feng 2014-8-28
	 */
	public class BlendFactorsBuffer extends Context3DBuffer
	{
		/** 用于与源颜色相乘的系数。默认为 Context3DBlendFactor.ONE。 */
		arcanefagal var sourceFactor:String;
		/** 用于与目标颜色相乘的系数。默认为 Context3DBlendFactor.ZERO */
		arcanefagal var destinationFactor:String;

		/**
		 * 创建混合因素缓存
		 * @param dataTypeId	数据缓存编号
		 * @param updateFunc	更新回调函数
		 */
		public function BlendFactorsBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		/**
		 * 更新混合因素缓存
		 * @param sourceFactor 用于与源颜色相乘的系数。默认为 Context3DBlendFactor.ONE。
		 * @param destinationFactor 用于与目标颜色相乘的系数。默认为 Context3DBlendFactor.ZERO。
		 * @see flash.display3D.Context3D
		 * @see flash.display3D.Context3D.setBlendFactors
		 */
		public function update(sourceFactor:String, destinationFactor:String):void
		{
			this.sourceFactor = sourceFactor;
			this.destinationFactor = destinationFactor;
		}

		/**
		 * 执行混合因素缓存
		 * @param context3D		3d环境
		 */
		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			context3D.setBlendFactors(sourceFactor, destinationFactor);
		}
	}
}
