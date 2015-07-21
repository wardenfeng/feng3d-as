package
{
	import com.adobe.utils.PerspectiveMatrix3D;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;

	import base.BaseMesh;

	import colorTerrain.ColorTerrainGeometry;
	import colorTerrain.ColorTerrainMaterial;

	import me.feng.core.GlobalDispatcher;
	import me.feng.load.Load;
	import me.feng.load.LoadEvent;
	import me.feng.load.LoadEventData;
	import me.feng.load.data.LoadTaskItem;
	import me.feng3d.debug.Debug;
	import me.feng3d.utils.Cast;

	/**
	 * 通过顶点颜色渲染地形
	 * @author warden_feng 2014-10-24
	 */
	[SWF(width = "640", height = "362", frameRate = "60")]
	public class ColorTerrainShaderTest extends Sprite
	{
		private var context:Context3D;
		private var stage3D:Stage3D;

		private var baseGem:ColorTerrainGeometry;
		private var baseMesh:BaseMesh;

		private const CONTEXT_WIDTH:Number = 670;
		private const CONTEXT_HEIGHT:Number = 380;

		private const DEGS_TO_RADIANS:Number = Math.PI / 180;

		//资源根路径
		private var rootPath:String = "http://images.feng3d.me/feng3dDemo/assets/";
		//splat texture maps
		private var grassPath:String = "embeds/terrain/grass.jpg";
		private var rockPath:String = "embeds/terrain/rock.jpg";
		private var beachPath:String = "embeds/terrain/beach.jpg";
		/** 贴图字典 */
		private var textureDic:Dictionary;

		public function ColorTerrainShaderTest()
		{
			Debug.agalDebug = true;
			MyCC.initFlashConsole(this);

			loadTextures();
		}

		/**
		 * 加载纹理资源
		 */
		private function loadTextures():void
		{
			textureDic = new Dictionary();

			Load.init();

			//加载资源
			var loadObj:LoadEventData = new LoadEventData();
			loadObj.urls = [rootPath + grassPath, rootPath + rockPath, rootPath + beachPath];
			loadObj.singleComplete = singleGeometryComplete;
			loadObj.allItemsLoaded = allItemsLoaded;
			GlobalDispatcher.instance.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, loadObj));
		}

		/** 单个图片加载完毕 */
		private function singleGeometryComplete(loadData:LoadEventData, loadTaskItem:LoadTaskItem):void
		{
			var bitmap:Bitmap = loadTaskItem.loadingItem.content;

			var path:String = loadTaskItem.url;
			path = path.substr(rootPath.length);

			textureDic[path] = bitmap;
		}

		/**
		 * 处理全部加载完成事件
		 */
		private function allItemsLoaded(... args):void
		{
			init();
		}

		private function init():void
		{
			// Set the default stage behavior
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// Request a 3D context instance
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, contextReady, false, 0, true);
			stage3D.requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.STANDARD);

			trace("Awaiting context...");
		}

		private function contextReady(event:Event):void
		{
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, contextReady);
			trace("Got context!");

			// Get the new context
			context = stage3D.context3D;

			// Configure back buffer
			context.configureBackBuffer(CONTEXT_WIDTH, CONTEXT_HEIGHT, 2, true);
			stage3D.x = stage3D.y = 0;

			// Prepare vertex data
			var vertexPositionData:Vector.<Number> = Vector.<Number>([ //
				-0.5, -0.5, 0, //<- 1st vertex x,y,z,
				-0.5, 0.5, 0, //<- 2nd vertex x,y,z,
				0.5, 0.0, 0 //<- 3rd vertex x,y,z,
				]);
			var vertexColorData:Vector.<Number> = Vector.<Number>([ //
				1.0, 0.0, 0.0, //<- 1st vertex r,g,b
				0.0, 1.0, 0.0, //<- 2nd vertex r,g,b
				0.0, 0.0, 1.0 //<- 3rd vertex r,g,b
				]);

			var vertexUVData:Vector.<Number> = Vector.<Number>([ //
				1.0, 0.0, //<- 1st vertex u,v
				0.0, 1.0, //<- 2nd vertex u,v
				0.0, 0.0 //<- 3rd vertex u,v
				]);

			// Connect the vertices into a triangle (in counter-clockwise order)
			var indexData:Vector.<uint> = Vector.<uint>([0, 1, 2]);

			//创建几何体
			baseGem = new ColorTerrainGeometry();
			baseGem.setGeometry(vertexPositionData, vertexColorData, indexData);
			baseGem.vertexUVData = vertexUVData;

			//创建材质
			var _splats:Array = [Cast.bitmapTexture(textureDic[beachPath]), Cast.bitmapTexture(textureDic[grassPath]), Cast.bitmapTexture(textureDic[rockPath])];
			var colorTerrainMaterial:ColorTerrainMaterial = new ColorTerrainMaterial(_splats);

			//创建网格
			baseMesh = new BaseMesh(baseGem, colorTerrainMaterial);

			// ...and start rendering frames!
			addEventListener(Event.ENTER_FRAME, renderFrame, false, 0, true);
		}

		private function renderFrame(e:Event):void
		{
			// Clear away the old frame render
			context.clear();

			// Calculate the view matrix, and run the shader program!
			baseMesh.render(context, makeViewMatrix());

			// Show the newly rendered frame on screen
			context.present();
		}

		public function makeViewMatrix():Matrix3D
		{
			var aspect:Number = CONTEXT_WIDTH / CONTEXT_HEIGHT;
			var zNear:Number = 0.01;
			var zFar:Number = 1000;
			var fov:Number = 45 * DEGS_TO_RADIANS;

			var view:PerspectiveMatrix3D = new PerspectiveMatrix3D();
			view.perspectiveFieldOfViewLH(fov, aspect, zNear, zFar);

			var m:Matrix3D = new Matrix3D();
//			m.appendRotation(getTimer() / 30, Vector3D.Z_AXIS);
			m.appendTranslation(0, 0, 2);
			m.append(view);

			return m;
		}
	}
}
