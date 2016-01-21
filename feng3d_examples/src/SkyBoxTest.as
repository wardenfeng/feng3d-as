package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng3d.containers.View3D;
	import me.feng3d.entities.SkyBox;
	import me.feng3d.test.TestBase;
	import me.feng3d.textures.BitmapCubeTexture;
	import me.feng3d.utils.Cast;

	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW")]

	public class SkyBoxTest extends TestBase
	{
		// Environment map.
		private var EnvPosX:String = "embeds/skybox/snow_positive_x.jpg";
		private var EnvPosY:String = "embeds/skybox/snow_positive_y.jpg";
		private var EnvPosZ:String = "embeds/skybox/snow_positive_z.jpg";
		private var EnvNegX:String = "embeds/skybox/snow_negative_x.jpg";
		private var EnvNegY:String = "embeds/skybox/snow_negative_y.jpg";
		private var EnvNegZ:String = "embeds/skybox/snow_negative_z.jpg";

		//engine variables
		private var _view:View3D;

		//scene objects
		private var _skyBox:SkyBox;

		/**
		 * Constructor
		 */
		public function SkyBoxTest()
		{
			resourceList = [EnvPosX, EnvPosY, EnvPosZ, EnvNegX, EnvNegY, EnvNegZ]
			super();
		}

		public function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			//setup the view
			_view = new View3D();
			addChild(_view);

			//setup the camera
			_view.camera.transform3D.z = -600;
			_view.camera.transform3D.y = 0;
			_view.camera.lens.far = 10000;
			_view.camera.lens.near = 0.01;
			_view.camera.transform3D.lookAt(new Vector3D());

			//setup the cube texture
			var cubeTexture:BitmapCubeTexture = new BitmapCubeTexture( //
				Cast.bitmapData(resourceDic[EnvPosX]), Cast.bitmapData(resourceDic[EnvNegX]), //
				Cast.bitmapData(resourceDic[EnvPosY]), Cast.bitmapData(resourceDic[EnvNegY]), //
				Cast.bitmapData(resourceDic[EnvPosZ]), Cast.bitmapData(resourceDic[EnvNegZ]) //
				);

			_skyBox = new SkyBox(cubeTexture);
			_view.scene.addChild(_skyBox);

			//setup the render loop
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		/**
		 * render loop
		 */
		private function _onEnterFrame(e:Event):void
		{
			_view.camera.transform3D.position = new Vector3D();
			_view.camera.transform3D.rotationY += 0.5 * (stage.mouseX - stage.stageWidth / 2) / 800;
			_view.camera.transform3D.moveBackward(600);

			_view.render();
		}

		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
	}
}
