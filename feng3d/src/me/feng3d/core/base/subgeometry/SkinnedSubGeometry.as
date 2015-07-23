package me.feng3d.core.base.subgeometry
{
	import me.feng3d.arcane;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	use namespace arcane;

	/**
	 * 蒙皮子网格
	 * 提供了关节 索引数据与权重数据
	 */
	public class SkinnedSubGeometry extends SubGeometry
	{
		private var _jointsPerVertex:int;

		/**
		 * 创建蒙皮子网格
		 */
		public function SkinnedSubGeometry(jointsPerVertex:int)
		{
			_jointsPerVertex = jointsPerVertex;
			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			mapVABuffer(Context3DBufferTypeID.animated_va_3, 3);
			mapVABuffer(Context3DBufferTypeID.jointweights_va_x, _jointsPerVertex);
			mapVABuffer(Context3DBufferTypeID.jointindex_va_x, _jointsPerVertex);
		}

		/**
		 * 更新动画顶点数据
		 */
		public function updateAnimatedData(value:Vector.<Number>):void
		{
			setVAData(Context3DBufferTypeID.animated_va_3, value);
		}

		/**
		 * 关节权重数据
		 */
		arcane function get jointWeightsData():Vector.<Number>
		{
			var data:Vector.<Number> = getVAData(Context3DBufferTypeID.jointweights_va_x);
			return data;
		}

		/**
		 * 关节索引数据
		 */
		arcane function get jointIndexData():Vector.<Number>
		{
			var data:Vector.<Number> = getVAData(Context3DBufferTypeID.jointindex_va_x);
			return data;
		}

		/**
		 * 更新关节权重数据
		 */
		arcane function updateJointWeightsData(value:Vector.<Number>):void
		{
			setVAData(Context3DBufferTypeID.jointweights_va_x, value);
		}

		/**
		 * 更新关节索引数据
		 */
		arcane function updateJointIndexData(value:Vector.<Number>):void
		{
			setVAData(Context3DBufferTypeID.jointindex_va_x, value);
		}
	}
}
