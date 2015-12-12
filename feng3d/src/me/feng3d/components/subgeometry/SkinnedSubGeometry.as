package me.feng3d.components.subgeometry
{
	import me.feng.component.event.ComponentEvent;
	import me.feng3d.arcane;

	use namespace arcane;

	/**
	 * 蒙皮子网格
	 * 提供了关节 索引数据与权重数据
	 */
	public class SkinnedSubGeometry extends SubGeometryComponent
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

		/**
		 * 处理被添加事件
		 * @param event
		 */
		override protected function onBeAddedComponet(event:ComponentEvent):void
		{
			super.onBeAddedComponet(event);

			subGeometry.mapVABuffer(_.animated_va_3, 3);
			subGeometry.mapVABuffer(_.jointweights_va_x, _jointsPerVertex);
			subGeometry.mapVABuffer(_.jointindex_va_x, _jointsPerVertex);
		}

		/**
		 * 更新动画顶点数据
		 */
		public function updateAnimatedData(value:Vector.<Number>):void
		{
			subGeometry.setVAData(_.animated_va_3, value);
		}

		/**
		 * 关节权重数据
		 */
		arcane function get jointWeightsData():Vector.<Number>
		{
			var data:Vector.<Number> = subGeometry.getVAData(_.jointweights_va_x);
			return data;
		}

		/**
		 * 关节索引数据
		 */
		arcane function get jointIndexData():Vector.<Number>
		{
			var data:Vector.<Number> = subGeometry.getVAData(_.jointindex_va_x);
			return data;
		}

		/**
		 * 更新关节权重数据
		 */
		arcane function updateJointWeightsData(value:Vector.<Number>):void
		{
			subGeometry.setVAData(_.jointweights_va_x, value);
		}

		/**
		 * 更新关节索引数据
		 */
		arcane function updateJointIndexData(value:Vector.<Number>):void
		{
			subGeometry.setVAData(_.jointindex_va_x, value);
		}
	}
}
