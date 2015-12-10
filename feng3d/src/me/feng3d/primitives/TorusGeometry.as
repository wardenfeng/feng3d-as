package me.feng3d.primitives
{
	import me.feng3d.arcane;
	import me.feng3d.core.base.subgeometry.SubGeometry;

	use namespace arcane;

	/**
	 * 圆环几何体
	 */
	public class TorusGeometry extends PrimitiveBase
	{
		protected var _radius:Number;
		protected var _tubeRadius:Number;
		protected var _segmentsR:uint;
		protected var _segmentsT:uint;
		protected var _yUp:Boolean;
		protected var vertexPositionData:Vector.<Number>;
		protected var vertexNormalData:Vector.<Number>;
		protected var vertexTangentData:Vector.<Number>;
		private var _rawIndices:Vector.<uint>;
		private var _vertexIndex:uint;
		private var _currentTriangleIndex:uint;
		private var _numVertices:uint;
		private var vertexPositionStride:uint;
		private var vertexNormalStride:uint;
		private var vertexTangentStride:uint;

		/**
		 * 添加顶点数据
		 */
		private function addVertex(vertexIndex:uint, px:Number, py:Number, pz:Number, nx:Number, ny:Number, nz:Number, tx:Number, ty:Number, tz:Number):void
		{
			vertexPositionData[vertexIndex * vertexPositionStride] = px;
			vertexPositionData[vertexIndex * vertexPositionStride + 1] = py;
			vertexPositionData[vertexIndex * vertexPositionStride + 2] = pz;
			vertexNormalData[vertexIndex * vertexNormalStride] = nx;
			vertexNormalData[vertexIndex * vertexNormalStride + 1] = ny;
			vertexNormalData[vertexIndex * vertexNormalStride + 2] = nz;
			vertexTangentData[vertexIndex * vertexTangentStride] = tx;
			vertexTangentData[vertexIndex * vertexTangentStride + 1] = ty;
			vertexTangentData[vertexIndex * vertexTangentStride + 2] = tz;
		}

		/**
		 * 添加三角形索引数据
		 * @param currentTriangleIndex		当前三角形索引
		 * @param cwVertexIndex0			索引0
		 * @param cwVertexIndex1			索引1
		 * @param cwVertexIndex2			索引2
		 */
		private function addTriangleClockWise(currentTriangleIndex:uint, cwVertexIndex0:uint, cwVertexIndex1:uint, cwVertexIndex2:uint):void
		{
			_rawIndices[currentTriangleIndex * 3] = cwVertexIndex0;
			_rawIndices[currentTriangleIndex * 3 + 1] = cwVertexIndex1;
			_rawIndices[currentTriangleIndex * 3 + 2] = cwVertexIndex2;
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildGeometry(target:SubGeometry):void
		{
			var i:uint, j:uint;
			var x:Number, y:Number, z:Number, nx:Number, ny:Number, nz:Number, revolutionAngleR:Number, revolutionAngleT:Number;
			var numTriangles:uint;
			// reset utility variables
			_numVertices = 0;
			_vertexIndex = 0;
			_currentTriangleIndex = 0;
			vertexPositionStride = target.vertexPositionStride;
			vertexNormalStride = target.vertexNormalStride;
			vertexTangentStride = target.vertexTangentStride;

			// evaluate target number of vertices, triangles and indices
			_numVertices = (_segmentsT + 1) * (_segmentsR + 1); // segmentsT + 1 because of closure, segmentsR + 1 because of closure
			numTriangles = _segmentsT * _segmentsR * 2; // each level has segmentR quads, each of 2 triangles

			// need to initialize raw arrays or can be reused?
			if (_numVertices == target.numVertices)
			{
				vertexPositionData = target.vertexPositionData;
				vertexNormalData = target.vertexNormalData;
				vertexTangentData = target.vertexTangentData;
				_rawIndices = target.indexData || new Vector.<uint>(numTriangles * 3, true);
			}
			else
			{
				vertexPositionData = new Vector.<Number>(_numVertices * vertexPositionStride, true);
				vertexNormalData = new Vector.<Number>(_numVertices * vertexNormalStride, true);
				vertexTangentData = new Vector.<Number>(_numVertices * vertexTangentStride, true);
				_rawIndices = new Vector.<uint>(numTriangles * 3, true);
				invalidateUVs();
			}

			// evaluate revolution steps
			var revolutionAngleDeltaR:Number = 2 * Math.PI / _segmentsR;
			var revolutionAngleDeltaT:Number = 2 * Math.PI / _segmentsT;

			var comp1:Number, comp2:Number;
			var t1:Number, t2:Number, n1:Number, n2:Number;

			var startPositionIndex:uint;

			// surface
			var a:uint, b:uint, c:uint, d:uint, length:Number;

			for (j = 0; j <= _segmentsT; ++j)
			{
				startPositionIndex = j * (_segmentsR + 1) * vertexPositionStride;

				for (i = 0; i <= _segmentsR; ++i)
				{
					_vertexIndex = j * (_segmentsR + 1) + i;

					// revolution vertex
					revolutionAngleR = i * revolutionAngleDeltaR;
					revolutionAngleT = j * revolutionAngleDeltaT;

					length = Math.cos(revolutionAngleT);
					nx = length * Math.cos(revolutionAngleR);
					ny = length * Math.sin(revolutionAngleR);
					nz = Math.sin(revolutionAngleT);

					x = _radius * Math.cos(revolutionAngleR) + _tubeRadius * nx;
					y = _radius * Math.sin(revolutionAngleR) + _tubeRadius * ny;
					z = (j == _segmentsT) ? 0 : _tubeRadius * nz;

					if (_yUp)
					{
						n1 = -nz;
						n2 = ny;
						t1 = 0;
						t2 = (length ? nx / length : x / _radius);
						comp1 = -z;
						comp2 = y;

					}
					else
					{
						n1 = ny;
						n2 = nz;
						t1 = (length ? nx / length : x / _radius);
						t2 = 0;
						comp1 = y;
						comp2 = z;
					}

					if (i == _segmentsR)
					{
						addVertex(_vertexIndex, x, vertexPositionData[startPositionIndex + 1], vertexPositionData[startPositionIndex + 2], nx, n1, n2, -(length ? ny / length : y / _radius), t1, t2);
					}
					else
					{
						addVertex(_vertexIndex, x, comp1, comp2, nx, n1, n2, -(length ? ny / length : y / _radius), t1, t2);
					}

					// close triangle
					if (i > 0 && j > 0)
					{
						a = _vertexIndex; // current
						b = _vertexIndex - 1; // previous
						c = b - _segmentsR - 1; // previous of last level
						d = a - _segmentsR - 1; // current of last level
						addTriangleClockWise(_currentTriangleIndex++, a, b, c);
						addTriangleClockWise(_currentTriangleIndex++, a, c, d);
					}
				}
			}

			target.numVertices = _numVertices;
			target.updateVertexPositionData(vertexPositionData);
			target.updateVertexNormalData(vertexNormalData);
			target.updateVertexTangentData(vertexTangentData);
			target.updateIndexData(_rawIndices);
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildUVs(target:SubGeometry):void
		{
			var i:int, j:int;
			var data:Vector.<Number>;
			var stride:int = target.UVStride;

			// evaluate num uvs
			var numUvs:uint = _numVertices * stride;

			// need to initialize raw array or can be reused?
			data = target.UVData;
			if (data == null || numUvs != data.length)
			{
				data = new Vector.<Number>(numUvs, true);
			}

			// current uv component index
			var currentUvCompIndex:uint = 0;

			var index:int = 0;
			// surface
			for (j = 0; j <= _segmentsT; ++j)
			{
				for (i = 0; i <= _segmentsR; ++i)
				{
					index = j * (_segmentsR + 1) + i;
					// revolution vertex
					data[index * stride] = i / _segmentsR;
					data[index * stride + 1] = j / _segmentsT;
				}
			}

			// build real data from raw data
			target.updateUVData(data);
		}

		/**
		 * 圆环半径
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
		 * 管子半径
		 */
		public function get tubeRadius():Number
		{
			return _tubeRadius;
		}

		public function set tubeRadius(value:Number):void
		{
			_tubeRadius = value;
			invalidateGeometry();
		}

		/**
		 * 横向段数
		 */
		public function get segmentsR():uint
		{
			return _segmentsR;
		}

		public function set segmentsR(value:uint):void
		{
			_segmentsR = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * 纵向段数
		 */
		public function get segmentsT():uint
		{
			return _segmentsT;
		}

		public function set segmentsT(value:uint):void
		{
			_segmentsT = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * Y轴是否朝上
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
		 * 创建<code>Torus</code>实例
		 * @param radius						圆环半径
		 * @param tuebRadius					管道半径
		 * @param segmentsR						横向段数
		 * @param segmentsT						纵向段数
		 * @param yUp							Y轴是否朝上
		 */
		public function TorusGeometry(radius:Number = 50, tubeRadius:Number = 50, segmentsR:uint = 16, segmentsT:uint = 8, yUp:Boolean = true)
		{
			super();

			_radius = radius;
			_tubeRadius = tubeRadius;
			_segmentsR = segmentsR;
			_segmentsT = segmentsT;
			_yUp = yUp;
		}
	}
}
