package data
{
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;

	/**
	 * 解析pan3d中的数据
	 * @author warden_feng 2014-4-23
	 */
	public class PanParser
	{
		public function PanParser()
		{
		}

		/**
		 * 解析pan3d中的数据
		 * @param _stringV 这个为空间中的点，每三个一组; 顶点坐标
		 * @param _stringU 这为贴图上的点,每二个一组; UV坐标
		 * @param _stringUV 顶点索引
		 * @return 几个结构
		 */
		public static function getPanGeometry(_stringV:String, _stringU:String, _stringUV:String, scale:Number = 1):Geometry
		{
			var _v_array:Vector.<Number> = Vector.<Number>(_stringV.split(" ")); //拆分顶点
			var _u_array:Vector.<Number> = Vector.<Number>(_stringU.split(" ")); //拆分uv
			var _uv_array:Vector.<uint> = Vector.<uint>(_stringUV.split(" ")); //拆分顶点与uv对应关系

			var positionsBuffer:Vector.<Number> = new Vector.<Number>(); //拆分 3D点
			var uvBuffer:Vector.<Number> = new Vector.<Number>(); //拆分 3D点
			var indexBuffer:Vector.<uint> = new Vector.<uint>(); //拆分 3D点

			var index:int = 0;
			var vertexIndex:int;
			var uvIndex:int;
			for (var i:int = 0; i < _uv_array.length; i += 2)
			{
				indexBuffer.push(index);
				vertexIndex = _uv_array[i] * 3;
				positionsBuffer.push(_v_array[vertexIndex] * scale, _v_array[vertexIndex + 2] * scale, _v_array[vertexIndex + 1] * scale);
				uvIndex = _uv_array[i + 1] * 3;
				uvBuffer.push(_u_array[uvIndex], 1 - _u_array[uvIndex + 1]);
				index++;
			}

			var geometry:Geometry = new Geometry();
			var subGeometry:SubGeometry = new SubGeometry();
			subGeometry.numVertices = positionsBuffer.length / 3;
			subGeometry.updateIndexData(indexBuffer);
			subGeometry.updateVertexPositionData(positionsBuffer);
			subGeometry.updateUVData(uvBuffer);
			geometry.addSubGeometry(subGeometry);

			return geometry;
		}

		/**
		 * 解析pan3d中的顶点动画数据
		 * @param _stringV 这个为空间中的点，每三个一组; 顶点坐标
		 * @param _stringU 这为贴图上的点,每二个一组; UV坐标
		 * @param _stringUV 顶点索引
		 * @return 几个结构
		 */
		public static function getPanAnimationGeometry(_stringVList:Array, _stringU:String, _stringUV:String, scale:Number = 1):Vector.<Geometry>
		{
			var geometrys:Vector.<Geometry> = new Vector.<Geometry>(_stringVList.length);
			var _v_arrayList:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(_stringVList.length);

			for (var j:int = 0; j < _stringVList.length; j++)
			{
				_v_arrayList[j] = Vector.<Number>(_stringVList[j].split(" ")); //拆分顶点
			}

			var _v_array:Vector.<Number>;
			var _u_array:Vector.<Number> = Vector.<Number>(_stringU.split(" ")); //拆分uv
			var _uv_array:Vector.<uint> = Vector.<uint>(_stringUV.split(" ")); //拆分顶点与uv对应关系

			for (var k:int = 0; k < _v_arrayList.length; k++)
			{
				_v_array = _v_arrayList[k];

				var positionsBuffer:Vector.<Number> = new Vector.<Number>(); //拆分 3D点
				var uvBuffer:Vector.<Number> = new Vector.<Number>(); //拆分 3D点
				var indexBuffer:Vector.<uint> = new Vector.<uint>(); //拆分 3D点

				var index:int = 0;
				var vertexIndex:int;
				var uvIndex:int;
				var i:int = 0;
				var len:int = _uv_array.length;
				for (i = 0; i < len; i += 2)
				{
					indexBuffer.push(index);
					vertexIndex = _uv_array[i] * 3;
					positionsBuffer.push(_v_array[vertexIndex] * scale, _v_array[vertexIndex + 1] * scale, _v_array[vertexIndex + 2] * scale);
					uvIndex = _uv_array[i + 1] * 3;
					uvBuffer.push(_u_array[uvIndex], 1 - _u_array[uvIndex + 1]);
					index++;
				}
				//计算反面数据
				for (i = 0; i < len; i += 2)
				{
					indexBuffer.push(index);
					vertexIndex = _uv_array[i] * 3;
					positionsBuffer.push(_v_array[vertexIndex] * scale, _v_array[vertexIndex + 1] * scale, _v_array[vertexIndex + 2] * scale);
					uvIndex = _uv_array[i + 1] * 3;
					uvBuffer.push(_u_array[uvIndex] + 0.5, 1 - _u_array[uvIndex + 1]);
					index++;
				}
				for (i = indexBuffer.length / 2; i < indexBuffer.length; i += 3)
				{
					var temp:uint = indexBuffer[i];
					indexBuffer[i] = indexBuffer[i + 1];
					indexBuffer[i + 1] = temp;
				}

				var geometry:Geometry = geometrys[k] = new Geometry();

				var subGeometry:SubGeometry = new SubGeometry();
				subGeometry.numVertices = positionsBuffer.length / 3;
				subGeometry.updateIndexData(indexBuffer);
				subGeometry.updateVertexPositionData(positionsBuffer);
				subGeometry.updateUVData(uvBuffer);
				geometry.addSubGeometry(subGeometry);
			}
			return geometrys;
		}

	}
}


