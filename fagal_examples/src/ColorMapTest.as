package
{
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;

	import base.BaseMesh;

	import colorMap.ColorMapMaterial;

	import colorTerrain.ColorTerrainGeometry;

	import me.feng3d.debug.Debug;

	/**
	 * 通过顶点颜色渲染地形
	 * @author feng 2014-10-24
	 */
	[SWF(width = "800", height = "600", frameRate = "60")]
	public class ColorMapTest extends TestBase
	{
		private var context:Context3D;
		private var stage3D:Stage3D;

		private var baseGem:ColorTerrainGeometry;
		private var baseMesh:BaseMesh;

		private const CONTEXT_WIDTH:Number = 670;
		private const CONTEXT_HEIGHT:Number = 380;

		public function ColorMapTest()
		{
			resourceList = [];
			super();
		}

		/**
		 * Global initialise function
		 */
		public function init():void
		{
			Debug.agalDebug = true;
			MyCC.initFlashConsole(this);

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
			baseGem.setGeometry(vertexColorData, vertexColorData, indexData);
			baseGem.vertexUVData = vertexUVData;

			//创建材质
			var colorMapMaterial:ColorMapMaterial = new ColorMapMaterial();

			//创建网格
			baseMesh = new BaseMesh(baseGem, colorMapMaterial);

			// ...and start rendering frames!
			addEventListener(Event.ENTER_FRAME, renderFrame, false, 0, true);
		}

		private function renderFrame(e:Event):void
		{
			// Clear away the old frame render
			context.clear();

			// Calculate the view matrix, and run the shader program!
			baseMesh.render(context, null);

			// Show the newly rendered frame on screen
			context.present();
		}
	}
}
