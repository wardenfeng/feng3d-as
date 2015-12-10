package me.feng3d.core.base.subgeometry
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import me.feng.debug.assert;
	import me.feng3d.arcane;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.events.GeometryComponentEvent;
	import me.feng3d.events.GeometryEvent;

	use namespace arcane;

	/**
	 * 获取几何体顶点数据时触发
	 */
	[Event(name = "getVAData", type = "me.feng3d.events.GeometryComponentEvent")]

	/**
	 * 改变几何体顶点数据后触发
	 */
	[Event(name = "changedVAData", type = "me.feng3d.events.GeometryComponentEvent")]

	/**
	 * 改变顶点索引数据后触发
	 */
	[Event(name = "changedIndexData", type = "me.feng3d.events.GeometryComponentEvent")]

	/**
	 * 子几何体
	 */
	public class SubGeometry extends SubGeometryBase
	{
		private var _parent:Geometry;

		/**
		 * 创建一个新几何体
		 */
		public function SubGeometry()
		{
			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			mapVABuffer(_.uv_va_2, 2);
			mapVABuffer(_.normal_va_3, 3);
			mapVABuffer(_.tangent_va_3, 3);
		}

		public function fromVectors(vertices:Vector.<Number>, uvs:Vector.<Number>):void
		{
			updateVertexPositionData(vertices);

			updateUVData(uvs);
		}

		/**
		 * 应用变换矩阵
		 * @param transform 变换矩阵
		 */
		public function applyTransformation(transform:Matrix3D):void
		{
			var vertices:Vector.<Number> = vertexPositionData;
			var normals:Vector.<Number> = vertexNormalData;
			var tangents:Vector.<Number> = vertexTangentData;

			var posStride:int = vertexPositionStride;
			var normalStride:int = vertexNormalStride;
			var tangentStride:int = vertexTangentStride;

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

			var vi0:int = 0;
			var ni0:int = 0;
			var ti0:int = 0;

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

			markBufferDirty(_.position_va_3);
			markBufferDirty(_.normal_va_3);
			markBufferDirty(_.tangent_va_3);
		}

		/**
		 * 更新uv数据
		 * @param data	uv数据
		 */
		public function updateUVData(data:Vector.<Number>):void
		{
			setVAData(_.uv_va_2, data);
		}

		/**
		 * 更新顶点数据
		 */
		public function updateVertexPositionData(data:Vector.<Number>):void
		{
			setVAData(_.position_va_3, data);

			dispatchEvent(new GeometryEvent(GeometryEvent.SHAPE_CHANGE, this, true));
		}

		/**
		 * 更新顶点法线数据
		 * @param vertexNormals 顶点法线数据
		 */
		public function updateVertexNormalData(vertexNormals:Vector.<Number>):void
		{
			setVAData(_.normal_va_3, vertexNormals);
		}

		/**
		 * 更新顶点切线数据
		 * @param vertexTangents 顶点切线数据
		 */
		public function updateVertexTangentData(vertexTangents:Vector.<Number>):void
		{
			setVAData(_.tangent_va_3, vertexTangents);
		}

		/**
		 * 缩放网格尺寸
		 */
		public function scale(scale:Number):void
		{
			var vertices:Vector.<Number> = getVAData(_.position_va_3);
			var len:uint = vertices.length;
			var stride:int = getVALen(_.position_va_3);

			for (var i:uint = 0; i < len; i += stride)
			{
				vertices[i] *= scale;
				vertices[i + 1] *= scale;
				vertices[i + 2] *= scale;
			}
			markBufferDirty(_.position_va_3);
		}

		/**
		 * 顶点数据
		 */
		public function get vertexPositionData():Vector.<Number>
		{
			return getVAData(_.position_va_3);
		}

		/**
		 * 顶点法线数据
		 */
		public function get vertexNormalData():Vector.<Number>
		{
			return getVAData(_.normal_va_3);
		}

		/**
		 * 顶点切线数据
		 */
		public function get vertexTangentData():Vector.<Number>
		{
			return getVAData(_.tangent_va_3);
		}

		/**
		 * uv数据
		 */
		public function get UVData():Vector.<Number>
		{
			return getVAData(_.uv_va_2);
		}

		/**
		 * 顶点坐标数据步长
		 */
		public function get vertexPositionStride():uint
		{
			return getVALen(_.position_va_3);
		}

		/**
		 * 顶点切线步长
		 */
		public function get vertexTangentStride():uint
		{
			return getVALen(_.tangent_va_3);
		}

		/**
		 * 顶点法线步长
		 */
		public function get vertexNormalStride():uint
		{
			return getVALen(_.normal_va_3);
		}

		/**
		 * UV步长
		 */
		public function get UVStride():uint
		{
			return getVALen(_.uv_va_2);
		}

		override protected function notifyVADataChanged(dataTypeId:String):void
		{
			super.notifyVADataChanged(dataTypeId);

			dispatchEvent(new GeometryComponentEvent(GeometryComponentEvent.CHANGED_VA_DATA, dataTypeId));
		}

		override public function getVAData(dataTypeId:String):Vector.<Number>
		{
			dispatchEvent(new GeometryComponentEvent(GeometryComponentEvent.GET_VA_DATA, dataTypeId));

			return super.getVAData(dataTypeId);
		}

		override public function updateIndexData(indices:Vector.<uint>):void
		{
			super.updateIndexData(indices);

			dispatchEvent(new GeometryComponentEvent(GeometryComponentEvent.CHANGED_INDEX_DATA));
		}

		public function clone():SubGeometry
		{
			var cls:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
			var _clone:SubGeometry = new cls();

			//顶点属性编号列表
			var vaId:String;

			/** 顶点数据字典 */
			var sourceVertexDataDic:Dictionary = new Dictionary();
			for each (vaId in vaIdList)
			{
				sourceVertexDataDic[vaId] = getVAData(vaId);
				assert(sourceVertexDataDic[vaId].length == getVALen(vaId) * numVertices);
			}

			//添加索引数据
			_clone.updateIndexData(indices.concat());

			//更改顶点数量
			_clone.numVertices = numVertices;

			//添加顶点数据
			for each (vaId in vaIdList)
			{
				_clone.setVAData(vaId, sourceVertexDataDic[vaId].concat());
			}

			return _clone;
		}

		/**
		 * 父网格
		 */
		public function get parent():Geometry
		{
			return _parent;
		}

		public function set parent(value:Geometry):void
		{
			_parent = value;
		}
	}
}
