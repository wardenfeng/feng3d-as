package me.feng3d.primitives
{
	import me.feng3d.core.base.subgeometry.SubGeometry;

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
		 * The number of segments that make up the plane along the X-axis. Defaults to 1.
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
		 * The number of segments that make up the plane along the Y or Z-axis, depending on whether yUp is true or
		 * false, respectively. Defaults to 1.
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
		 *  Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false). Defaults to true.
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
		 * Defines whether the plane will be visible from both sides, with correct vertex normals (as opposed to bothSides on Material). Defaults to false.
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
		 * The width of the plane.
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
		 * The height of the plane.
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
			var indices:Vector.<uint>;
			var x:Number, y:Number;
			var numIndices:uint;
			var base:uint;
			var tw:uint = _segmentsW + 1;
			var numVertices:uint = (_segmentsH + 1) * tw;
			var vertexPositionStride:uint = target.vertexStride;
			var vertexNormalStride:uint = target.vertexNormalStride;
			if (_doubleSided)
				numVertices *= 2;

			numIndices = _segmentsH * _segmentsW * 6;
			if (_doubleSided)
				numIndices <<= 1;

			if (numVertices == target.numVertices)
			{
				vertexPositionData = target.vertexPositionData;
				vertexNormalData = target.vertexNormalData;
				indices = target.indexData || new Vector.<uint>(numIndices, true);
			}
			else
			{
				vertexPositionData = new Vector.<Number>(numVertices * vertexPositionStride, true);
				vertexNormalData = new Vector.<Number>(numVertices * vertexNormalStride, true);
				indices = new Vector.<uint>(numIndices, true);
				invalidateUVs();
			}

			numIndices = 0;
			var positionIndex:uint = target.vertexOffset;
			var normalIndex:uint = target.vertexNormalOffset;
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

			target.updateVertexData(vertexPositionData);
			
			target.updateNormalData(vertexNormalData);
			target.updateIndexData(indices);
		}

		/**
		 * @inheritDoc
		 */
		override protected function buildUVs(target:SubGeometry):void
		{
			var data:Vector.<Number>;
			var stride:uint = target.UVStride;
			var numUvs:uint = (_segmentsH + 1) * (_segmentsW + 1) * stride;

			if (_doubleSided)
				numUvs *= 2;

			if (target.UVData && numUvs == target.UVData.length)
				data = target.UVData;
			else
			{
				data = new Vector.<Number>(numUvs, true);
				invalidateGeometry();
			}

			var index:uint = target.UVOffset;

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

			target.updateUVData(data);
		}
	}
}
