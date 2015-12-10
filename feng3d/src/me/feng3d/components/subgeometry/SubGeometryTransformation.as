package me.feng3d.components.subgeometry
{
	import me.feng.component.Component;
	import me.feng.component.event.ComponentEvent;
	import me.feng.component.event.vo.AddedComponentEventVO;
	import me.feng.component.event.vo.RemovedComponentEventVO;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.fagalRE.FagalIdCenter;

	/**
	 * 子几何体形变组件
	 * @author feng 2015-12-10
	 */
	public class SubGeometryTransformation extends Component
	{
		private var subGeometry:SubGeometry;

		private var _scaleU:Number = 1;
		private var _scaleV:Number = 1;

		public function SubGeometryTransformation()
		{
			super();

			addEventListener(ComponentEvent.BE_ADDED_COMPONET, onBeAddedComponet);
			addEventListener(ComponentEvent.BE_REMOVED_COMPONET, onBeRemovedComponet);
		}

		/**
		 * 处理被添加事件
		 * @param event
		 */
		protected function onBeAddedComponet(event:ComponentEvent):void
		{
			var addedComponentEventVO:AddedComponentEventVO = event.data;
			subGeometry = addedComponentEventVO.container as SubGeometry;
		}

		/**
		 * 处理被移除事件
		 * @param event
		 */
		protected function onBeRemovedComponet(event:ComponentEvent):void
		{
			var removedComponentEventVO:RemovedComponentEventVO = event.data;
			subGeometry = null;
		}


		public function get scaleU():Number
		{
			return _scaleU;
		}

		public function get scaleV():Number
		{
			return _scaleV;
		}

		public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			var stride:int = subGeometry.getVALen(_.uv_va_2);
			var uvs:Vector.<Number> = subGeometry.UVData;
			var len:int = uvs.length;
			var ratioU:Number = scaleU / _scaleU;
			var ratioV:Number = scaleV / _scaleV;

			for (var i:uint = 0; i < len; i += stride)
			{
				uvs[i] *= ratioU;
				uvs[i + 1] *= ratioV;
			}

			_scaleU = scaleU;
			_scaleV = scaleV;

			subGeometry.setVAData(_.uv_va_2, uvs);
		}

		/**
		 * Fagal编号中心
		 */
		public function get _():FagalIdCenter
		{
			return FagalIdCenter.instance;
		}
	}
}
