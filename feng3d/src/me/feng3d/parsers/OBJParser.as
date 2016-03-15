package me.feng3d.parsers
{
	import flash.net.URLRequest;

	import me.feng3d.arcane;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.data.UV;
	import me.feng3d.core.base.data.Vertex;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.entities.Mesh;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.materials.ColorMaterial;
	import me.feng3d.materials.ColorMultiPassMaterial;
	import me.feng3d.materials.MaterialBase;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.materials.TextureMultiPassMaterial;
	import me.feng3d.materials.methods.BasicSpecularMethod;
	import me.feng3d.parsers.utils.ParserUtil;
	import me.feng3d.textures.Texture2DBase;
	import me.feng3d.utils.DefaultMaterialManager;
	import me.feng3d.utils.GeomUtil;

	use namespace arcane;

	/**
	 * Obj模型解析者
	 */
	public class OBJParser extends ParserBase
	{
		/** 字符串数据 */
		private var _textData:String;
		/** 是否开始了解析 */
		private var _startedParsing:Boolean;
		/** 当前读取到的位置 */
		private var _charIndex:uint;
		/** 刚才读取到的位置 */
		private var _oldIndex:uint;
		/** 字符串数据长度 */
		private var _stringLength:uint;
		/** 当前解析的对象 */
		private var _currentObject:ObjectGroup;
		/** 当前组 */
		private var _currentGroup:Group;
		/** 当前材质组 */
		private var _currentMaterialGroup:MaterialGroup;
		/** 对象组列表 */
		private var _objects:Vector.<ObjectGroup>;
		/** 材质编号列表 */
		private var _materialIDs:Vector.<String>;
		/** 加载了的材质列表 */
		private var _materialLoaded:Vector.<LoadedMaterial>;

		private var _materialSpecularData:Vector.<SpecularData>;
		/** 网格列表 */
		private var _meshes:Vector.<Mesh>;
		/** 最后的材质编号 */
		private var _lastMtlID:String;
		/** object索引 */
		private var _objectIndex:uint;
		/** 真实索引列表 */
		private var _realIndices:Array;
		/** 顶点索引 */
		private var _vertexIndex:uint;
		/** 顶点坐标数据 */
		private var _vertices:Vector.<Vertex>;
		/** 顶点法线数据 */
		private var _vertexNormals:Vector.<Vertex>;
		/** uv数据 */
		private var _uvs:Vector.<UV>;
		/** 缩放尺度 */
		private var _scale:Number;
		/**  */
		private var _mtlLib:Boolean;
		/** 材质库是否已加载 */
		private var _mtlLibLoaded:Boolean = true;
		/** 活动材质编号 */
		private var _activeMaterialID:String = "";

		/**
		 * 创建Obj模型解析对象
		 * @param scale 缩放比例
		 */
		public function OBJParser(scale:Number = 1)
		{
			super(ParserDataFormat.PLAIN_TEXT);
			_scale = scale;
		}

		/**
		 * 判断是否支持解析
		 * @param extension 文件类型
		 * @return
		 */
		public static function supportsType(extension:String):Boolean
		{
			extension = extension.toLowerCase();
			return extension == "obj";
		}

		/**
		 * 判断是否支持该数据的解析
		 * @param data 需要解析的数据
		 * @return
		 */
		public static function supportsData(data:*):Boolean
		{
			var content:String = ParserUtil.toString(data);
			var hasV:Boolean;
			var hasF:Boolean;

			if (content)
			{
				hasV = content.indexOf("\nv ") != -1;
				hasF = content.indexOf("\nf ") != -1;
			}

			return hasV && hasF;
		}

		override arcane function resolveDependency(resourceDependency:ResourceDependency):void
		{
			if (resourceDependency.id == 'mtl')
			{
				var str:String = ParserUtil.toString(resourceDependency.data);
				parseMtl(str);
			}
			else
			{

				var asset:IAsset;

				if (resourceDependency.assets.length != 1)
					return;

				asset = resourceDependency.assets[0];

				if (asset.namedAsset.assetType == AssetType.TEXTURE)
				{
					var lm:LoadedMaterial = new LoadedMaterial();
					lm.materialID = resourceDependency.id;
					lm.texture = asset as Texture2DBase;

					_materialLoaded.push(lm);

					if (_meshes.length > 0)
						applyMaterial(lm);
				}
			}
		}

		override arcane function resolveDependencyFailure(resourceDependency:ResourceDependency):void
		{
			if (resourceDependency.id == "mtl")
			{
				_mtlLib = false;
				_mtlLibLoaded = false;
			}
			else
			{
				var lm:LoadedMaterial = new LoadedMaterial();
				lm.materialID = resourceDependency.id;
				_materialLoaded.push(lm);
			}

			if (_meshes.length > 0)
				applyMaterial(lm);
		}

		override protected function proceedParsing():Boolean
		{
			//单行数据
			var line:String;
			//换行符
			var creturn:String = String.fromCharCode(10);
			var trunk:Array;

			if (!_startedParsing)
			{
				_textData = getTextData();
				// Merge linebreaks that are immediately preceeded by
				// the "escape" backward slash into single lines.
				_textData = _textData.replace(/\\[\r\n]+\s*/gm, ' ');
			}

			if (_textData.indexOf(creturn) == -1)
				creturn = String.fromCharCode(13);

			//初始化数据
			if (!_startedParsing)
			{
				_startedParsing = true;
				_vertices = new Vector.<Vertex>();
				_vertexNormals = new Vector.<Vertex>();
				_materialIDs = new Vector.<String>();
				_materialLoaded = new Vector.<LoadedMaterial>();
				_meshes = new Vector.<Mesh>();
				_uvs = new Vector.<UV>();
				_stringLength = _textData.length;
				_charIndex = _textData.indexOf(creturn, 0);
				_oldIndex = 0;
				_objects = new Vector.<ObjectGroup>();
				_objectIndex = 0;
			}

			//判断是否解析完毕与是否还有时间
			while (_charIndex < _stringLength && hasTime())
			{
				_charIndex = _textData.indexOf(creturn, _oldIndex);

				if (_charIndex == -1)
					_charIndex = _stringLength;

				//获取单行数据 整理数据格式
				line = _textData.substring(_oldIndex, _charIndex);
				line = line.split('\r').join("");
				line = line.replace("  ", " ");
				trunk = line.split(" ");
				_oldIndex = _charIndex + 1;

				//解析该行数据
				parseLine(trunk);

				//处理暂停
				if (parsingPaused)
					return MORE_TO_PARSE;
			}

			//数据解析到文件未
			if (_charIndex >= _stringLength)
			{
				//判断是否还需要等待材质解析
				if (_mtlLib && !_mtlLibLoaded)
					return MORE_TO_PARSE;

				translate();
				applyMaterials();

				return PARSING_DONE;
			}

			return MORE_TO_PARSE;
		}

		/**
		 * 解析行
		 */
		private function parseLine(trunk:Array):void
		{
			switch (trunk[0])
			{
				case "mtllib":
					_mtlLib = true;
					_mtlLibLoaded = false;
					loadMtl(trunk[1]);
					break;
				case "g":
					createGroup(trunk);
					break;
				case "o":
					createObject(trunk);
					break;
				case "usemtl":
					if (_mtlLib)
					{
						if (!trunk[1])
							trunk[1] = "def000";
						_materialIDs.push(trunk[1]);
						_activeMaterialID = trunk[1];
						if (_currentGroup)
							_currentGroup.materialID = _activeMaterialID;
					}
					break;
				case "v":
					parseVertex(trunk);
					break;
				case "vt":
					parseUV(trunk);
					break;
				case "vn":
					parseVertexNormal(trunk);
					break;
				case "f":
					parseFace(trunk);
			}
		}

		/**
		 * 把解析出来的数据转换成引擎使用的数据结构
		 */
		private function translate():void
		{
			for (var objIndex:int = 0; objIndex < _objects.length; ++objIndex)
			{
				var groups:Vector.<Group> = _objects[objIndex].groups;
				var numGroups:uint = groups.length;
				var materialGroups:Vector.<MaterialGroup>;
				var numMaterialGroups:uint;
				var geometry:Geometry;
				var mesh:Mesh;

				var m:uint;
				var sm:uint;
				var bmMaterial:MaterialBase;

				for (var g:uint = 0; g < numGroups; ++g)
				{
					geometry = new Geometry();
					materialGroups = groups[g].materialGroups;
					numMaterialGroups = materialGroups.length;

					//添加子网格
					for (m = 0; m < numMaterialGroups; ++m)
						translateMaterialGroup(materialGroups[m], geometry);

					if (geometry.subGeometries.length == 0)
						continue;

					//完成几何体资源解析
					finalizeAsset(geometry, "");
					if (materialMode < 2)
						bmMaterial = new TextureMaterial(DefaultMaterialManager.getDefaultTexture());
					else
						bmMaterial = new TextureMultiPassMaterial(DefaultMaterialManager.getDefaultTexture());
					//创建网格
					mesh = new Mesh(geometry, bmMaterial);

					//网格命名
					if (_objects[objIndex].name)
					{
						//使用'o'标签给网格命名
						mesh.name = _objects[objIndex].name;
					}
					else if (groups[g].name)
					{
						//使用'g'标签给网格命名
						mesh.name = groups[g].name;
					}
					else
					{
						mesh.name = "";
					}

					_meshes.push(mesh);

					//给材质命名
					if (groups[g].materialID != "")
						bmMaterial.name = groups[g].materialID + "~" + mesh.name;
					else
						bmMaterial.name = _lastMtlID + "~" + mesh.name;

					//子网使用材质
					if (mesh.subMeshes.length > 1)
					{
						for (sm = 1; sm < mesh.subMeshes.length; ++sm)
							mesh.subMeshes[sm].material = bmMaterial;
					}

					finalizeAsset(mesh);
				}
			}
		}

		/**
		 * 转换材质组为子网格
		 * @param materialGroup 材质组网格数据
		 * @param geometry 解析出子网格的父网格
		 */
		private function translateMaterialGroup(materialGroup:MaterialGroup, geometry:Geometry):void
		{
			var faces:Vector.<FaceData> = materialGroup.faces;
			var face:FaceData;
			var numFaces:uint = faces.length;
			var numVerts:uint;
			var subs:Vector.<SubGeometry>;

			var vertices:Vector.<Number> = new Vector.<Number>();
			var uvs:Vector.<Number> = new Vector.<Number>();
			var normals:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();

			_realIndices = [];
			_vertexIndex = 0;

			//解析面数据
			var j:uint;
			for (var i:uint = 0; i < numFaces; ++i)
			{
				face = faces[i];
				numVerts = face.indexIds.length - 1;
				//兼容多边形(拆分成N-1个三角形)
				for (j = 1; j < numVerts; ++j)
				{
					translateVertexData(face, j, vertices, uvs, indices, normals);
					translateVertexData(face, 0, vertices, uvs, indices, normals);
					translateVertexData(face, j + 1, vertices, uvs, indices, normals);
				}
			}
			//创建 子网格
			if (vertices.length > 0)
			{
				subs = GeomUtil.fromVectors(vertices, indices, uvs, null, null);
				for (i = 0; i < subs.length; i++)
					geometry.addSubGeometry(subs[i]);
			}
		}

		/**
		 * 把面数据转换为顶点等数据
		 * @param face
		 * @param vertexIndex
		 * @param vertices
		 * @param uvs
		 * @param indices
		 * @param normals
		 */
		private function translateVertexData(face:FaceData, vertexIndex:int, vertices:Vector.<Number>, uvs:Vector.<Number>, indices:Vector.<uint>, normals:Vector.<Number>):void
		{
			var index:uint;
			var vertex:Vertex;
			var vertexNormal:Vertex;
			var uv:UV;

			if (!_realIndices[face.indexIds[vertexIndex]])
			{
				index = _vertexIndex;
				_realIndices[face.indexIds[vertexIndex]] = ++_vertexIndex;
				vertex = _vertices[face.vertexIndices[vertexIndex] - 1];
				vertices.push(vertex.x * _scale, vertex.y * _scale, vertex.z * _scale);

				if (face.normalIndices.length > 0)
				{
					vertexNormal = _vertexNormals[face.normalIndices[vertexIndex] - 1];
					normals.push(vertexNormal.x, vertexNormal.y, vertexNormal.z);
				}

				if (face.uvIndices.length > 0)
				{

					try
					{
						uv = _uvs[face.uvIndices[vertexIndex] - 1];
						uvs.push(uv.u, uv.v);

					}
					catch (e:Error)
					{

						switch (vertexIndex)
						{
							case 0:
								uvs.push(0, 1);
								break;
							case 1:
								uvs.push(.5, 0);
								break;
							case 2:
								uvs.push(1, 1);
						}
					}

				}

			}
			else
				index = _realIndices[face.indexIds[vertexIndex]] - 1;

			indices.push(index);
		}

		/**
		 * 创建对象组
		 * @param trunk 包含材料标记的数据块和它的参数
		 */
		private function createObject(trunk:Array):void
		{
			_currentGroup = null;
			_currentMaterialGroup = null;
			_objects.push(_currentObject = new ObjectGroup());

			if (trunk)
				_currentObject.name = trunk[1];
		}

		/**
		 * 创建一个组
		 * @param trunk 包含材料标记的数据块和它的参数
		 */
		private function createGroup(trunk:Array):void
		{
			if (!_currentObject)
				createObject(null);
			_currentGroup = new Group();

			_currentGroup.materialID = _activeMaterialID;

			if (trunk)
				_currentGroup.name = trunk[1];
			_currentObject.groups.push(_currentGroup);

			createMaterialGroup(null);
		}

		/**
		 * 创建材质组
		 * @param trunk 包含材料标记的数据块和它的参数
		 */
		private function createMaterialGroup(trunk:Array):void
		{
			_currentMaterialGroup = new MaterialGroup();
			if (trunk)
				_currentMaterialGroup.url = trunk[1];
			_currentGroup.materialGroups.push(_currentMaterialGroup);
		}

		/**
		 * 解析顶点坐标数据
		 * @param trunk 坐标数据
		 */
		private function parseVertex(trunk:Array):void
		{
			if (trunk.length > 4)
			{
				var nTrunk:Array = [];
				var val:Number;
				for (var i:uint = 1; i < trunk.length; ++i)
				{
					val = parseFloat(trunk[i]);
					if (!isNaN(val))
						nTrunk.push(val);
				}
				_vertices.push(new Vertex(nTrunk[0], nTrunk[1], -nTrunk[2]));
			}
			else
				_vertices.push(new Vertex(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3])));

		}

		/**
		 * 解析uv
		 * @param trunk uv数据
		 */
		private function parseUV(trunk:Array):void
		{
			if (trunk.length > 3)
			{
				var nTrunk:Array = [];
				var val:Number;
				//获取有效数字
				for (var i:uint = 1; i < trunk.length; ++i)
				{
					val = parseFloat(trunk[i]);
					if (!isNaN(val))
						nTrunk.push(val);
				}
				_uvs.push(new UV(nTrunk[0], 1 - nTrunk[1]));

			}
			else
				_uvs.push(new UV(parseFloat(trunk[1]), 1 - parseFloat(trunk[2])));

		}

		/**
		 * 解析顶点法线
		 * @param trunk 法线数据
		 */
		private function parseVertexNormal(trunk:Array):void
		{
			if (trunk.length > 4)
			{
				var nTrunk:Array = [];
				var val:Number;
				//获取有效数字
				for (var i:uint = 1; i < trunk.length; ++i)
				{
					val = parseFloat(trunk[i]);
					if (!isNaN(val))
						nTrunk.push(val);
				}
				_vertexNormals.push(new Vertex(nTrunk[0], nTrunk[1], -nTrunk[2]));

			}
			else
				_vertexNormals.push(new Vertex(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3])));
		}

		/**
		 * 解析面
		 * @param trunk 面数据
		 */
		private function parseFace(trunk:Array):void
		{
			var len:uint = trunk.length;
			var face:FaceData = new FaceData();

			if (!_currentGroup)
				createGroup(null);

			var indices:Array;
			for (var i:uint = 1; i < len; ++i)
			{
				if (trunk[i] == "")
					continue;
				//解析单个面数据，分离出顶点坐标左右、uv索引、法线索引
				indices = trunk[i].split("/");
				face.vertexIndices.push(parseIndex(parseInt(indices[0]), _vertices.length));
				if (indices[1] && String(indices[1]).length > 0)
					face.uvIndices.push(parseIndex(parseInt(indices[1]), _uvs.length));
				if (indices[2] && String(indices[2]).length > 0)
					face.normalIndices.push(parseIndex(parseInt(indices[2]), _vertexNormals.length));
				face.indexIds.push(trunk[i]);
			}

			_currentMaterialGroup.faces.push(face);
		}

		/**
		 * This is a hack around negative face coords
		 */
		private function parseIndex(index:int, length:uint):int
		{
			if (index < 0)
				return index + length + 1;
			else
				return index;
		}

		/**
		 * 解析材质数据
		 * @param data 材质数据
		 */
		private function parseMtl(data:String):void
		{
			var materialDefinitions:Array = data.split('newmtl');
			var lines:Array;
			var trunk:Array;
			var j:uint;

			var basicSpecularMethod:BasicSpecularMethod;
			var useSpecular:Boolean;
			var useColor:Boolean;
			var diffuseColor:uint;
			var ambientColor:uint;
			var specularColor:uint;
			var specular:Number;
			var alpha:Number;
			var mapkd:String;

			for (var i:uint = 0; i < materialDefinitions.length; ++i)
			{

				lines = (materialDefinitions[i].split('\r') as Array).join("").split('\n');

				if (lines.length == 1)
					lines = materialDefinitions[i].split(String.fromCharCode(13));

				diffuseColor = ambientColor = specularColor = 0xFFFFFF;
				specular = 0;
				useSpecular = false;
				useColor = false;
				alpha = 1;
				mapkd = "";

				for (j = 0; j < lines.length; ++j)
				{
					lines[j] = lines[j].replace(/\s+$/, "");

					if (lines[j].substring(0, 1) != "#" && (j == 0 || lines[j] != ""))
					{
						trunk = lines[j].split(" ");

						if (String(trunk[0]).charCodeAt(0) == 9 || String(trunk[0]).charCodeAt(0) == 32)
							trunk[0] = trunk[0].substring(1, trunk[0].length);

						if (j == 0)
						{
							_lastMtlID = trunk.join("");
							_lastMtlID = (_lastMtlID == "") ? "def000" : _lastMtlID;

						}
						else
						{

							switch (trunk[0])
							{

								case "Ka":
									if (trunk[1] && !isNaN(Number(trunk[1])) && trunk[2] && !isNaN(Number(trunk[2])) && trunk[3] && !isNaN(Number(trunk[3])))
										ambientColor = trunk[1] * 255 << 16 | trunk[2] * 255 << 8 | trunk[3] * 255;
									break;

								case "Ks":
									if (trunk[1] && !isNaN(Number(trunk[1])) && trunk[2] && !isNaN(Number(trunk[2])) && trunk[3] && !isNaN(Number(trunk[3])))
									{
										specularColor = trunk[1] * 255 << 16 | trunk[2] * 255 << 8 | trunk[3] * 255;
										useSpecular = true;
									}
									break;

								case "Ns":
									if (trunk[1] && !isNaN(Number(trunk[1])))
										specular = Number(trunk[1]) * 0.001;
									if (specular == 0)
										useSpecular = false;
									break;

								case "Kd":
									if (trunk[1] && !isNaN(Number(trunk[1])) && trunk[2] && !isNaN(Number(trunk[2])) && trunk[3] && !isNaN(Number(trunk[3])))
									{
										diffuseColor = trunk[1] * 255 << 16 | trunk[2] * 255 << 8 | trunk[3] * 255;
										useColor = true;
									}
									break;

								case "tr":
								case "d":
									if (trunk[1] && !isNaN(Number(trunk[1])))
										alpha = Number(trunk[1]);
									break;

								case "map_Kd":
									mapkd = parseMapKdString(trunk);
									mapkd = mapkd.replace(/\\/g, "/");
							}
						}
					}
				}

				if (mapkd != "")
				{

					if (useSpecular)
					{

						basicSpecularMethod = new BasicSpecularMethod();
						basicSpecularMethod.specularColor = specularColor;
						basicSpecularMethod.specular = specular;

						var specularData:SpecularData = new SpecularData();
						specularData.alpha = alpha;
						specularData.basicSpecularMethod = basicSpecularMethod;
						specularData.materialID = _lastMtlID;

						if (!_materialSpecularData)
							_materialSpecularData = new Vector.<SpecularData>();

						_materialSpecularData.push(specularData);
					}

					//添加材质依赖性
					addDependency(_lastMtlID, new URLRequest(mapkd));

				}
				else if (useColor && !isNaN(diffuseColor))
				{

					var lm:LoadedMaterial = new LoadedMaterial();
					lm.materialID = _lastMtlID;

					if (alpha == 0)
						trace("Warning: an alpha value of 0 was found in mtl color tag (Tr or d) ref:" + _lastMtlID + ", mesh(es) using it will be invisible!");

					var cm:MaterialBase;
					if (materialMode < 2)
					{
						cm = new ColorMaterial(diffuseColor);
						ColorMaterial(cm).alpha = alpha;
						ColorMaterial(cm).ambientColor = ambientColor;
						ColorMaterial(cm).repeat = true;
						if (useSpecular)
						{
							ColorMaterial(cm).specularColor = specularColor;
							ColorMaterial(cm).specular = specular;
						}
					}
					else
					{
						cm = new ColorMultiPassMaterial(diffuseColor);
						ColorMultiPassMaterial(cm).ambientColor = ambientColor;
						ColorMultiPassMaterial(cm).repeat = true;
						if (useSpecular)
						{
							ColorMultiPassMaterial(cm).specularColor = specularColor;
							ColorMultiPassMaterial(cm).specular = specular;
						}
					}

					lm.cm = cm;
					_materialLoaded.push(lm);

					if (_meshes.length > 0)
						applyMaterial(lm);

				}
			}

			_mtlLibLoaded = true;
		}

		private function parseMapKdString(trunk:Array):String
		{
			var url:String = "";
			var i:int;
			var breakflag:Boolean;

			for (i = 1; i < trunk.length; )
			{
				switch (trunk[i])
				{
					case "-blendu":
					case "-blendv":
					case "-cc":
					case "-clamp":
					case "-texres":
						i += 2; //Skip ahead 1 attribute
						break;
					case "-mm":
						i += 3; //Skip ahead 2 attributes
						break;
					case "-o":
					case "-s":
					case "-t":
						i += 4; //Skip ahead 3 attributes
						continue;
					default:
						breakflag = true;
						break;
				}

				if (breakflag)
					break;
			}

			//Reconstruct URL/filename
			for (i; i < trunk.length; i++)
			{
				url += trunk[i];
				url += " ";
			}

			//Remove the extraneous space and/or newline from the right side
			url = url.replace(/\s+$/, "");

			return url;
		}

		/**
		 * 加载材质
		 * @param mtlurl 材质地址
		 */
		private function loadMtl(mtlurl:String):void
		{
			//添加 材质 资源依赖，暂停解析
			addDependency('mtl', new URLRequest(mtlurl), true);
			pauseAndRetrieveDependencies();
		}

		/**
		 * 应用材质
		 * @param lm 加载到的材质
		 */
		private function applyMaterial(lm:LoadedMaterial):void
		{
			var decomposeID:Array;
			var mesh:Mesh;
			var mat:MaterialBase;
			var j:uint;
			var specularData:SpecularData;

			for (var i:uint = 0; i < _meshes.length; ++i)
			{
				mesh = _meshes[i];
				decomposeID = mesh.material.name.split("~");

				if (decomposeID[0] == lm.materialID)
				{

					if (lm.cm)
					{
						if (mesh.material)
							mesh.material = null;
						mesh.material = lm.cm;

					}
					else if (lm.texture)
					{
						if (materialMode < 2)
						{ // if materialMode is 0 or 1, we create a SinglePass				
							mat = TextureMaterial(mesh.material);
							TextureMaterial(mat).texture = lm.texture;
							TextureMaterial(mat).ambientColor = lm.ambientColor;
							TextureMaterial(mat).alpha = lm.alpha;
							TextureMaterial(mat).repeat = true;

							if (lm.specularMethod)
							{
								// By setting the specularMethod property to null before assigning
								// the actual method instance, we avoid having the properties of
								// the new method being overridden with the settings from the old
								// one, which is default behavior of the setter.
								TextureMaterial(mat).specularMethod = null;
								TextureMaterial(mat).specularMethod = lm.specularMethod;
							}
							else if (_materialSpecularData)
							{
								for (j = 0; j < _materialSpecularData.length; ++j)
								{
									specularData = _materialSpecularData[j];
									if (specularData.materialID == lm.materialID)
									{
										TextureMaterial(mat).specularMethod = null; // Prevent property overwrite (see above)
										TextureMaterial(mat).specularMethod = specularData.basicSpecularMethod;
										TextureMaterial(mat).ambientColor = specularData.ambientColor;
										TextureMaterial(mat).alpha = specularData.alpha;
										break;
									}
								}
							}
						}
						else
						{ //if materialMode==2 this is a MultiPassTexture					
							mat = TextureMultiPassMaterial(mesh.material);
							TextureMultiPassMaterial(mat).texture = lm.texture;
							TextureMultiPassMaterial(mat).ambientColor = lm.ambientColor;
							TextureMultiPassMaterial(mat).repeat = true;

							if (lm.specularMethod)
							{
								// By setting the specularMethod property to null before assigning
								// the actual method instance, we avoid having the properties of
								// the new method being overridden with the settings from the old
								// one, which is default behavior of the setter.
								TextureMultiPassMaterial(mat).specularMethod = null;
								TextureMultiPassMaterial(mat).specularMethod = lm.specularMethod;
							}
							else if (_materialSpecularData)
							{
								for (j = 0; j < _materialSpecularData.length; ++j)
								{
									specularData = _materialSpecularData[j];
									if (specularData.materialID == lm.materialID)
									{
										TextureMultiPassMaterial(mat).specularMethod = null; // Prevent property overwrite (see above)
										TextureMultiPassMaterial(mat).specularMethod = specularData.basicSpecularMethod;
										TextureMultiPassMaterial(mat).ambientColor = specularData.ambientColor;
										break;
									}
								}
							}
						}
					}

					mesh.material.name = decomposeID[1] ? decomposeID[1] : decomposeID[0];
					_meshes.splice(i, 1);
					--i;
				}
			}

			if (lm.cm || mat)
				finalizeAsset(lm.cm || mat);
		}

		/**
		 * 应用材质
		 */
		private function applyMaterials():void
		{
			if (_materialLoaded.length == 0)
				return;

			for (var i:uint = 0; i < _materialLoaded.length; ++i)
				applyMaterial(_materialLoaded[i]);
		}
	}
}

