package me.feng3d.parsers
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.animators.skeleton.SkeletonAnimationSet;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.animators.skeleton.data.SkeletonJoint;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SkinnedSubGeometry;
	import me.feng3d.entities.Mesh;
	import me.feng3d.mathlib.Quaternion;

	use namespace arcane;

	/**
	 * MD5Mesh文件解析类
	 */
	public class MD5MeshParser extends ParserBase
	{
		private var _textData:String;
		private var _startedParsing:Boolean;
		private static const VERSION_TOKEN:String = "MD5Version";
		private static const COMMAND_LINE_TOKEN:String = "commandline";
		private static const NUM_JOINTS_TOKEN:String = "numJoints";
		private static const NUM_MESHES_TOKEN:String = "numMeshes";
		private static const COMMENT_TOKEN:String = "//";
		private static const JOINTS_TOKEN:String = "joints";
		private static const MESH_TOKEN:String = "mesh";

		private static const MESH_SHADER_TOKEN:String = "shader";
		private static const MESH_NUM_VERTS_TOKEN:String = "numverts";
		private static const MESH_VERT_TOKEN:String = "vert";
		private static const MESH_NUM_TRIS_TOKEN:String = "numtris";
		private static const MESH_TRI_TOKEN:String = "tri";
		private static const MESH_NUM_WEIGHTS_TOKEN:String = "numweights";
		private static const MESH_WEIGHT_TOKEN:String = "weight";

		/** 当前解析位置 */
		private var _parseIndex:int;
		/** 是否文件尾 */
		private var _reachedEOF:Boolean;
		/** 当前解析行号 */
		private var _line:int;
		/** 当前行的字符位置 */
		private var _charLineIndex:int;
		/** 版本号 */
		private var _version:int;
		/** 关节数量 */
		private var _numJoints:int;
		/** 网格数量 */
		private var _numMeshes:int;
		/** 渲染材质信息 */
		private var _shaders:Vector.<String>;
		/** 顶点最大关节关联数 */
		private var _maxJointCount:int;
		/** 网格原始数据 */
		private var _meshData:Vector.<MeshData>;
		/** bindpose姿态下的变换矩阵 */
		private var _bindPoses:Vector.<Matrix3D>;
		/** 骨骼数据 */
		private var _skeleton:Skeleton;

		private var _animationSet:SkeletonAnimationSet;

		/** 旋转四元素 */
		private var _rotationQuat:Quaternion;

		/**
		 * 创建一个MD5Mesh解析对象
		 */
		public function MD5MeshParser(additionalRotationAxis:Vector3D = null, additionalRotationRadians:Number = 0)
		{
			super(ParserDataFormat.PLAIN_TEXT);

			//初始化 旋转四元素
			_rotationQuat = new Quaternion();
			_rotationQuat.fromAxisAngle(Vector3D.X_AXIS, -Math.PI * .5);

			if (additionalRotationAxis)
			{
				var quat:Quaternion = new Quaternion();
				quat.fromAxisAngle(additionalRotationAxis, additionalRotationRadians);
				_rotationQuat.multiply(_rotationQuat, quat);
			}
		}

		/**
		 * 判断是否支持解析
		 * @param extension 文件类型
		 * @return
		 */
		public static function supportsType(extension:String):Boolean
		{
			extension = extension.toLowerCase();
			return extension == "md5mesh";
		}

		/**
		 * 判断是否支持该数据的解析
		 * @param data 需要解析的数据
		 * @return
		 */
		public static function supportsData(data:*):Boolean
		{
			data = data;
			return false;
		}

		protected override function proceedParsing():Boolean
		{
			var token:String;

			//标记开始解析
			if (!_startedParsing)
			{
				_textData = getTextData();
				_startedParsing = true;
			}

			while (hasTime())
			{
				//获取关键字
				token = getNextToken();
				switch (token)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case VERSION_TOKEN:
						_version = getNextInt();
						if (_version != 10)
							throw new Error("Unknown version number encountered!");
						break;
					case COMMAND_LINE_TOKEN:
						parseCMD();
						break;
					case NUM_JOINTS_TOKEN:
						_numJoints = getNextInt();
						_bindPoses = new Vector.<Matrix3D>(_numJoints, true);
						break;
					case NUM_MESHES_TOKEN:
						_numMeshes = getNextInt();
						break;
					case JOINTS_TOKEN:
						parseJoints();
						break;
					case MESH_TOKEN:
						parseMesh();
						break;
					default:
						if (!_reachedEOF)
							sendUnknownKeywordError();
				}

				//解析结束后 生成引擎相关对象
				if (_reachedEOF)
				{
					calculateMaxJointCount();
					_animationSet = new SkeletonAnimationSet(_maxJointCount);

					//生成引擎所需网格对象
					var _mesh:Mesh = new Mesh(new Geometry(), null);
					var _geometry:Geometry = _mesh.geometry;

					for (var i:int = 0; i < _meshData.length; ++i)
						_geometry.addSubGeometry(translateGeom(_meshData[i].vertexData, _meshData[i].weightData, _meshData[i].indices));

					finalizeAsset(_geometry);
					finalizeAsset(_mesh);
					finalizeAsset(_skeleton);
					finalizeAsset(_animationSet);
					return ParserBase.PARSING_DONE;
				}
			}
			return ParserBase.MORE_TO_PARSE;
		}

		/**
		 * 计算最大关节数量
		 */
		private function calculateMaxJointCount():void
		{
			_maxJointCount = 0;

			//遍历所有的网格数据
			var numMeshData:int = _meshData.length;
			for (var i:int = 0; i < numMeshData; ++i)
			{
				var meshData:MeshData = _meshData[i];
				var vertexData:Vector.<VertexData> = meshData.vertexData;
				var numVerts:int = vertexData.length;

				//遍历每个顶点 寻找关节关联最大数量
				for (var j:int = 0; j < numVerts; ++j)
				{
					var zeroWeights:int = countZeroWeightJoints(vertexData[j], meshData.weightData);
					var totalJoints:int = vertexData[j].countWeight - zeroWeights;
					if (totalJoints > _maxJointCount)
						_maxJointCount = totalJoints;
				}
			}
		}

		/**
		 * 计算0权重关节数量
		 * @param vertex 顶点数据
		 * @param weights 关节权重数组
		 * @return
		 */
		private function countZeroWeightJoints(vertex:VertexData, weights:Vector.<WeightData>):int
		{
			var start:int = vertex.startWeight;
			var end:int = vertex.startWeight + vertex.countWeight;
			var count:int = 0;
			var weight:Number;

			for (var i:int = start; i < end; ++i)
			{
				weight = weights[i].bias;
				if (weight == 0)
					++count;
			}

			return count;
		}

		/**
		 * 解析关节
		 */
		private function parseJoints():void
		{
			var ch:String;
			var joint:SkeletonJoint;
			var pos:Vector3D;
			var quat:Quaternion;
			var i:int = 0;
			var token:String = getNextToken();

			if (token != "{")
				sendUnknownKeywordError();

			//解析骨骼数据
			_skeleton = new Skeleton();

			do
			{
				if (_reachedEOF)
					sendEOFError();
				//解析骨骼关节数据
				joint = new SkeletonJoint();
				joint.name = parseLiteralString();
				joint.parentIndex = getNextInt();
				//关节坐标
				pos = parseVector3D();
				pos = _rotationQuat.rotatePoint(pos);
				quat = parseQuaternion();

				// 计算bindpose下该节点(关节)的真正变换矩阵
				_bindPoses[i] = quat.toMatrix3D();
				_bindPoses[i].appendTranslation(pos.x, pos.y, pos.z);
				var inv:Matrix3D = _bindPoses[i].clone();
				inv.invert();
				joint.inverseBindPose = inv.rawData;

				//收集关节数据
				_skeleton.joints[i++] = joint;

				ch = getNextChar();

				if (ch == "/")
				{
					putBack();
					ch = getNextToken();
					if (ch == COMMENT_TOKEN)
						ignoreLine();
					ch = getNextChar();

				}

				if (ch != "}")
					putBack();
			} while (ch != "}");
		}

		/**
		 * 返回到上个字符位置
		 */
		private function putBack():void
		{
			_parseIndex--;
			_charLineIndex--;
			_reachedEOF = _parseIndex >= _textData.length;
		}

		/**
		 * 解析网格几何体
		 */
		private function parseMesh():void
		{
			var token:String = getNextToken();
			var ch:String;
			var vertexData:Vector.<VertexData>;
			var weights:Vector.<WeightData>;
			var indices:Vector.<uint>;

			if (token != "{")
				sendUnknownKeywordError();

			_shaders ||= new Vector.<String>();

			while (ch != "}")
			{
				ch = getNextToken();
				switch (ch)
				{
					case COMMENT_TOKEN:
						ignoreLine();
						break;
					case MESH_SHADER_TOKEN:
						//材质数据
						_shaders.push(parseLiteralString());
						break;
					case MESH_NUM_VERTS_TOKEN:
						//顶点数据
						vertexData = new Vector.<VertexData>(getNextInt(), true);
						break;
					case MESH_NUM_TRIS_TOKEN:
						//根据三角形个数 创建顶点数组
						indices = new Vector.<uint>(getNextInt() * 3, true);
						break;
					case MESH_NUM_WEIGHTS_TOKEN:
						//创建关节数据
						weights = new Vector.<WeightData>(getNextInt(), true);
						break;
					case MESH_VERT_TOKEN:
						//解析一个顶点数据
						parseVertex(vertexData);
						break;
					case MESH_TRI_TOKEN:
						parseTri(indices);
						break;
					case MESH_WEIGHT_TOKEN:
						parseJoint(weights);
						break;
				}
			}

			//保存网格数据
			_meshData ||= new Vector.<MeshData>();
			var i:uint = _meshData.length;
			_meshData[i] = new MeshData();
			_meshData[i].vertexData = vertexData;
			_meshData[i].weightData = weights;
			_meshData[i].indices = indices;
		}

		/**
		 * 转换网格数据为SkinnedSubGeometry实例
		 * @param vertexData 网格顶点数据
		 * @param weights 每个顶点的关节权重数据
		 * @param indices 顶点索引数据
		 * @return 包含所有几何体数据的SkinnedSubGeometry实例
		 */
		private function translateGeom(vertexData:Vector.<VertexData>, weights:Vector.<WeightData>, indices:Vector.<uint>):SkinnedSubGeometry
		{
			var len:int = vertexData.length;
			var v1:int, v2:int, v3:int;
			var vertex:VertexData;
			var weight:WeightData;
			var bindPose:Matrix3D;
			var pos:Vector3D;
			var subGeom:SkinnedSubGeometry = new SkinnedSubGeometry(_maxJointCount);
			//uv数据
			var uvs:Vector.<Number> = new Vector.<Number>(len * 2, true);
			//顶点位置数据
			var vertices:Vector.<Number> = new Vector.<Number>(len * 3, true);
			//关节索引数据
			var jointIndices:Vector.<Number> = new Vector.<Number>(len * _maxJointCount, true);
			//关节权重数据
			var jointWeights:Vector.<Number> = new Vector.<Number>(len * _maxJointCount, true);
			var l:int;
			//0权重个数
			var nonZeroWeights:int;

			for (var i:int = 0; i < len; ++i)
			{
				vertex = vertexData[i];
				v1 = vertex.index * 3;
				v2 = v1 + 1;
				v3 = v1 + 2;
				vertices[v1] = vertices[v2] = vertices[v3] = 0;

				/**
				 * 参考 http://blog.csdn.net/summerhust/article/details/17421213
				 * VertexPos = (MJ-0 * weight[index0].pos * weight[index0].bias) + ... + (MJ-N * weight[indexN].pos * weight[indexN].bias)
				 * 变量对应 :
				 * MJ-N -> bindPose; 第J个关节的变换矩阵
				 * weight[indexN].pos -> weight.pos;
				 * weight[indexN].bias -> weight.bias;
				 */

				nonZeroWeights = 0;
				for (var j:int = 0; j < vertex.countWeight; ++j)
				{
					weight = weights[vertex.startWeight + j];
					if (weight.bias > 0)
					{
						bindPose = _bindPoses[weight.joint];
						pos = bindPose.transformVector(weight.pos);
						vertices[v1] += pos.x * weight.bias;
						vertices[v2] += pos.y * weight.bias;
						vertices[v3] += pos.z * weight.bias;

						// indices need to be multiplied by 3 (amount of matrix registers)
						jointIndices[l] = weight.joint * 3;
						jointWeights[l++] = weight.bias;
						++nonZeroWeights;
					}
				}

				for (j = nonZeroWeights; j < _maxJointCount; ++j)
				{
					jointIndices[l] = 0;
					jointWeights[l++] = 0;
				}

				v1 = vertex.index << 1;
				uvs[v1++] = vertex.u;
				uvs[v1] = vertex.v;
			}

			//更新索引数据
			subGeom.updateIndexData(indices);
			subGeom.numVertices = vertices.length / 3;
			//更新顶点坐标与uv数据
			subGeom.fromVectors(vertices, uvs);
			// cause explicit updates
			subGeom.vertexNormalData;
			subGeom.vertexTangentData;
			// turn auto updates off because they may be animated and set explicitly
			subGeom.autoDeriveVertexTangents = false;
			subGeom.autoDeriveVertexNormals = false;
			//更新关节索引与权重索引
			subGeom.updateJointIndexData(jointIndices);
			subGeom.updateJointWeightsData(jointWeights);

			return subGeom;
		}

		/**
		 * 解析三角形数据
		 * @param indices 索引数据
		 */
		private function parseTri(indices:Vector.<uint>):void
		{
			var index:int = getNextInt() * 3;
			indices[index] = getNextInt();
			indices[index + 1] = getNextInt();
			indices[index + 2] = getNextInt();
		}

		/**
		 * 解析关节数据
		 * @param weights 权重数据列表
		 */
		private function parseJoint(weights:Vector.<WeightData>):void
		{
			var weight:WeightData = new WeightData();
			weight.index = getNextInt();
			weight.joint = getNextInt();
			weight.bias = getNextNumber();
			weight.pos = parseVector3D();
			weights[weight.index] = weight;
		}

		/**
		 * 解析一个顶点
		 * @param vertexData 顶点数据列表
		 */
		private function parseVertex(vertexData:Vector.<VertexData>):void
		{
			var vertex:VertexData = new VertexData();
			vertex.index = getNextInt();
			parseUV(vertex);
			vertex.startWeight = getNextInt();
			vertex.countWeight = getNextInt();
			vertexData[vertex.index] = vertex;
		}

		/**
		 * 解析uv坐标
		 * @param vertexData 包含uv坐标的顶点数据
		 */
		private function parseUV(vertexData:VertexData):void
		{
			var ch:String = getNextToken();
			if (ch != "(")
				sendParseError("(");
			vertexData.u = getNextNumber();
			vertexData.v = getNextNumber();

			if (getNextToken() != ")")
				sendParseError(")");
		}

		/**
		 * 获取下个关键字
		 */
		private function getNextToken():String
		{
			var ch:String;
			var token:String = "";

			while (!_reachedEOF)
			{
				ch = getNextChar();
				if (ch == " " || ch == "\r" || ch == "\n" || ch == "\t")
				{
					if (token != COMMENT_TOKEN)
						skipWhiteSpace();
					if (token != "")
						return token;
				}
				else
					token += ch;

				if (token == COMMENT_TOKEN)
					return token;
			}

			return token;
		}

		/**
		 * 跳过空白
		 */
		private function skipWhiteSpace():void
		{
			var ch:String;

			do
				ch = getNextChar();
			while (ch == "\n" || ch == " " || ch == "\r" || ch == "\t");

			putBack();
		}

		/**
		 * 忽略该行
		 */
		private function ignoreLine():void
		{
			var ch:String;
			while (!_reachedEOF && ch != "\n")
				ch = getNextChar();
		}

		/**
		 * 读取下个字符
		 */
		private function getNextChar():String
		{
			var ch:String = _textData.charAt(_parseIndex++);

			if (ch == "\n")
			{
				++_line;
				_charLineIndex = 0;
			}
			else if (ch != "\r")
				++_charLineIndex;

			if (_parseIndex >= _textData.length)
				_reachedEOF = true;

			return ch;
		}

		/**
		 * 读取下个int
		 */
		private function getNextInt():int
		{
			var i:Number = parseInt(getNextToken());
			if (isNaN(i))
				sendParseError("int type");
			return i;
		}

		/**
		 * 读取下个Number
		 */
		private function getNextNumber():Number
		{
			var f:Number = parseFloat(getNextToken());
			if (isNaN(f))
				sendParseError("float type");
			return f;
		}

		/**
		 * 解析3d向量
		 */
		private function parseVector3D():Vector3D
		{
			var vec:Vector3D = new Vector3D();
			var ch:String = getNextToken();

			if (ch != "(")
				sendParseError("(");
			vec.x = -getNextNumber();
			vec.y = getNextNumber();
			vec.z = getNextNumber();

			if (getNextToken() != ")")
				sendParseError(")");

			return vec;
		}

		/**
		 * 解析四元素
		 */
		private function parseQuaternion():Quaternion
		{
			var quat:Quaternion = new Quaternion();
			var ch:String = getNextToken();

			if (ch != "(")
				sendParseError("(");
			quat.x = getNextNumber();
			quat.y = -getNextNumber();
			quat.z = -getNextNumber();

			// quat supposed to be unit length
			var t:Number = 1 - quat.x * quat.x - quat.y * quat.y - quat.z * quat.z;
			quat.w = t < 0 ? 0 : -Math.sqrt(t);

			if (getNextToken() != ")")
				sendParseError(")");

			var rotQuat:Quaternion = new Quaternion();
			rotQuat.multiply(_rotationQuat, quat);
			return rotQuat;
		}

		/**
		 * 解析命令行数据
		 */
		private function parseCMD():void
		{
			//忽略命令行数据
			parseLiteralString();
		}

		/**
		 * 解析带双引号的字符串
		 */
		private function parseLiteralString():String
		{
			skipWhiteSpace();

			var ch:String = getNextChar();
			var str:String = "";

			if (ch != "\"")
				sendParseError("\"");

			do
			{
				if (_reachedEOF)
					sendEOFError();
				ch = getNextChar();
				if (ch != "\"")
					str += ch;
			} while (ch != "\"");

			return str;
		}

		/**
		 * 抛出一个文件尾过早结束文件时遇到错误
		 */
		private function sendEOFError():void
		{
			throw new Error("Unexpected end of file");
		}

		/**
		 * 遇到了一个意想不到的令牌时将抛出一个错误。
		 * @param expected 发生错误的标记
		 */
		private function sendParseError(expected:String):void
		{
			throw new Error("Unexpected token at line " + (_line + 1) + ", character " + _charLineIndex + ". " + expected + " expected, but " + _textData.charAt(_parseIndex - 1) + " encountered");
		}

		/**
		 * 发生未知关键字错误
		 */
		private function sendUnknownKeywordError():void
		{
			throw new Error("Unknown keyword at line " + (_line + 1) + ", character " + _charLineIndex + ". ");
		}
	}
}

import flash.geom.Vector3D;

/**
 * 顶点数据
 */
class VertexData
{
	/** 顶点索引 */
	public var index:int;
	/** 纹理坐标u */
	public var u:Number;
	/** 纹理坐标v */
	public var v:Number;
	/** weight的起始序号 */
	public var startWeight:int;
	/** weight总数 */
	public var countWeight:int;

	public function VertexData()
	{
	}
}

/**
 * 关节权重数据
 */
class WeightData
{
	/** weight 序号 */
	public var index:int;
	/** 对应的Joint的序号 */
	public var joint:int;
	/** 作用比例 */
	public var bias:Number;
	/** 位置值 */
	public var pos:Vector3D;

	public function WeightData()
	{
	}
}

/**
 * 网格数据
 */
class MeshData
{
	/** 顶点数据 */
	public var vertexData:Vector.<VertexData>;
	/** 权重数据 */
	public var weightData:Vector.<WeightData>;
	/** 顶点索引 */
	public var indices:Vector.<uint>;

	public function MeshData()
	{
	}
}
