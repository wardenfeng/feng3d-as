package me.feng3d.utils
{


	/**
	 *
	 * @author feng 2014-12-18
	 */
	public class SubGeomUtil
	{
		/**
		 * 更新面法线数据
		 * @param _faceNormals
		 * @param vertices
		 * @param _faceWeights
		 * @param _indices
		 * @param _useFaceWeights
		 * @return
		 */
		public static function updateFaceNormals(_faceNormals:Vector.<Number>, vertices:Vector.<Number>, _indices:Vector.<uint>):Vector.<Number>
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
			var posStride:int = 3;
			var posOffset:int = 0;

			_faceNormals ||= new Vector.<Number>(len, true);

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

				d = 1 / d;
				_faceNormals[j++] = cx * d;
				_faceNormals[j++] = cy * d;
				_faceNormals[j++] = cz * d;
			}

			return _faceNormals;
		}

		/**
		 * 更新面切线数据
		 * @param _faceTangents
		 * @param vertices
		 * @param uvs
		 * @param _indices
		 * @return
		 *
		 */
		public static function updateFaceTangents(_faceTangents:Vector.<Number>, vertices:Vector.<Number>, uvs:Vector.<Number>, _indices:Vector.<uint>):Vector.<Number>
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
			var posStride:int = 3;
			var texStride:int = 2;

			_faceTangents ||= new Vector.<Number>(_indices.length, true);

			while (i < len)
			{
				index1 = _indices[i];
				index2 = _indices[i + 1];
				index3 = _indices[i + 2];

				ui = index1 * texStride + 1;
				v0 = uvs[ui];
				ui = index2 * texStride + 1;
				dv1 = uvs[ui] - v0;
				ui = index3 * texStride + 1;
				dv2 = uvs[ui] - v0;

				vi = index1 * posStride;
				x0 = vertices[vi];
				y0 = vertices[uint(vi + 1)];
				z0 = vertices[uint(vi + 2)];
				vi = index2 * posStride;
				dx1 = vertices[uint(vi)] - x0;
				dy1 = vertices[uint(vi + 1)] - y0;
				dz1 = vertices[uint(vi + 2)] - z0;
				vi = index3 * posStride;
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
			return _faceTangents;
		}

		/**
		 * 计算顶点法线数据
		 * @param target
		 * @param _faceNormals
		 * @param _faceWeights
		 * @param _indices
		 * @param numVertices
		 * @param _useFaceWeights
		 * @return
		 */
		public static function updateVertexNormals(target:Vector.<Number>, _faceNormals:Vector.<Number>, _indices:Vector.<uint>, numVertices:int):Vector.<Number>
		{
			var v1:uint;
			var f1:uint = 0, f2:uint = 1, f3:uint = 2;
			var lenV:uint = numVertices * 3;
			var normalStride:int = 3;

			target ||= new Vector.<Number>(lenV, true);
			v1 = 0;
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

			while (i < lenI)
			{
				index = _indices[i++] * normalStride;
				target[index++] += _faceNormals[f1];
				target[index++] += _faceNormals[f2];
				target[index] += _faceNormals[f3];
				index = _indices[i++] * normalStride;
				target[index++] += _faceNormals[f1];
				target[index++] += _faceNormals[f2];
				target[index] += _faceNormals[f3];
				index = _indices[i++] * normalStride;
				target[index++] += _faceNormals[f1];
				target[index++] += _faceNormals[f2];
				target[index] += _faceNormals[f3];
				f1 += 3;
				f2 += 3;
				f3 += 3;
			}

			v1 = 0;
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
		 * 计算切线数据
		 * @param target
		 * @param _faceTangents
		 * @param _faceWeights
		 * @param _indices
		 * @param numVertices
		 * @param _useFaceWeights
		 * @return
		 */
		public static function updateVertexTangents(target:Vector.<Number>, _faceTangents:Vector.<Number>, _indices:Vector.<uint>, numVertices:int):Vector.<Number>
		{
			var i:uint;
			var lenV:uint = numVertices * 3;
			var tangentStride:int = 3;

			target ||= new Vector.<Number>(lenV, true);

			i = 0;
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
			var f1:uint = 0, f2:uint = 1, f3:uint = 2;

			i = 0;

			while (i < lenI)
			{
				index = _indices[i++] * tangentStride;
				target[index++] += _faceTangents[f1];
				target[index++] += _faceTangents[f2];
				target[index] += _faceTangents[f3];
				index = _indices[i++] * tangentStride;
				target[index++] += _faceTangents[f1];
				target[index++] += _faceTangents[f2];
				target[index] += _faceTangents[f3];
				index = _indices[i++] * tangentStride;
				target[index++] += _faceTangents[f1];
				target[index++] += _faceTangents[f2];
				target[index] += _faceTangents[f3];
				f1 += 3;
				f2 += 3;
				f3 += 3;
			}

			i = 0;
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
	}
}
