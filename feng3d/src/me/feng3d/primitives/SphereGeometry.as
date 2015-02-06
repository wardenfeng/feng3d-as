package me.feng3d.primitives
{
	import me.feng3d.arcane;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.buffer.Context3DBufferTypeID;

	use namespace arcane;

	/**
	 * 球体网格
	 */
	public class SphereGeometry extends PrimitiveBase
	{
		private var _radius:Number;
		private var _segmentsW:uint;
		private var _segmentsH:uint;
		private var _yUp:Boolean;

		/**
		 * 创建一个球体
		 * @param radius 半径
		 * @param segmentsW 横向分割数，默认值16
		 * @param segmentsH 纵向分割数，默认值12
		 * @param yUp 球体朝向 true:Y+ false:Z+
		 */
		public function SphereGeometry(radius:Number = 50, segmentsW:uint = 16, segmentsH:uint = 12, yUp:Boolean = true)
		{
			super();

			_radius = radius;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_yUp = yUp;
		}

		protected override function buildGeometry(target:SubGeometry):void
		{
			var vertexPositionData:Vector.<Number>;
			var vertexNormalData:Vector.<Number>;
			var vertexTangentData:Vector.<Number>;
			var indices:Vector.<uint>;
			var i:uint, j:uint, triIndex:uint;
			var numVerts:uint = (_segmentsH + 1) * (_segmentsW + 1);

			var vertexPositionStride:uint = target.getVALen(Context3DBufferTypeID.POSITION_VA_3);
			var vertexNormalStride:uint = target.getVALen(Context3DBufferTypeID.NORMAL_VA_3);
			var vertexTangentStride:uint = target.getVALen(Context3DBufferTypeID.TANGENT_VA_3);

			if (numVerts == target.numVertices)
			{
				vertexPositionData = target.getVAData(Context3DBufferTypeID.POSITION_VA_3);
				vertexNormalData = target.getVAData(Context3DBufferTypeID.NORMAL_VA_3);
				vertexTangentData = target.getVAData(Context3DBufferTypeID.TANGENT_VA_3);
				indices = target.indexData || new Vector.<uint>((_segmentsH - 1) * _segmentsW * 6, true);
			}
			else
			{
				vertexPositionData = new Vector.<Number>(numVerts * vertexPositionStride, true);
				vertexNormalData = new Vector.<Number>(numVerts * vertexNormalStride, true);
				vertexTangentData = new Vector.<Number>(numVerts * vertexTangentStride, true);
				indices = new Vector.<uint>((_segmentsH - 1) * _segmentsW * 6, true);
				invalidateGeometry();
			}

			var startPositionIndex:uint;
			var startNormalIndex:uint;
			var positionIndex:uint = 0;
			var normalIndex:uint = 0;
			var tangentIndex:uint = 0;
			var comp1:Number, comp2:Number, t1:Number, t2:Number;

			for (j = 0; j <= _segmentsH; ++j)
			{
				startPositionIndex = positionIndex;
				startNormalIndex = normalIndex;

				var horangle:Number = Math.PI * j / _segmentsH;
				var z:Number = -_radius * Math.cos(horangle);
				var ringradius:Number = _radius * Math.sin(horangle);

				for (i = 0; i <= _segmentsW; ++i)
				{
					var verangle:Number = 2 * Math.PI * i / _segmentsW;
					var x:Number = ringradius * Math.cos(verangle);
					var y:Number = ringradius * Math.sin(verangle);
					var normLen:Number = 1 / Math.sqrt(x * x + y * y + z * z);
					var tanLen:Number = Math.sqrt(y * y + x * x);

					if (_yUp)
					{
						t1 = 0;
						t2 = tanLen > .007 ? x / tanLen : 0;
						comp1 = -z;
						comp2 = y;

					}
					else
					{
						t1 = tanLen > .007 ? x / tanLen : 0;
						t2 = 0;
						comp1 = y;
						comp2 = z;
					}

					if (i == _segmentsW)
					{
						vertexPositionData[positionIndex++] = vertexPositionData[startPositionIndex];
						vertexPositionData[positionIndex++] = vertexPositionData[startPositionIndex + 1];
						vertexPositionData[positionIndex++] = vertexPositionData[startPositionIndex + 2];
						vertexNormalData[normalIndex++] = vertexNormalData[startNormalIndex] + (x * normLen) * .5;
						vertexNormalData[normalIndex++] = vertexNormalData[startNormalIndex + 1] + (comp1 * normLen) * .5;
						vertexNormalData[normalIndex++] = vertexNormalData[startNormalIndex + 2] + (comp2 * normLen) * .5;
						vertexTangentData[tangentIndex++] = tanLen > .007 ? -y / tanLen : 1;
						vertexTangentData[tangentIndex++] = t1;
						vertexTangentData[tangentIndex++] = t2;
					}
					else
					{
						vertexPositionData[positionIndex++] = x;
						vertexPositionData[positionIndex++] = comp1;
						vertexPositionData[positionIndex++] = comp2;
						vertexNormalData[normalIndex++] = x * normLen;
						vertexNormalData[normalIndex++] = comp1 * normLen;
						vertexNormalData[normalIndex++] = comp2 * normLen;
						vertexTangentData[tangentIndex++] = tanLen > .007 ? -y / tanLen : 1;
						vertexTangentData[tangentIndex++] = t1;
						vertexTangentData[tangentIndex++] = t2;
					}

					if (i > 0 && j > 0)
					{
						var a:int = (_segmentsW + 1) * j + i;
						var b:int = (_segmentsW + 1) * j + i - 1;
						var c:int = (_segmentsW + 1) * (j - 1) + i - 1;
						var d:int = (_segmentsW + 1) * (j - 1) + i;

						if (j == _segmentsH)
						{
							indices[triIndex++] = a;
							indices[triIndex++] = c;
							indices[triIndex++] = d;

						}
						else if (j == 1)
						{
							indices[triIndex++] = a;
							indices[triIndex++] = b;
							indices[triIndex++] = c;

						}
						else
						{
							indices[triIndex++] = a;
							indices[triIndex++] = b;
							indices[triIndex++] = c;
							indices[triIndex++] = a;
							indices[triIndex++] = c;
							indices[triIndex++] = d;
						}
					}
				}
			}

			target.numVertices = numVerts;
			target.updateVertexPositionData(vertexPositionData);
			target.setVAData(Context3DBufferTypeID.NORMAL_VA_3, vertexNormalData);
			target.setVAData(Context3DBufferTypeID.TANGENT_VA_3, vertexTangentData);
			target.updateIndexData(indices);
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildUVs(target:SubGeometry):void
		{
			var i:int, j:int;
			var stride:uint = target.getVALen(Context3DBufferTypeID.UV_VA_2);
			var numUvs:uint = (_segmentsH + 1) * (_segmentsW + 1) * stride;
			var data:Vector.<Number>;
			var skip:uint = stride - 2;

			data = target.getVAData(Context3DBufferTypeID.UV_VA_2);
			if (data == null || numUvs != data.length)
			{
				data = new Vector.<Number>(numUvs, true);
				invalidateGeometry();
			}

			var index:int = 0;
			for (j = 0; j <= _segmentsH; ++j)
			{
				for (i = 0; i <= _segmentsW; ++i)
				{
					data[index++] = (i / _segmentsW) * target.scaleU;
					data[index++] = (j / _segmentsH) * target.scaleV;
					index += skip;
				}
			}

			target.setVAData(Context3DBufferTypeID.UV_VA_2, data);
		}

		/**
		 * 半径
		 */
		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
			invalidateGeometry();
		}

		/**
		 * 横向分割数，默认值16
		 */
		public function get segmentsW():uint
		{
			return _segmentsW;
		}

		public function set segmentsW(value:uint):void
		{
			_segmentsW = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * 纵向分割数，默认值12
		 */
		public function get segmentsH():uint
		{
			return _segmentsH;
		}

		public function set segmentsH(value:uint):void
		{
			_segmentsH = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * 球体朝向 true:Y+ false:Z+
		 */
		public function get yUp():Boolean
		{
			return _yUp;
		}

		public function set yUp(value:Boolean):void
		{
			_yUp = value;
			invalidateGeometry();
		}
	}
}
