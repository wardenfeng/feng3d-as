package me.feng3d.components.subgeometry
{
	import me.feng.component.event.ComponentEvent;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.events.GeometryComponentEvent;

	/**
	 * 自动生成切线组件
	 * @author feng 2014-12-19
	 */
	public class AutoDeriveVertexTangents extends SubGeometryComponent
	{
		/** 面切线脏标记 */
		private var _faceTangentsDirty:Boolean = true;

		/** 是否使用面权重 */
		private var _useFaceWeights:Boolean = false;

		private var _faceTangents:Vector.<Number>;
		/** 面权重 */
		private var _faceWeights:Vector.<Number>;

		private var dataTypeId:String;
		private var target:Vector.<Number>;
		private var needGenerate:Boolean;

		public function AutoDeriveVertexTangents()
		{
			dataTypeId = _.tangent_va_3;

			super();
		}

		override protected function set subGeometry(value:SubGeometry):void
		{
			if (_subGeometry != null)
			{
				_subGeometry.removeEventListener(GeometryComponentEvent.GET_VA_DATA, onGetVAData);
				_subGeometry.removeEventListener(GeometryComponentEvent.CHANGED_VA_DATA, onChangedVAData);
				_subGeometry.removeEventListener(GeometryComponentEvent.CHANGED_INDEX_DATA, onChangedIndexData);
			}
			_subGeometry = value;
			if (_subGeometry != null)
			{
				_subGeometry.addEventListener(GeometryComponentEvent.GET_VA_DATA, onGetVAData);
				_subGeometry.addEventListener(GeometryComponentEvent.CHANGED_VA_DATA, onChangedVAData);
				_subGeometry.addEventListener(GeometryComponentEvent.CHANGED_INDEX_DATA, onChangedIndexData);
			}
		}

		/**
		 * 处理被添加事件
		 * @param event
		 */
		override protected function onBeAddedComponet(event:ComponentEvent):void
		{
			super.onBeAddedComponet(event);

			needGenerate = true;
			subGeometry.invalidVAData(dataTypeId);
		}

		protected function onGetVAData(event:GeometryComponentEvent):void
		{
			if (event.data != dataTypeId)
				return;
			if (!needGenerate)
				return;

			target = updateVertexTangents(target);
			subGeometry.setVAData(dataTypeId, target);

			needGenerate = false;
		}

		protected function onChangedVAData(event:GeometryComponentEvent):void
		{
			if (event.data == _.position_va_3)
			{
				needGenerate = true;

				//标记面切线脏数据
				_faceTangentsDirty = true;

				subGeometry.invalidVAData(_.tangent_va_3);
			}
		}

		protected function onChangedIndexData(event:GeometryComponentEvent):void
		{
			_faceTangentsDirty = true;

			subGeometry.invalidVAData(_.tangent_va_3);
		}

		/** 面切线 */
		public function get faceTangents():Vector.<Number>
		{
			if (_faceTangentsDirty)
				updateFaceTangents();
			return _faceTangents;
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

			subGeometry.invalidVAData(_.tangent_va_3);
		}

		/** 更新面切线数据 */
		private function updateFaceTangents():void
		{
			var i:uint;
			var index1:uint, index2:uint, index3:uint;
			var _indices:Vector.<uint> = subGeometry.indices;
			var len:uint = _indices.length;
			var ui:uint, vi:uint;
			var v0:Number;
			var dv1:Number, dv2:Number;
			var denom:Number;
			var x0:Number, y0:Number, z0:Number;
			var dx1:Number, dy1:Number, dz1:Number;
			var dx2:Number, dy2:Number, dz2:Number;
			var cx:Number, cy:Number, cz:Number;
			var vertices:Vector.<Number> = subGeometry.getVAData(_.position_va_3);
			var uvs:Vector.<Number> = subGeometry.getVAData(_.uv_va_2);
			var posStride:int = subGeometry.getVALen(_.position_va_3);
			var posOffset:int = 0;
			var texStride:int = subGeometry.getVALen(_.uv_va_2);
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
			var lenV:uint = subGeometry.numVertices * 3;
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
			var _indices:Vector.<uint> = subGeometry.indices;
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
	}
}
