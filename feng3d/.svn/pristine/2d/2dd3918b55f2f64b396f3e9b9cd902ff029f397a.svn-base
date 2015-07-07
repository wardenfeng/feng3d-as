package me.feng3d.primitives
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;

	/**
	* 线框几何体
	 * @author warden_feng 2014-5-8
	 */
	public class WireframeGeometry extends WireframePrimitiveBase
	{
		private var _drawGeometry:Geometry = new Geometry();

		/**
		 * 创建几何体线框
		 * @param geometry 几何体
		 * @param color 线条颜色
		 * @param thickness 线条粗细
		 */
		public function WireframeGeometry(color:uint = 0xffffff, thickness:Number = 1)
		{
			super(color, thickness);
		}

		public function get drawGeometry():Geometry
		{
			return _drawGeometry;
		}

		/**
		 * 绘制几何体线框
		 */
		public function setDrawGeometry(value:Geometry):void
		{
			_drawGeometry = value;
			_segmentSubGeometry.invalid();
		}

		override protected function buildGeometry():void
		{
			removeAllSegments();
			if (drawGeometry == null)
				return;
			//避免重复绘制同一条线段
			var segmentDic:Dictionary = new Dictionary();

			var subGeometries:Vector.<SubGeometry> = drawGeometry.subGeometries;
			var subGeometry:SubGeometry;
			for (var j:int = 0; j < subGeometries.length; j++)
			{
				subGeometry = subGeometries[j];

				//顶点索引
				var _vertexIndices:Vector.<uint> = subGeometry.indexData;
				//顶点位置
				var _vertices:Vector.<Number> = subGeometry.getVAData(Context3DBufferTypeIDCommon.POSITION_VA_3);

				var numTriangle:uint = _vertexIndices.length / 3;
				var indexA:uint;
				var indexB:uint;
				var indexC:uint;

				var posA:Vector3D;
				var posB:Vector3D;
				var posC:Vector3D;
				var segmentIndex:uint = 0;
				for (var i:int = 0; i < numTriangle; i++)
				{
					indexA = _vertexIndices[i * 3];
					indexB = _vertexIndices[i * 3 + 1];
					indexC = _vertexIndices[i * 3 + 2];

					posA = new Vector3D(_vertices[indexA * 3], _vertices[indexA * 3 + 1], _vertices[indexA * 3 + 2]);
					posB = new Vector3D(_vertices[indexB * 3], _vertices[indexB * 3 + 1], _vertices[indexB * 3 + 2]);
					posC = new Vector3D(_vertices[indexC * 3], _vertices[indexC * 3 + 1], _vertices[indexC * 3 + 2]);
					//线段AB
					if (!segmentDic[posA.toString() + "-" + posB.toString()])
					{
						updateOrAddSegment(++segmentIndex, posA, posB);
						segmentDic[posA.toString() + "-" + posB.toString()] = segmentDic[posB.toString() + "-" + posA.toString()] = true;
					}
					//线段BC
					if (!segmentDic[posB.toString() + "-" + posC.toString()])
					{
						updateOrAddSegment(++segmentIndex, posB, posC);
						segmentDic[posB.toString() + "-" + posC.toString()] = segmentDic[posC.toString() + "-" + posB.toString()] = true;
					}
					//线段CA
					if (!segmentDic[posC.toString() + "-" + posA.toString()])
					{
						updateOrAddSegment(++segmentIndex, posC, posA);
						segmentDic[posC.toString() + "-" + posA.toString()] = segmentDic[posA.toString() + "-" + posC.toString()] = true;
					}
				}
			}

		}
	}
}
