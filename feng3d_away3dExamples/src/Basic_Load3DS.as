/*

3ds file loading example in Away3d

Demonstrates:

How to use the Loader3D object to load an embedded internal 3ds model.
How to map an external asset reference inside a file to an internal embedded asset.
How to extract material data and use it to set custom material properties on a model.

Code by Rob Bateman
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk

This code is distributed under the MIT License

Copyright (c) The Away Foundation http://www.theawayfoundation.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	import br.com.stimuli.loading.BulkLoader;

	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.controllers.HoverController;
	import me.feng3d.debug.AwayStats;
	import me.feng3d.debug.Debug;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.AssetEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.materials.lightpickers.StaticLightPicker;
	import me.feng3d.materials.methods.FilteredShadowMapMethod;
	import me.feng3d.parsers.Max3DSParser;
	import me.feng3d.primitives.PlaneGeometry;
	import me.feng3d.test.TestBase;
	import me.feng3d.utils.Cast;

	[SWF(backgroundColor = "#000000", frameRate = "30", quality = "LOW")]
	public class Basic_Load3DS extends TestBase
	{
		//signature swf
		public static var SignatureSwf:String = "embeds/signature.swf";

		//solider ant texture
		public static var AntTexture:String = "embeds/soldier_ant.jpg";

		//solider ant model
		public static var AntModel:String = "embeds/soldier_ant.3ds";

		//ground texture
		public static var SandTexture:String = "embeds/CoarseRedSand.jpg";

		//engine variables
		private var _view:View3D;
		private var _cameraController:HoverController;

		//signature variables
		private var _signature:Sprite;
		private var _signatureBitmap:Bitmap;

		//light objects
		private var _light:DirectionalLight;
		private var _lightPicker:StaticLightPicker;
		private var _direction:Vector3D;

		//material objects
		private var _groundMaterial:TextureMaterial;

		//scene objects
		private var _loader:ObjectContainer3D;
		private var _ground:Mesh;

		//navigation variables
		private var _move:Boolean = false;
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _lastMouseX:Number;
		private var _lastMouseY:Number;

		/**
		 * Constructor
		 */
		public function Basic_Load3DS()
		{
			resourceList = [SignatureSwf, AntTexture, {url: AntModel, type: BulkLoader.TYPE_BINARY}, SandTexture];
			super();
			Debug.agalDebug = true;
		}

		/**
		 * Global initialise function
		 */
		public function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			//setup the view
			_view = new View3D();
			_view.addSourceURL("srcview/index.html");
			addChild(_view);

			//setup the camera for optimal shadow rendering
			_view.camera.lens.far = 2100;

			//setup controller to be used on the camera
			_cameraController = new HoverController(_view.camera, null, 45, 20, 1000, 10);

			//setup the lights for the scene
			_light = new DirectionalLight(-1, -1, 1);
			_direction = new Vector3D(-1, -1, 1);
			_lightPicker = new StaticLightPicker([_light]);
			_view.scene.addChild(_light);

			//setup materials
			_groundMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[SandTexture]));
			_groundMaterial.shadowMethod = new FilteredShadowMapMethod(_light);
			_groundMaterial.lightPicker = _lightPicker;
			_groundMaterial.specular = 0;
			_ground = new Mesh(new PlaneGeometry(1000, 1000), _groundMaterial);
			_view.scene.addChild(_ground);

			//setup the scene
			_loader = new ObjectContainer3D();
			_loader.scale(300);
			_loader.z = -200;
			_view.scene.addChild(_loader);

			//parse hellknight mesh
			var parser:Max3DSParser = new Max3DSParser();
			parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			parser.parseAsync(resourceDic[AntModel]);

			//add signature
			_signature = resourceDic[SignatureSwf];
			_signatureBitmap = new Bitmap(new BitmapData(_signature.width, _signature.height, true, 0));
			stage.quality = StageQuality.HIGH;
			_signatureBitmap.bitmapData.draw(_signature);
			stage.quality = StageQuality.LOW;
			addChild(_signatureBitmap);

			//add stats panel
			addChild(new AwayStats(_view));

			//add listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			if (_move)
			{
				_cameraController.panAngle = 0.3 * (stage.mouseX - _lastMouseX) + _lastPanAngle;
				_cameraController.tiltAngle = 0.3 * (stage.mouseY - _lastMouseY) + _lastTiltAngle;
			}

			_direction.x = -Math.sin(getTimer() / 4000);
			_direction.z = -Math.cos(getTimer() / 4000);
			_light.direction = _direction;

			_view.render();
		}

		/**
		 * Listener function for asset complete event on loader
		 */
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.MESH)
			{
				var mesh:Mesh = event.asset as Mesh;
				mesh.castsShadows = true;
				_loader.addChild(mesh);
			}
			else if (event.asset.assetType == AssetType.MATERIAL)
			{
				var material:TextureMaterial = event.asset as TextureMaterial;
				material.texture = Cast.bitmapTexture(resourceDic[AntTexture]);
				material.shadowMethod = new FilteredShadowMapMethod(_light);
				material.lightPicker = _lightPicker;
				material.gloss = 30;
				material.specular = 1;
				material.ambientColor = 0x303040;
				material.ambient = 1;
			}
		}

		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			_lastPanAngle = _cameraController.panAngle;
			_lastTiltAngle = _cameraController.tiltAngle;
			_lastMouseX = stage.mouseX;
			_lastMouseY = stage.mouseY;
			_move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			_move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			_move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
			_signatureBitmap.y = stage.stageHeight - _signature.height;
		}
	}
}
