package me.feng3d.primitives
{
	import me.feng3d.arcane;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	use namespace arcane;

	/**
	 * A Cube primitive mesh.
	 */
	public class CubeGeometry extends PrimitiveBase
	{
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		private var _tile6:Boolean;

		private var _segmentsW:Number;
		private var _segmentsH:Number;
		private var _segmentsD:Number;

		/**
		 * Creates a new Cube object.
		 * @param width The size of the cube along its X-axis.
		 * @param height The size of the cube along its Y-axis.
		 * @param depth The size of the cube along its Z-axis.
		 * @param segmentsW The number of segments that make up the cube along the X-axis.
		 * @param segmentsH The number of segments that make up the cube along the Y-axis.
		 * @param segmentsD The number of segments that make up the cube along the Z-axis.
		 * @param tile6 The type of uv mapping to use. When true, a texture will be subdivided in a 2x3 grid, each used for a single face. When false, the entire image is mapped on each face.
		 */
		public function CubeGeometry(width:Number = 100, height:Number = 100, depth:Number = 100, segmentsW:uint = 1, segmentsH:uint = 1, segmentsD:uint = 1, tile6:Boolean = true)
		{
			super();

			_width = width;
			_height = height;
			_depth = depth;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_segmentsD = segmentsD;
			_tile6 = tile6;
		}

		/**
		 * The size of the cube along its X-axis.
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
		 * The size of the cube along its Y-axis.
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
		 * The size of the cube along its Z-axis.
		 */
		public function get depth():Number
		{
			return _depth;
		}

		public function set depth(value:Number):void
		{
			_depth = value;
			invalidateGeometry();
		}

		/**
		 * The type of uv mapping to use. When false, the entire image is mapped on each face.
		 * When true, a texture will be subdivided in a 3x2 grid, each used for a single face.
		 * Reading the tiles from left to right, top to bottom they represent the faces of the
		 * cube in the following order: bottom, top, back, left, front, right. This creates
		 * several shared edges (between the top, front, left and right faces) which simplifies
		 * texture painting.
		 */
		public function get tile6():Boolean
		{
			return _tile6;
		}

		public function set tile6(value:Boolean):void
		{
			_tile6 = value;
			invalidateUVs();
		}

		/**
		 * The number of segments that make up the cube along the X-axis. Defaults to 1.
		 */
		public function get segmentsW():Number
		{
			return _segmentsW;
		}

		public function set segmentsW(value:Number):void
		{
			_segmentsW = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * The number of segments that make up the cube along the Y-axis. Defaults to 1.
		 */
		public function get segmentsH():Number
		{
			return _segmentsH;
		}

		public function set segmentsH(value:Number):void
		{
			_segmentsH = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * The number of segments that make up the cube along the Z-axis. Defaults to 1.
		 */
		public function get segmentsD():Number
		{
			return _segmentsD;
		}

		public function set segmentsD(value:Number):void
		{
			_segmentsD = value;
			invalidateGeometry();
			invalidateUVs();
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

			var tl:uint, tr:uint, bl:uint, br:uint;
			var i:uint, j:uint, inc:uint = 0;


			var hw:Number, hh:Number, hd:Number; // halves
			var dw:Number, dh:Number, dd:Number; // deltas

			var outer_pos:Number;

			var numVerts:uint = ((_segmentsW + 1) * (_segmentsH + 1) + (_segmentsW + 1) * (_segmentsD + 1) + (_segmentsH + 1) * (_segmentsD + 1)) * 2;
			var vertexPositionStride:uint = target.getVALen(Context3DBufferTypeID.POSITION_VA_3);
			var vertexNormalStride:uint = target.getVALen(Context3DBufferTypeID.NORMAL_VA_3);
			var vertexTangentStride:uint = target.getVALen(Context3DBufferTypeID.TANGENT_VA_3);

			if (numVerts == target.numVertices)
			{
				vertexPositionData = target.getVAData(Context3DBufferTypeID.POSITION_VA_3);
				vertexNormalData = target.getVAData(Context3DBufferTypeID.NORMAL_VA_3);
				vertexTangentData = target.getVAData(Context3DBufferTypeID.TANGENT_VA_3);
				indices = target.indexData || new Vector.<uint>((_segmentsW * _segmentsH + _segmentsW * _segmentsD + _segmentsH * _segmentsD) * 12, true);
			}
			else
			{
				vertexPositionData = new Vector.<Number>(numVerts * vertexPositionStride, true);
				vertexNormalData = new Vector.<Number>(numVerts * vertexNormalStride, true);
				vertexTangentData = new Vector.<Number>(numVerts * vertexTangentStride, true);
				indices = new Vector.<uint>((_segmentsW * _segmentsH + _segmentsW * _segmentsD + _segmentsH * _segmentsD) * 12, true);
				invalidateUVs();
			}

			// Indices
			var positionIndex:uint = 0;
			var normalIndex:uint = 0;
			var tangentIndex:uint = 0;

			var fidx:uint = 0;

			// half cube dimensions
			hw = _width / 2;
			hh = _height / 2;
			hd = _depth / 2;

			// Segment dimensions
			dw = _width / _segmentsW;
			dh = _height / _segmentsH;
			dd = _depth / _segmentsD;

			for (i = 0; i <= _segmentsW; i++)
			{
				outer_pos = -hw + i * dw;

				for (j = 0; j <= _segmentsH; j++)
				{
					// front
					vertexPositionData[positionIndex++] = outer_pos;
					vertexPositionData[positionIndex++] = -hh + j * dh;
					vertexPositionData[positionIndex++] = -hd;
					vertexNormalData[normalIndex++] = 0;
					vertexNormalData[normalIndex++] = 0;
					vertexNormalData[normalIndex++] = -1;
					vertexTangentData[tangentIndex++] = 1;
					vertexTangentData[tangentIndex++] = 0;
					vertexTangentData[tangentIndex++] = 0;

					// back
					vertexPositionData[positionIndex++] = outer_pos;
					vertexPositionData[positionIndex++] = -hh + j * dh;
					vertexPositionData[positionIndex++] = hd;
					vertexNormalData[normalIndex++] = 0;
					vertexNormalData[normalIndex++] = 0;
					vertexNormalData[normalIndex++] = 1;
					vertexTangentData[tangentIndex++] = -1;
					vertexTangentData[tangentIndex++] = 0;
					vertexTangentData[tangentIndex++] = 0;

					if (i && j)
					{
						tl = 2 * ((i - 1) * (_segmentsH + 1) + (j - 1));
						tr = 2 * (i * (_segmentsH + 1) + (j - 1));
						bl = tl + 2;
						br = tr + 2;

						indices[fidx++] = tl;
						indices[fidx++] = bl;
						indices[fidx++] = br;
						indices[fidx++] = tl;
						indices[fidx++] = br;
						indices[fidx++] = tr;
						indices[fidx++] = tr + 1;
						indices[fidx++] = br + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tr + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tl + 1;
					}
				}
			}

			inc += 2 * (_segmentsW + 1) * (_segmentsH + 1);

			for (i = 0; i <= _segmentsW; i++)
			{
				outer_pos = -hw + i * dw;

				for (j = 0; j <= _segmentsD; j++)
				{
					// top
					vertexPositionData[positionIndex++] = outer_pos;
					vertexPositionData[positionIndex++] = hh;
					vertexPositionData[positionIndex++] = -hd + j * dd;
					vertexNormalData[normalIndex++] = 0;
					vertexNormalData[normalIndex++] = 1;
					vertexNormalData[normalIndex++] = 0;
					vertexTangentData[tangentIndex++] = 1;
					vertexTangentData[tangentIndex++] = 0;
					vertexTangentData[tangentIndex++] = 0;

					// bottom
					vertexPositionData[positionIndex++] = outer_pos;
					vertexPositionData[positionIndex++] = -hh;
					vertexPositionData[positionIndex++] = -hd + j * dd;
					vertexNormalData[normalIndex++] = 0;
					vertexNormalData[normalIndex++] = -1;
					vertexNormalData[normalIndex++] = 0;
					vertexTangentData[tangentIndex++] = 1;
					vertexTangentData[tangentIndex++] = 0;
					vertexTangentData[tangentIndex++] = 0;

					if (i && j)
					{
						tl = inc + 2 * ((i - 1) * (_segmentsD + 1) + (j - 1));
						tr = inc + 2 * (i * (_segmentsD + 1) + (j - 1));
						bl = tl + 2;
						br = tr + 2;

						indices[fidx++] = tl;
						indices[fidx++] = bl;
						indices[fidx++] = br;
						indices[fidx++] = tl;
						indices[fidx++] = br;
						indices[fidx++] = tr;
						indices[fidx++] = tr + 1;
						indices[fidx++] = br + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tr + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tl + 1;
					}
				}
			}

			inc += 2 * (_segmentsW + 1) * (_segmentsD + 1);

			for (i = 0; i <= _segmentsD; i++)
			{
				outer_pos = hd - i * dd;

				for (j = 0; j <= _segmentsH; j++)
				{
					// left
					vertexPositionData[positionIndex++] = -hw;
					vertexPositionData[positionIndex++] = -hh + j * dh;
					vertexPositionData[positionIndex++] = outer_pos;
					vertexNormalData[normalIndex++] = -1;
					vertexNormalData[normalIndex++] = 0;
					vertexNormalData[normalIndex++] = 0;
					vertexTangentData[tangentIndex++] = 0;
					vertexTangentData[tangentIndex++] = 0;
					vertexTangentData[tangentIndex++] = -1;

					// right
					vertexPositionData[positionIndex++] = hw;
					vertexPositionData[positionIndex++] = -hh + j * dh;
					vertexPositionData[positionIndex++] = outer_pos;
					vertexNormalData[normalIndex++] = 1;
					vertexNormalData[normalIndex++] = 0;
					vertexNormalData[normalIndex++] = 0;
					vertexTangentData[tangentIndex++] = 0;
					vertexTangentData[tangentIndex++] = 0;
					vertexTangentData[tangentIndex++] = 1;

					if (i && j)
					{
						tl = inc + 2 * ((i - 1) * (_segmentsH + 1) + (j - 1));
						tr = inc + 2 * (i * (_segmentsH + 1) + (j - 1));
						bl = tl + 2;
						br = tr + 2;

						indices[fidx++] = tl;
						indices[fidx++] = bl;
						indices[fidx++] = br;
						indices[fidx++] = tl;
						indices[fidx++] = br;
						indices[fidx++] = tr;
						indices[fidx++] = tr + 1;
						indices[fidx++] = br + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tr + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tl + 1;
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
		override protected function buildUVs(target:SubGeometry):void
		{
			var i:uint, j:uint, uidx:uint;
			var data:Vector.<Number>;

			var u_tile_dim:Number, v_tile_dim:Number;
			var u_tile_step:Number, v_tile_step:Number;
			var tl0u:Number, tl0v:Number;
			var tl1u:Number, tl1v:Number;
			var du:Number, dv:Number;
			var stride:uint = target.getVALen(Context3DBufferTypeID.UV_VA_2);
			var numUvs:uint = ((_segmentsW + 1) * (_segmentsH + 1) + (_segmentsW + 1) * (_segmentsD + 1) + (_segmentsH + 1) * (_segmentsD + 1)) * 2 * stride;
			var skip:uint = stride - 2;

			data = target.getVAData(Context3DBufferTypeID.UV_VA_2);
			if (data == null || numUvs != data.length)
			{
				data = new Vector.<Number>(numUvs, true);
				invalidateGeometry();
			}

			if (_tile6)
			{
				u_tile_dim = u_tile_step = 1 / 3;
				v_tile_dim = v_tile_step = 1 / 2;
			}
			else
			{
				u_tile_dim = v_tile_dim = 1;
				u_tile_step = v_tile_step = 0;
			}

			// Create planes two and two, the same way that they were
			// constructed in the buildGeometry() function. First calculate
			// the top-left UV coordinate for both planes, and then loop
			// over the points, calculating the UVs from these numbers.

			// When tile6 is true, the layout is as follows:
			//       .-----.-----.-----. (1,1)
			//       | Bot |  T  | Bak |
			//       |-----+-----+-----|
			//       |  L  |  F  |  R  |
			// (0,0)'-----'-----'-----'

			uidx = 0;

			// FRONT / BACK
			tl0u = 1 * u_tile_step;
			tl0v = 1 * v_tile_step;
			tl1u = 2 * u_tile_step;
			tl1v = 0 * v_tile_step;
			du = u_tile_dim / _segmentsW;
			dv = v_tile_dim / _segmentsH;
			for (i = 0; i <= _segmentsW; i++)
			{
				for (j = 0; j <= _segmentsH; j++)
				{
					data[uidx++] = (tl0u + i * du) * target.scaleU;
					data[uidx++] = (tl0v + (v_tile_dim - j * dv)) * target.scaleV;
					uidx += skip;
					data[uidx++] = (tl1u + (u_tile_dim - i * du)) * target.scaleU;
					data[uidx++] = (tl1v + (v_tile_dim - j * dv)) * target.scaleV;
					uidx += skip;
				}
			}

			// TOP / BOTTOM
			tl0u = 1 * u_tile_step;
			tl0v = 0 * v_tile_step;
			tl1u = 0 * u_tile_step;
			tl1v = 0 * v_tile_step;
			du = u_tile_dim / _segmentsW;
			dv = v_tile_dim / _segmentsD;
			for (i = 0; i <= _segmentsW; i++)
			{
				for (j = 0; j <= _segmentsD; j++)
				{
					data[uidx++] = (tl0u + i * du) * target.scaleU;
					data[uidx++] = (tl0v + (v_tile_dim - j * dv)) * target.scaleV;
					uidx += skip;
					data[uidx++] = (tl1u + i * du) * target.scaleU;
					data[uidx++] = (tl1v + j * dv) * target.scaleV;
					uidx += skip;
				}
			}

			// LEFT / RIGHT
			tl0u = 0 * u_tile_step;
			tl0v = 1 * v_tile_step;
			tl1u = 2 * u_tile_step;
			tl1v = 1 * v_tile_step;
			du = u_tile_dim / _segmentsD;
			dv = v_tile_dim / _segmentsH;
			for (i = 0; i <= _segmentsD; i++)
			{
				for (j = 0; j <= _segmentsH; j++)
				{
					data[uidx++] = (tl0u + i * du) * target.scaleU;
					;
					data[uidx++] = (tl0v + (v_tile_dim - j * dv)) * target.scaleV;
					uidx += skip;
					data[uidx++] = (tl1u + (u_tile_dim - i * du)) * target.scaleU;
					data[uidx++] = (tl1v + (v_tile_dim - j * dv)) * target.scaleV;
					uidx += skip;
				}
			}

			target.setVAData(Context3DBufferTypeID.UV_VA_2, data);
		}
	}
}
