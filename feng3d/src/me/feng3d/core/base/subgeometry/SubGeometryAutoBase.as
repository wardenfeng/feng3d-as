package me.feng3d.core.base.subgeometry
{

	/**
	 * 子网格基类（分担SubGeometry负担，处理自动生成法线、切线、uv等计算）
	 * @author feng 2014-12-19
	 */
	public class SubGeometryAutoBase extends SubGeometryBase
	{
		/** 面法线脏标记 */
		private var _faceNormalsDirty:Boolean = true;
		/** 面切线脏标记 */
		private var _faceTangentsDirty:Boolean = true;

		/** 是否自动生成顶点法线数据 */
		private var _autoDeriveVertexNormals:Boolean = true;
		/** 是否自动生成顶点切线数据 */
		private var _autoDeriveVertexTangents:Boolean = true;
		/** 是否使用面权重 */
		private var _useFaceWeights:Boolean = false;

		private var _faceNormals:Vector.<Number>;
		private var _faceTangents:Vector.<Number>;
		/** 面权重 */
		private var _faceWeights:Vector.<Number>;

		public function SubGeometryAutoBase()
		{
			super();
		}

		/** 面切线 */
		public function get faceTangents():Vector.<Number>
		{
			if (_faceTangentsDirty)
				updateFaceTangents();
			return _faceTangents;
		}

		/** 面法线 */
		public function get faceNormals():Vector.<Number>
		{
			if (_faceNormalsDirty)
				updateFaceNormals();
			return _faceNormals;
		}

		/**
		 * True if the vertex normals should be derived from the geometry, false if the vertex normals are set
		 * explicitly.
		 */
		public function get autoDeriveVertexNormals():Boolean
		{
			return _autoDeriveVertexNormals;
		}

		public function set autoDeriveVertexNormals(value:Boolean):void
		{
			_autoDeriveVertexNormals = value;

			invalidVAData(_.normal_va_3);
		}

		/**
		 * True if the vertex tangents should be derived from the geometry, false if the vertex normals are set
		 * explicitly.
		 */
		public function get autoDeriveVertexTangents():Boolean
		{
			return _autoDeriveVertexTangents;
		}

		public function set autoDeriveVertexTangents(value:Boolean):void
		{
			_autoDeriveVertexTangents = value;

			invalidVAData(_.tangent_va_3);
		}

		/**
		 * Indicates whether or not to take the size of faces into account when auto-deriving vertex normals and tangents.
		 */
		public function get useFaceWeights():Boolean
		{
			return _useFaceWeights;
		}

		public function set useFaceWeights(value:Boolean):void
		{
			_useFaceWeights = value;

			//标记法线数据失效
			if (_autoDeriveVertexNormals)
				invalidVAData(_.normal_va_3);
			//标记切线数据失效
			if (_autoDeriveVertexTangents)
				invalidVAData(_.tangent_va_3);

			_faceNormalsDirty = true;
		}

		/** 更新面切线数据 */
		private function updateFaceTangents():void
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
			var vertices:Vector.<Number> = getVAData(_.position_va_3);
			var uvs:Vector.<Number> = getVAData(_.uv_va_2);
			var posStride:int = getVALen(_.position_va_3);
			var posOffset:int = 0;
			var texStride:int = getVALen(_.uv_va_2);
			var texOffset:int = 0;

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

		/** 更新面法线数据 */
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
			var vertices:Vector.<Number> = getVAData(_.position_va_3);
			var posStride:int = 3;
			var posOffset:int = 0;

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
		 * 更新顶点法线数据
		 * @param target 顶点法线数据
		 * @return 顶点法线数据
		 */
		private function updateVertexNormals(target:Vector.<Number>):Vector.<Number>
		{
			if (_faceNormalsDirty)
				updateFaceNormals();

			var v1:uint;
			var f1:uint = 0, f2:uint = 1, f3:uint = 2;
			var lenV:uint = numVertices * 3;
			var normalStride:int = 3;
			var normalOffset:int = 0;

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

			return target;
		}

		/**
		 * 更新顶点切线数据
		 * @param target 顶点切线数据
		 * @return 顶点切线数据
		 */
		protected function updateVertexTangents(target:Vector.<Number>):Vector.<Number>
		{
			if (_faceTangentsDirty)
				updateFaceTangents();

			var i:uint;
			var lenV:uint = numVertices * 3;
			var tangentStride:int = 3;
			var tangentOffset:int = 0;

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

			return target;
		}

		override protected function updateVAdata(dataTypeId:String):void
		{
			super.updateVAdata(dataTypeId);

			var target:Vector.<Number> = getVAData(dataTypeId, false);
			switch (dataTypeId)
			{
				case _.normal_va_3:
					if (_autoDeriveVertexNormals)
					{
						target = updateVertexNormals(target);
						setVAData(dataTypeId, target);
					}
					break;
				case _.tangent_va_3:
					if (_autoDeriveVertexTangents)
					{
						target = updateVertexTangents(target);
						setVAData(dataTypeId, target);
					}
					break;
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function notifyVADataChanged(dataTypeId:String):void
		{
			super.notifyVADataChanged(dataTypeId);

			switch (dataTypeId)
			{
				case _.position_va_3:
					//标记面法线脏数据
					_faceNormalsDirty = true;
					//标记面切线脏数据
					_faceTangentsDirty = true;

					//标记法线数据失效
					if (_autoDeriveVertexNormals)
						invalidVAData(_.normal_va_3);
					//标记切线数据失效
					if (_autoDeriveVertexTangents)
						invalidVAData(_.tangent_va_3);
					break;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function updateIndexData(indices:Vector.<uint>):void
		{
			super.updateIndexData(indices);

			_faceNormalsDirty = true;

			//标记法线数据失效
			if (_autoDeriveVertexNormals)
				invalidVAData(_.normal_va_3);
			//标记切线数据失效
			if (_autoDeriveVertexTangents)
				invalidVAData(_.tangent_va_3);
		}
	}
}
