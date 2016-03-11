package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.debug.Trident;
	import me.feng3d.entities.Elevation;
	import me.feng3d.entities.Mesh;
	import me.feng3d.materials.ColorMaterial;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.materials.methods.TerrainDiffuseMethod;
	import me.feng3d.primitives.WireframeGeometry;
	import me.feng3d.test.TestBase;
	import me.feng3d.utils.Cast;

	[SWF(width = "800", height = "600", backgroundColor = "#000000", frameRate = "60", quality = "LOW")]
	public class TerrainTest extends TestBase
	{
		// terrain height map
		private var HeightMap:String = "embeds/terrain/terrain_heights.jpg";

		// terrain texture map
		private var Albedo:String = "embeds/terrain/terrain_diffuse.jpg";

		// terrain normal map
		private var Normals:String = "embeds/terrain/terrain_normals.jpg";

		//splat texture maps
		private var Grass:String = "embeds/terrain/grass.jpg";
		private var Rock:String = "embeds/terrain/rock.jpg";
		private var Beach:String = "embeds/terrain/beach.jpg";

		//splat blend map
		private var Blend:String = "embeds/terrain/terrain_splats.png";

		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;

		//material objects
		private var terrainMethod:TerrainDiffuseMethod;
		private var terrainMaterial:TextureMaterial;

		private var terrain:Elevation;

		/** 顶视图摄像机 */
		private var topCamera:Camera3D;

		/**
		 * Constructor
		 */
		public function TerrainTest()
		{
			resourceList = [HeightMap, Albedo, Normals, Grass, Rock, Beach, Blend];
			super();
		}

		/**
		 * Global initialise function
		 */
		public function init():void
		{
			initEngine();
			initMaterials();
			initObjects();
			initMyCamera();
			initSmallMap();
			initListeners();
		}

		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			camera = new Camera3D();
			view = new View3D(null, camera);
			scene = view.scene;

			camera.lens.near = 0.01;
			camera.lens.far = 4000;

			camera.transform3D.y = 300;

			addChild(view);
		}

		/**
		 * Initialise the material
		 */
		private function initMaterials():void
		{
			terrainMethod = new TerrainDiffuseMethod( //
				[Cast.bitmapTexture(resourceDic[Beach]), Cast.bitmapTexture(resourceDic[Grass]), Cast.bitmapTexture(resourceDic[Rock])], //
				Cast.bitmapTexture(resourceDic[Blend]), Vector.<Number>([1, 50, 150, 100]));

			terrainMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[Albedo]));
			terrainMaterial.diffuseMethod = terrainMethod;
			terrainMaterial.normalMap = Cast.bitmapTexture(resourceDic[Normals]);
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			//create mountain like terrain
			terrain = new Elevation(terrainMaterial, Cast.bitmapData(resourceDic[HeightMap]), 5000, 1300, 5000, 30, 30);
			scene.addChild(terrain);

			//将需要以线框查看的模型顶点索引以及顶点数据传入即可
			var _wireframeTriangle:WireframeGeometry = new WireframeGeometry();
			_wireframeTriangle.setDrawGeometry(terrain.geometry);
			scene.addChild(_wireframeTriangle);
		}

		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			onResize();
		}

		private var keyDic:Dictionary = new Dictionary();
		private var topRightView:View3D;

		protected function onKeyDown(event:KeyboardEvent):void
		{
			keyDic[event.keyCode] = true;
		}

		protected function onKeyUp(event:KeyboardEvent):void
		{
			keyDic[event.keyCode] = false;
		}

		protected function onMouseMove(event:MouseEvent):void
		{
			view.camera.transform3D.rotationX = (2 * event.stageY / stage.stageHeight - 1) * 90;
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			var positionStep:Number = 5;

			if (keyDic[Keyboard.W])
			{
				view.camera.transform3D.x += view.camera.transform3D.forwardVector.x * positionStep;
				view.camera.transform3D.z += view.camera.transform3D.forwardVector.z * positionStep;
			}
			if (keyDic[Keyboard.S])
			{
				view.camera.transform3D.x -= view.camera.transform3D.forwardVector.x * positionStep;
				view.camera.transform3D.z -= view.camera.transform3D.forwardVector.z * positionStep;
			}
			if (keyDic[Keyboard.A])
			{
				view.camera.transform3D.rotationY--;
			}
			if (keyDic[Keyboard.D])
			{
				view.camera.transform3D.rotationY++;
			}

			//set the camera height based on the terrain (with smoothing)
			camera.transform3D.y += 0.2 * (terrain.getHeightAt(camera.transform3D.x, camera.transform3D.z) + 50 - camera.transform3D.y);

			topCamera.transform3D.x = view.camera.transform3D.x;
			topCamera.transform3D.y = view.camera.transform3D.y + 500;
			topCamera.transform3D.z = view.camera.transform3D.z;
			topCamera.transform3D.lookAt(new Vector3D(topCamera.transform3D.x, 0, topCamera.transform3D.z), new Vector3D(0, 0, 1));

			view.render();
			topRightView.render();
		}

		/** 设置摄像机网格 */
		private function initMyCamera():void
		{
			var obj3d:Mesh = new Mesh();
			obj3d.name = "cameraMesh";
			obj3d.geometry = cameraGeometry;
			obj3d.material = new ColorMaterial(0x00ff00);
			obj3d.transform3D.scale(5);
			var trident:Trident = new Trident();
			trident.transform3D.y = -2;
			obj3d.addChild(trident);
			view.camera.addChild(obj3d);

			view.scene.addChild(view.camera);
		}

		/** 获取摄像机几何结构 */
		public function get cameraGeometry():Geometry
		{
			var indexBuffer:Vector.<uint> = Vector.<uint>([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]);
			var positionsBuffer:Vector.<Number> = Vector.<Number>([0, 0, -25, -10, -10, 0, 10, -10, 0, 0, 0, -25, 10, -10, 0, 10, 10, 0, 0, 0, -25, 10, 10, 0, -10, 10, 0, 0, 0, -25, -10, 10, 0, -10, -10, 0, -10, -10, 0, 0, 0, 0, 10, -10, 0, 10, -10, 0, 0, 0, 0, 10, 10, 0, 10, 10, 0, 0, 0, 0, -10, 10, 0, -10, 10, 0, 0, 0, 0, -10, -10, 0]);
			var uvBuffer:Vector.<Number> = Vector.<Number>([0.5, 0, 0, 1, 1, 1, 0.5, 0, 0, 1, 1, 1, 0.5, 0, 0, 1, 1, 1, 0.5, 0, 0, 1, 1, 1, 0, 0, 0.5, 0.5, 1, 0, 1, 0, 0.5, 0.5, 1, 1, 1, 1, 0.5, 0.5, 0, 1, 0, 1, 0.5, 0.5, 0, 0]);

			var geometry:Geometry = new Geometry();
			var subGeometry:SubGeometry = new SubGeometry();
			subGeometry.numVertices = positionsBuffer.length / 3;
			subGeometry.updateIndexData(indexBuffer);
			subGeometry.updateVertexPositionData(positionsBuffer);
			subGeometry.updateUVData(uvBuffer);
			geometry.addSubGeometry(subGeometry);

			return geometry;
		}

		/** 初始化右上角小地图 */
		private function initSmallMap():void
		{
			//俯视图
			topCamera = new Camera3D();
			topCamera.name = "topCamera";

			topRightView = new View3D(view.scene, topCamera);
			topRightView.name = "smallView3D";
			addChild(topRightView);
			topRightView.width = topRightView.height = 100;
			topRightView.x = stage.stageWidth - topRightView.width;
			topRightView.backgroundColor = 0x666666;
		}

		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
	}
}


