package
{
	import com.adobe.utils.PerspectiveMatrix3D;

	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	import base.BaseGeometry;
	import base.BaseMesh;

	/**
	 * 测试基础渲染函数
	 * @author warden_feng 2014-10-24
	 */
	[SWF(width = "640", height = "362", frameRate = "60")]
	public class BaseShaderTest extends TestBase
	{
		private var context:Context3D;
		private var stage3D:Stage3D;

		private var baseGem:BaseGeometry;
		private var baseMesh:BaseMesh;

		private const CONTEXT_WIDTH:Number = 670;
		private const CONTEXT_HEIGHT:Number = 380;

		private const DEGS_TO_RADIANS:Number = Math.PI / 180;

		public function BaseShaderTest()
		{
			resourceList = [];
			super();
		}

		/**
		 * Global initialise function
		 */
		public function init():void
		{
			// Set the default stage behavior
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// Request a 3D context instance
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, contextReady, false, 0, true);
			stage3D.requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.STANDARD);

			logger("Awaiting context...");
		}

		private function contextReady(event:Event):void
		{
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, contextReady);
			logger("Got context!");

			// Get the new context
			context = stage3D.context3D;

			// Configure back buffer
			context.configureBackBuffer(CONTEXT_WIDTH, CONTEXT_HEIGHT, 2, true);
			stage3D.x = stage3D.y = 0;

			// Prepare vertex data
			var vertexPositionData:Vector.<Number> = Vector.<Number>([-0.5, -0.5, 0, //<- 1st vertex x,y,z,
				-0.5, 0.5, 0, //<- 2nd vertex x,y,z,
				0.5, 0.0, 0 //<- 3rd vertex x,y,z,
				]);
			var vertexColorData:Vector.<Number> = Vector.<Number>([1.0, 0.0, 0.0, //<- 1st vertex r,g,b
				0.0, 1.0, 0.0, //<- 2nd vertex r,g,b
				0.0, 0.0, 1.0 //<- 3rd vertex r,g,b
				]);

			// Connect the vertices into a triangle (in counter-clockwise order)
			var indexData:Vector.<uint> = Vector.<uint>([0, 1, 2]);

			baseGem = new BaseGeometry();
			baseGem.setGeometry(vertexPositionData, vertexColorData, indexData);
			baseMesh = new BaseMesh(baseGem);

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
			m.appendRotation(getTimer() / 30, Vector3D.Z_AXIS);
			m.appendTranslation(0, 0, 2);
			m.append(view);

			return m;
		}
	}
}
