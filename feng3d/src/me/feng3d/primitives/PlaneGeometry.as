package me.feng3d.primitives
{
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 平面网格（四边形）
	 * @author warden_feng 2014-4-15
	 */
	public class PlaneGeometry extends PrimitiveBase
	{
		private var _segmentsW:uint;
		private var _segmentsH:uint;
		private var _yUp:Boolean;
		private var _width:Number;
		private var _height:Number;
		private var _doubleSided:Boolean;

		/**
		 * 创建一个平面
		 * @param width 宽度
		 * @param height 高度
		 * @param segmentsW 横向分割数
		 * @param segmentsH 纵向分割数
		 * @param yUp 正面朝向 true:Y+ false:Z+
		 * @param doubleSided 是否双面
		 */
		public function PlaneGeometry(width:Number = 100, height:Number = 100, segmentsW:uint = 1, segmentsH:uint = 1, yUp:Boolean = true, doubleSided:Boolean = false)
		{
			super();

			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_yUp = yUp;
			_width = width;
			_height = height;
			_doubleSided = doubleSided;
		}

		/**
		 * 横向分割数
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
		 * 纵向分割数
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
		 * 正面朝向 true:Y+ false:Z+
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

		/**
		 * 是否双面
		 */
		public function get doubleSided():Boolean
		{
			return _doubleSided;
		}

		public function set doubleSided(value:Boolean):void
		{
			_doubleSided = value;
			invalidateGeometry();
		}

		/**
		 * 宽度
		 */
		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
			invalidateGeometry();
		}

		/**
		 * 高度
		 */
		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
			invalidateGeometry();
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildGeometry(target:SubGeometry):void
		{
			var vertexPositionData:Vector.<Number>;
			var vertexNormalData:Vector.<Number>;
			var vertexTangentData:Vector.<Number>;
			var indices:Vector.<uint>;
			var x:Number, y:Number;
			var numIndices:uint;
			var base:uint;
			var tw:uint = _segmentsW + 1;
			var numVertices:uint = (_segmentsH + 1) * tw;
			var vertexPositionStride:uint = target.getVALen(Context3DBufferTypeID.POSITION_VA_3);
			var vertexNormalStride:uint = target.getVALen(Context3DBufferTypeID.NORMAL_VA_3);
			var vertexTangentStride:uint = target.getVALen(Context3DBufferTypeID.TANGENT_VA_3);
			if (_doubleSided)
				numVertices *= 2;

			numIndices = _segmentsH * _segmentsW * 6;
			if (_doubleSided)
				numIndices <<= 1;

			if (numVertices == target.numVertices)
			{
				vertexPositionData = target.getVAData(Context3DBufferTypeID.POSITION_VA_3);
				vertexNormalData = target.getVAData(Context3DBufferTypeID.NORMAL_VA_3);
				vertexTangentData = target.getVAData(Context3DBufferTypeID.TANGENT_VA_3);
				indices = target.indexData || new Vector.<uint>(numIndices, true);
			}
			else
			{
				vertexPositionData = new Vector.<Number>(numVertices * vertexPositionStride, true);
				vertexNormalData = new Vector.<Number>(numVertices * vertexNormalStride, true);
				vertexTangentData = new Vector.<Number>(numVertices * vertexTangentStride, true);
				indices = new Vector.<uint>(numIndices, true);
				invalidateUVs();
			}
			target.numVertices = numVertices;

			numIndices = 0;
			var positionIndex:uint = 0;
			var normalIndex:uint = 0;
			var tangentIndex:uint = 0;
			for (var yi:uint = 0; yi <= _segmentsH; ++yi)
			{
				for (var xi:uint = 0; xi <= _segmentsW; ++xi)
				{
					x = (xi / _segmentsW - .5) * _width;
					y = (yi / _segmentsH - .5) * _height;

					//设置坐标数据
					vertexPositionData[positionIndex++] = x;
					if (_yUp)
					{
						vertexPositionData[positionIndex++] = 0;
						vertexPositionData[positionIndex++] = y;
					}
					else
					{
						vertexPositionData[positionIndex++] = y;
						vertexPositionData[positionIndex++] = 0;
					}

					//设置法线数据
					vertexNormalData[normalIndex++] = 0;
					if (_yUp)
					{
						vertexNormalData[normalIndex++] = 1;
						vertexNormalData[normalIndex++] = 0;
					}
					else
					{
						vertexNormalData[normalIndex++] = 0;
						vertexNormalData[normalIndex++] = -1;
					}

					vertexTangentData[tangentIndex++] = 1;
					vertexTangentData[tangentIndex++] = 0;
					vertexTangentData[tangentIndex++] = 0;

					//复制反面数据
					if (_doubleSided)
					{
						for (var i:int = 0; i < 3; ++i)
						{
							vertexPositionData[positionIndex] = vertexPositionData[positionIndex - vertexPositionStride];
							++positionIndex;
						}
						for (i = 0; i < 3; ++i)
						{
							vertexPositionData[normalIndex] = -vertexPositionData[normalIndex - vertexNormalStride];
							++normalIndex;
						}
						for (i = 0; i < 3; ++i)
						{
							vertexTangentData[tangentIndex] = -vertexTangentData[tangentIndex - vertexTangentStride];
							++tangentIndex;
						}
					}

					//生成索引数据
					if (xi != _segmentsW && yi != _segmentsH)
					{
						base = xi + yi * tw;
						var mult:int = _doubleSided ? 2 : 1;

						indices[numIndices++] = base * mult;
						indices[numIndices++] = (base + tw) * mult;
						indices[numIndices++] = (base + tw + 1) * mult;
						indices[numIndices++] = base * mult;
						indices[numIndices++] = (base + tw + 1) * mult;
						indices[numIndices++] = (base + 1) * mult;

						//设置反面索引数据
						if (_doubleSided)
						{
							indices[numIndices++] = (base + tw + 1) * mult + 1;
							indices[numIndices++] = (base + tw) * mult + 1;
							indices[numIndices++] = base * mult + 1;
							indices[numIndices++] = (base + 1) * mult + 1;
							indices[numIndices++] = (base + tw + 1) * mult + 1;
							indices[numIndices++] = base * mult + 1;
						}
					}
				}
			}

			target.updateVertexPositionData(vertexPositionData);
			target.setVAData(Context3DBufferTypeID.NORMAL_VA_3, vertexNormalData);
			target.setVAData(Context3DBufferTypeID.TANGENT_VA_3, vertexTangentData);
			target.updateIndexData(indices);
		}

		override protected function buildUVs(target:SubGeometry):void
		{
			var data:Vector.<Number>;
			var stride:uint = target.getVALen(Context3DBufferTypeID.UV_VA_2);
			var numUvs:uint = (_segmentsH + 1) * (_segmentsW + 1) * stride;

			if (_doubleSided)
				numUvs *= 2;

			data = target.getVAData(Context3DBufferTypeID.UV_VA_2);
			if (data == null || numUvs != data.length)
			{
				data = new Vector.<Number>(numUvs, true);
				invalidateGeometry();
			}

			var index:uint = 0;

			for (var yi:uint = 0; yi <= _segmentsH; ++yi)
			{
				for (var xi:uint = 0; xi <= _segmentsW; ++xi)
				{
					data[index++] = (xi / _segmentsW) * target.scaleU;
					data[index++] = (1 - yi / _segmentsH) * target.scaleV;

					if (_doubleSided)
					{
						data[index++] = (xi / _segmentsW) * target.scaleU;
						data[index++] = (1 - yi / _segmentsH) * target.scaleV;
					}
				}
			}

			target.setVAData(Context3DBufferTypeID.UV_VA_2, data);
		}
	}
}
