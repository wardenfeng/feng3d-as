package me.feng3d.core.base.subgeometry
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.ISubGeometry;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.IndexBuffer;
	import me.feng3d.core.buffer.context3d.VABuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.errors.AbstractMethodError;

	use namespace arcane;

	public class SubGeometryBase
	{
		protected var _faceNormalsDirty:Boolean = true;
		protected var _faceTangentsDirty:Boolean = true;

		protected var _indices:Vector.<uint>;
		protected var _tvertexData:Vector.<Number>;
		protected var _faceTangents:Vector.<Number>;

		/** 索引缓冲 */
		protected var _indexBuffer:IndexBuffer;
		/** 顶点坐标数据缓冲 */
		protected var _vertexBuffer:VABuffer;

		protected var _numVertices:uint;

		private var _parentGeometry:Geometry;

		protected var _numIndices:uint;
		protected var _numTriangles:uint;

		protected var _autoDeriveVertexNormals:Boolean = true;
		protected var _autoDeriveVertexTangents:Boolean = true;

		private var _useFaceWeights:Boolean = false;
		protected var _vertexNormalsDirty:Boolean = true;
		protected var _vertexTangentsDirty:Boolean = true;

		protected var _faceNormals:Vector.<Number>;
		protected var _faceWeights:Vector.<Number>;

		public function SubGeometryBase()
		{
			initBuffers();
		}

		public function get tvertexData():Vector.<Number>
		{
			return _tvertexData;
		}

		public function set tvertexData(value:Vector.<Number>):void
		{
			_tvertexData = value;
		}

		protected function initBuffers():void
		{
			_indexBuffer = new IndexBuffer(Context3DBufferTypeID.index, updateIndexBuffer);
			_vertexBuffer = new VABuffer(Context3DBufferTypeID.POSITION_VA_3, updateVertexBuffer);
		}

		public function collectCache(context3dCache:Context3DCache):void
		{
			context3dCache.addDataBuffer(_indexBuffer);
			context3dCache.addDataBuffer(_vertexBuffer);
		}

		public function releaseCache(context3dCache:Context3DCache):void
		{
			context3dCache.removeDataBuffer(_indexBuffer);
			context3dCache.removeDataBuffer(_vertexBuffer);
		}

		protected function updateIndexBuffer():void
		{
			_indexBuffer.update(indices, numIndices, numIndices);
		}

		protected function updateVertexBuffer():void
		{
			_vertexBuffer.update(vertexData, numVertices, vertexStride, 0, Context3DVertexBufferFormat.FLOAT_3);
		}

		/**
		 * 顶点个数
		 */
		public function get numVertices():uint
		{
			return _numVertices;
		}

		/**
		 * 可绘制三角形的个数
		 */
		public function get numTriangles():uint
		{
			return _numTriangles;
		}

		public function dispose():void
		{
			_indices = null;
			tvertexData = null;
		}

		/**
		 * 顶点索引数据
		 */
		public function get indexData():Vector.<uint>
		{
			return _indices;
		}

		protected function invalidateBounds():void
		{
			if (_parentGeometry)
				_parentGeometry.invalidateBounds(ISubGeometry(this));
		}

		public function get parentGeometry():Geometry
		{
			return _parentGeometry;
		}

		public function set parentGeometry(value:Geometry):void
		{
			_parentGeometry = value;
		}

		/**
		 * 索引数量
		 */		
		public function get numIndices():uint
		{
			return _numIndices;
		}

		/**
		 * 索引数据
		 */		
		public function get indices():Vector.<uint>
		{
			return _indices;
		}

		/**
		 * 顶点法线步长
		 */		
		public function get vertexNormalStride():uint
		{
			throw new AbstractMethodError();
		}

		/**
		 * 顶点法线偏移值
		 */		
		public function get vertexNormalOffset():int
		{
			throw new AbstractMethodError();
		}

		/**
		 * 顶点切线步长
		 */		
		public function get vertexTangentStride():uint
		{
			throw new AbstractMethodError();
		}

		/**
		 * 顶点切线偏移值
		 */		
		public function get vertexTangentOffset():int
		{
			throw new AbstractMethodError();
		}

		/**
		 * uv步长
		 */		
		public function get UVStride():uint
		{
			throw new AbstractMethodError();
		}
		
		/**
		 * uv偏移值
		 */
		public function get UVOffset():int
		{
			throw new AbstractMethodError();
		}
		
		/**
		 * 顶点法线数据
		 */		
		public function get vertexNormalData():Vector.<Number>
		{
			throw new AbstractMethodError();
		}

		/**
		 * uv数据
		 */		
		public function get UVData():Vector.<Number>
		{
			throw new AbstractMethodError();
		}

		/**
		 * 顶点切线数据
		 */		
		public function get vertexTangentData():Vector.<Number>
		{
			throw new AbstractMethodError();
		}

		/**
		 * 顶点数据
		 */		
		public function get vertexData():Vector.<Number>
		{
			return tvertexData;
		}
		
		/**
		 * 顶点位置数据
		 */		
		public function get vertexPositionData():Vector.<Number>
		{
			return tvertexData;
		}
		
		/**
		 * 顶点数据步长
		 */		
		public function get vertexStride():uint
		{
			return 3;
		}
		
		/**
		 * 顶点数据偏移
		 */		
		public function get vertexOffset():int
		{
			return 0;
		}
		
		/**
		 * 更新顶点索引数据
		 */
		public function updateIndexData(indices:Vector.<uint>):void
		{
			_indices = indices;
			_numIndices = indices.length;
			
			var numTriangles:int = _numIndices / 3;
			_numTriangles = numTriangles;
			
			_indexBuffer.invalid();
		}
		
		/**
		 * 更新顶点数据
		 */
		public function updateVertexData(vertices:Vector.<Number>):void
		{
			tvertexData = vertices;
			var numVertices:int = vertices.length / vertexStride;
			if (numVertices != _numVertices)
				disposeAllVertexBuffers();
			_numVertices = numVertices;
			
			_vertexBuffer.invalid();
			
			invalidateBounds();
		}
		
		/**
		 * 更新面法线数据
		 */
		private function updateFaceNormals():void
		{
			var i:uint, j:uint, k:uint;
			var index:uint;
			var len:uint = _indices.length;
			var x1:Number, x2:Number, x3:Number;
			var y1:Number, y2:Number, y3:Number;
			var z1:Number, z2:Number, z3:Number;
			var dx1:Number, dy1:Number, dz1:Number;
			var dx2:Number, dy2:Number, dz2:Number;
			var cx:Number, cy:Number, cz:Number;
			var d:Number;
			var vertices:Vector.<Number> = tvertexData;
			var posStride:int = vertexStride;
			var posOffset:int = vertexOffset;

			_faceNormals ||= new Vector.<Number>(len, true);
			if (_useFaceWeights)
				_faceWeights ||= new Vector.<Number>(len / 3, true);

			while (i < len)
			{
				index = posOffset + _indices[i++] * posStride;
				x1 = vertices[index];
				y1 = vertices[index + 1];
				z1 = vertices[index + 2];
				index = posOffset + _indices[i++] * posStride;
				x2 = vertices[index];
				y2 = vertices[index + 1];
				z2 = vertices[index + 2];
				index = posOffset + _indices[i++] * posStride;
				x3 = vertices[index];
				y3 = vertices[index + 1];
				z3 = vertices[index + 2];
				dx1 = x3 - x1;
				dy1 = y3 - y1;
				dz1 = z3 - z1;
				dx2 = x2 - x1;
				dy2 = y2 - y1;
				dz2 = z2 - z1;
				cx = dz1 * dy2 - dy1 * dz2;
				cy = dx1 * dz2 - dz1 * dx2;
				cz = dy1 * dx2 - dx1 * dy2;
				d = Math.sqrt(cx * cx + cy * cy + cz * cz);
				// length of cross product = 2*triangle area
				if (_useFaceWeights)
				{
					var w:Number = d * 10000;
					if (w < 1)
						w = 1;
					_faceWeights[k++] = w;
				}
				d = 1 / d;
				_faceNormals[j++] = cx * d;
				_faceNormals[j++] = cy * d;
				_faceNormals[j++] = cz * d;
			}

			_faceNormalsDirty = false;
		}

		/**
		 * 更新面切线数据
		 */
		protected function updateFaceTangents():void
		{
			var i:uint;
			var index1:uint, index2:uint, index3:uint;
			var len:uint = _indices.length;
			var ui:uint, vi:uint;
			var v0:Number;
			var dv1:Number, dv2:Number;
			var denom:Number;
			var x0:Number, y0:Number, z0:Number;
			var dx1:Number, dy1:Number, dz1:Number;
			var dx2:Number, dy2:Number, dz2:Number;
			var cx:Number, cy:Number, cz:Number;
			var vertices:Vector.<Number> = tvertexData;
			var uvs:Vector.<Number> = UVData;
			var posStride:int = vertexStride;
			var posOffset:int = vertexOffset;
			var texStride:int = UVStride;
			var texOffset:int = UVOffset;

			_faceTangents ||= new Vector.<Number>(_indices.length, true);

			while (i < len)
			{
				index1 = _indices[i];
				index2 = _indices[i + 1];
				index3 = _indices[i + 2];

				ui = texOffset + index1 * texStride + 1;
				v0 = uvs[ui];
				ui = texOffset + index2 * texStride + 1;
				dv1 = uvs[ui] - v0;
				ui = texOffset + index3 * texStride + 1;
				dv2 = uvs[ui] - v0;

				vi = posOffset + index1 * posStride;
				x0 = vertices[vi];
				y0 = vertices[uint(vi + 1)];
				z0 = vertices[uint(vi + 2)];
				vi = posOffset + index2 * posStride;
				dx1 = vertices[uint(vi)] - x0;
				dy1 = vertices[uint(vi + 1)] - y0;
				dz1 = vertices[uint(vi + 2)] - z0;
				vi = posOffset + index3 * posStride;
				dx2 = vertices[uint(vi)] - x0;
				dy2 = vertices[uint(vi + 1)] - y0;
				dz2 = vertices[uint(vi + 2)] - z0;

				cx = dv2 * dx1 - dv1 * dx2;
				cy = dv2 * dy1 - dv1 * dy2;
				cz = dv2 * dz1 - dv1 * dz2;
				denom = 1 / Math.sqrt(cx * cx + cy * cy + cz * cz);
				_faceTangents[i++] = denom * cx;
				_faceTangents[i++] = denom * cy;
				_faceTangents[i++] = denom * cz;
			}

			_faceTangentsDirty = false;
		}

		/**
		 * 更新顶点法线数据
		 */
		protected function updateVertexNormals(target:Vector.<Number>):Vector.<Number>
		{
			if (_faceNormalsDirty)
				updateFaceNormals();

			var v1:uint;
			var f1:uint = 0, f2:uint = 1, f3:uint = 2;
			var lenV:uint = tvertexData.length;
			var normalStride:int = vertexNormalStride;
			var normalOffset:int = vertexNormalOffset;

			target ||= new Vector.<Number>(lenV, true);
			v1 = normalOffset;
			while (v1 < lenV)
			{
				target[v1] = 0.0;
				target[v1 + 1] = 0.0;
				target[v1 + 2] = 0.0;
				v1 += normalStride;
			}

			var i:uint, k:uint;
			var lenI:uint = _indices.length;
			var index:uint;
			var weight:Number;

			while (i < lenI)
			{
				weight = _useFaceWeights ? _faceWeights[k++] : 1;
				index = normalOffset + _indices[i++] * normalStride;
				target[index++] += _faceNormals[f1] * weight;
				target[index++] += _faceNormals[f2] * weight;
				target[index] += _faceNormals[f3] * weight;
				index = normalOffset + _indices[i++] * normalStride;
				target[index++] += _faceNormals[f1] * weight;
				target[index++] += _faceNormals[f2] * weight;
				target[index] += _faceNormals[f3] * weight;
				index = normalOffset + _indices[i++] * normalStride;
				target[index++] += _faceNormals[f1] * weight;
				target[index++] += _faceNormals[f2] * weight;
				target[index] += _faceNormals[f3] * weight;
				f1 += 3;
				f2 += 3;
				f3 += 3;
			}

			v1 = normalOffset;
			while (v1 < lenV)
			{
				var vx:Number = target[v1];
				var vy:Number = target[v1 + 1];
				var vz:Number = target[v1 + 2];
				var d:Number = 1.0 / Math.sqrt(vx * vx + vy * vy + vz * vz);
				target[v1] = vx * d;
				target[v1 + 1] = vy * d;
				target[v1 + 2] = vz * d;
				v1 += normalStride;
			}

			_vertexNormalsDirty = false;

			return target;
		}

		/**
		 * 更新顶点切线数据
		 */
		protected function updateVertexTangents(target:Vector.<Number>):Vector.<Number>
		{
			if (_faceTangentsDirty)
				updateFaceTangents();

			var i:uint;
			var lenV:uint = tvertexData.length;
			var tangentStride:int = vertexTangentStride;
			var tangentOffset:int = vertexTangentOffset;

			target ||= new Vector.<Number>(lenV, true);

			i = tangentOffset;
			while (i < lenV)
			{
				target[i] = 0.0;
				target[i + 1] = 0.0;
				target[i + 2] = 0.0;
				i += tangentStride;
			}

			var k:uint;
			var lenI:uint = _indices.length;
			var index:uint;
			var weight:Number;
			var f1:uint = 0, f2:uint = 1, f3:uint = 2;

			i = 0;

			while (i < lenI)
			{
				weight = _useFaceWeights ? _faceWeights[k++] : 1;
				index = tangentOffset + _indices[i++] * tangentStride;
				target[index++] += _faceTangents[f1] * weight;
				target[index++] += _faceTangents[f2] * weight;
				target[index] += _faceTangents[f3] * weight;
				index = tangentOffset + _indices[i++] * tangentStride;
				target[index++] += _faceTangents[f1] * weight;
				target[index++] += _faceTangents[f2] * weight;
				target[index] += _faceTangents[f3] * weight;
				index = tangentOffset + _indices[i++] * tangentStride;
				target[index++] += _faceTangents[f1] * weight;
				target[index++] += _faceTangents[f2] * weight;
				target[index] += _faceTangents[f3] * weight;
				f1 += 3;
				f2 += 3;
				f3 += 3;
			}

			i = tangentOffset;
			while (i < lenV)
			{
				var vx:Number = target[i];
				var vy:Number = target[i + 1];
				var vz:Number = target[i + 2];
				var d:Number = 1.0 / Math.sqrt(vx * vx + vy * vy + vz * vz);
				target[i] = vx * d;
				target[i + 1] = vy * d;
				target[i + 2] = vz * d;
				i += tangentStride;
			}

			_vertexTangentsDirty = false;

			return target;
		}

		/**
		 * 缩放网格尺寸
		 */		
		public function scale(scale:Number):void
		{
			var vertices:Vector.<Number> = tvertexData;
			var len:uint = vertices.length;
			var offset:int = vertexOffset;
			var stride:int = vertexStride;
			
			for (var i:uint = offset; i < len; i += stride)
			{
				vertices[i] *= scale;
				vertices[i + 1] *= scale;
				vertices[i + 2] *= scale;
			}
			_vertexBuffer.invalid();
		}
		
		/**
		 * 应用转换矩阵
		 * @param transform 转换矩阵
		 */		
		public function applyTransformation(transform:Matrix3D):void
		{
			var vertices:Vector.<Number> = tvertexData;
			var normals:Vector.<Number> = vertexNormalData;
			var tangents:Vector.<Number> = vertexTangentData;
			var posStride:int = vertexStride;
			var normalStride:int = vertexNormalStride;
			var tangentStride:int = vertexTangentStride;
			var posOffset:int = vertexOffset;
			var normalOffset:int = vertexNormalOffset;
			var tangentOffset:int = vertexTangentOffset;
			var len:uint = vertices.length / posStride;
			var i:uint, i1:uint, i2:uint;
			var vector:Vector3D = new Vector3D();
			
			var bakeNormals:Boolean = normals != null;
			var bakeTangents:Boolean = tangents != null;
			var invTranspose:Matrix3D;
			
			if (bakeNormals || bakeTangents)
			{
				invTranspose = transform.clone();
				invTranspose.invert();
				invTranspose.transpose();
			}
			
			var vi0:int = posOffset;
			var ni0:int = normalOffset;
			var ti0:int = tangentOffset;
			
			for (i = 0; i < len; ++i)
			{
				i1 = vi0 + 1;
				i2 = vi0 + 2;
				
				// bake position
				vector.x = vertices[vi0];
				vector.y = vertices[i1];
				vector.z = vertices[i2];
				vector = transform.transformVector(vector);
				vertices[vi0] = vector.x;
				vertices[i1] = vector.y;
				vertices[i2] = vector.z;
				vi0 += posStride;
				
				// bake normal
				if (bakeNormals)
				{
					i1 = ni0 + 1;
					i2 = ni0 + 2;
					vector.x = normals[ni0];
					vector.y = normals[i1];
					vector.z = normals[i2];
					vector = invTranspose.deltaTransformVector(vector);
					vector.normalize();
					normals[ni0] = vector.x;
					normals[i1] = vector.y;
					normals[i2] = vector.z;
					ni0 += normalStride;
				}
				
				// bake tangent
				if (bakeTangents)
				{
					i1 = ti0 + 1;
					i2 = ti0 + 2;
					vector.x = tangents[ti0];
					vector.y = tangents[i1];
					vector.z = tangents[i2];
					vector = invTranspose.deltaTransformVector(vector);
					vector.normalize();
					tangents[ti0] = vector.x;
					tangents[i1] = vector.y;
					tangents[i2] = vector.z;
					ti0 += tangentStride;
				}
			}
			
			_vertexBuffer.invalid();
		}
		
		protected function disposeAllVertexBuffers():void
		{
			_vertexBuffer.invalid();
		}
	}
}