import me.feng3d.materials.MaterialBase;
import me.feng3d.materials.methods.BasicSpecularMethod;
import me.feng3d.textures.Texture2DBase;

class ObjectGroup
{
	/** 对象名 */
	public var name:String;
	/** 组列表（子网格列表） */
	public var groups:Vector.<Group> = new Vector.<Group>();

	public function ObjectGroup()
	{
	}
}

class Group
{
	public var name:String;
	public var materialID:String;
	public var materialGroups:Vector.<MaterialGroup> = new Vector.<MaterialGroup>();

	public function Group()
	{
	}
}

/**
 * 材质组
 */
class MaterialGroup
{
	public var url:String;
	public var faces:Vector.<FaceData> = new Vector.<FaceData>();

	public function MaterialGroup()
	{
	}
}

class SpecularData
{
	public var materialID:String;
	public var basicSpecularMethod:BasicSpecularMethod;
	public var ambientColor:uint = 0xFFFFFF;
	public var alpha:Number = 1;

	public function SpecularData()
	{
	}
}

/**
 * 加载的材质
 */
class LoadedMaterial
{
	public var materialID:String;
	public var texture:Texture2DBase;
	public var cm:MaterialBase;
	public var specularMethod:BasicSpecularMethod;
	public var ambientColor:uint = 0xFFFFFF;
	public var alpha:Number = 1;

	public function LoadedMaterial()
	{
	}
}

/**
 * 面数据
 */
class FaceData
{
	/** 顶点坐标索引数组 */
	public var vertexIndices:Vector.<uint> = new Vector.<uint>();
	/** 顶点uv索引数组 */
	public var uvIndices:Vector.<uint> = new Vector.<uint>();
	/** 顶点法线索引数组 */
	public var normalIndices:Vector.<uint> = new Vector.<uint>();
	/** 顶点Id(原本该值存放了顶点索引、uv索引、发现索引，已经被解析为上面3个数组，剩下的就当做ID使用) */
	public var indexIds:Vector.<String> = new Vector.<String>(); // 

	public function FaceData()
	{
	}
}
