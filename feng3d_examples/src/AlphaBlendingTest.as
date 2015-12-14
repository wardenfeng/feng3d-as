package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.entities.Sprite3D;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.test.TestBase;
	import me.feng3d.utils.Cast;

	/**
	 *
	 * @author feng 2015-8-29
	 */
	public class AlphaBlendingTest extends TestBase
	{
		//billboard texture for red light
		private var RedLight:String = "embeds/redlight.png";

		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;

		//material objects
		private var redLightMaterial:TextureMaterial;

		public function AlphaBlendingTest()
		{
			resourceList = [RedLight];
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
			initListeners();
		}

		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			view = new View3D();

			view.backgroundColor = 0xffff00;

			scene = view.scene;
			camera = view.camera;

			camera.lens.far = 5000;
			camera.z = -200;
			camera.y = 160;

			camera.lookAt(new Vector3D());

			addChild(view);
		}

		/**
		 * Initialise the materials
		 */
		private function initMaterials():void
		{
			//red light material
			redLightMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[RedLight]));
			redLightMaterial.alphaBlending = true;
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			var sprite3D:Sprite3D = new Sprite3D(redLightMaterial, 200, 200)
			scene.addChild(sprite3D);
		}

		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			view.render();
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
