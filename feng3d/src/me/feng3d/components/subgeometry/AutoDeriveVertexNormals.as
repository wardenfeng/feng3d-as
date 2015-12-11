package me.feng3d.components.subgeometry
{
	import me.feng.component.event.ComponentEvent;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.events.GeometryComponentEvent;

	/**
	 * 自动生成顶点法线数据
	 * @author feng 2015-12-8
	 */
	public class AutoDeriveVertexNormals extends SubGeometryComponent
	{
		/** 面法线脏标记 */
		private var _faceNormalsDirty:Boolean = true;

		private var _faceNormals:Vector.<Number>;

		/** 是否使用面权重 */
		private var _useFaceWeights:Boolean = false;

		/** 面权重 */
		private var _faceWeights:Vector.<Number>;

		private var dataTypeId:String;
		private var target:Vector.<Number>;
		private var needGenerate:Boolean;

		public function AutoDeriveVertexNormals()
		{
			dataTypeId = _.normal_va_3;

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

			target = updateVertexNormals(target);
			subGeometry.setVAData(dataTypeId, target);

			needGenerate = false;
		}

		protected function onChangedVAData(event:GeometryComponentEvent):void
		{
			if (event.data == _.position_va_3)
			{
				needGenerate = true;

				//标记面法线脏数据
				_faceNormalsDirty = true;

				subGeometry.invalidVAData(dataTypeId);
			}
		}

		protected function onChangedIndexData(event:GeometryComponentEvent):void
		{
			_faceNormalsDirty = true;

			subGeometry.invalidVAData(dataTypeId);
		}

		/** 面法线 */
		public function get faceNormals():Vector.<Number>
		{
			if (_faceNormalsDirty)
				updateFaceNormals();
			return _faceNormals;
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

			subGeometry.invalidVAData(dataTypeId);

			_faceNormalsDirty = true;
		}

		/** 更新面法线数据 */
		private function updateFaceNormals():void
		{
			var i:uint, j:uint, k:uint;
			var index:uint;
			var _indices:Vector.<uint> = subGeometry.indices;
			var len:uint = _indices.length;
			var x1:Number, x2:Number, x3:Number;
			var y1:Number, y2:Number, y3:Number;
			var z1:Number, z2:Number, z3:Number;
			var dx1:Number, dy1:Number, dz1:Number;
			var dx2:Number, dy2:Number, dz2:Number;
			var cx:Number, cy:Number, cz:Number;
			var d:Number;
			var vertices:Vector.<Number> = subGeometry.getVAData(_.position_va_3);
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
			var lenV:uint = subGeometry.numVertices * 3;
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
			var _indices:Vector.<uint> = subGeometry.indices;
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
	}
}
