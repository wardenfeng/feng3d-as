/*

3D Head scan example in Away3d

Demonstrates:

How to use the AssetLibrary to load an internal OBJ model.
How to set custom material methods on a model.
How a natural skin texture can be achived with sub-surface diffuse shading and fresnel specular shading.

Code by Rob Bateman & David Lenaerts
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk
david.lenaerts@gmail.com
http://www.derschmale.com

Model by Lee Perry-Smith, based on a work at triplegangers.com,  licensed under CC

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
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.controllers.HoverController;
	import me.feng3d.debug.AwayStats;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.AssetEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.lights.PointLight;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.materials.lightpickers.StaticLightPicker;
	import me.feng3d.materials.methods.BasicDiffuseMethod;
	import me.feng3d.materials.methods.BasicSpecularMethod;
	import me.feng3d.materials.methods.FresnelSpecularMethod;
	import me.feng3d.materials.methods.SubsurfaceScatteringDiffuseMethod;
	import me.feng3d.parsers.OBJParser;
	import me.feng3d.primitives.WireframeGeometry;
	import me.feng3d.test.TestBase;
	import me.feng3d.utils.Cast;

	[SWF(backgroundColor = "#000000", frameRate = "30", quality = "LOW")]

	public class Intermediate_Head extends TestBase
	{
		//signature swf
		public var SignatureSwf:String = "embeds/signature.swf";

		//Infinite, 3D head model
		private var HeadModel:String = "embeds/head.obj";

		//Diffuse map texture
		private var Diffuse:String = "embeds/head_diffuse.jpg";

		//Specular map texture
		private var Specular:String = "embeds/head_specular.jpg";

		//Normal map texture
		private var Normal:String = "embeds/head_normals.jpg";

		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:HoverController;

		//signature variables
		private var Signature:Sprite;
		private var SignatureBitmap:Bitmap;

		//material objects
		private var headMaterial:TextureMaterial;
		private var subsurfaceMethod:SubsurfaceScatteringDiffuseMethod;
		private var fresnelMethod:FresnelSpecularMethod;
		private var diffuseMethod:BasicDiffuseMethod;
		private var specularMethod:BasicSpecularMethod;

		//scene objects
		private var light:PointLight;
		private var lightPicker:StaticLightPicker;
		private var headModel:Mesh;
		private var advancedMethod:Boolean = true;

		//navigation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;

		/**
		 * Constructor
		 */
		public function Intermediate_Head()
		{
			resourceList = [ //

				SignatureSwf, HeadModel, //
				Diffuse, Specular, Normal //
				];
			super();
		}

		/**
		 * Global initialise function
		 */
		public function init():void
		{
			initEngine();
			initLights();
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

			scene = new Scene3D();

			camera = new Camera3D();

			view = new View3D();
			view.antiAlias = 4;
			view.scene = scene;
			view.camera = camera;

			//setup controller to be used on the camera
			cameraController = new HoverController(camera, null, 45, 10, 800);

			view.addSourceURL("srcview/index.html");
			addChild(view);

			//add signature
			Signature = resourceDic[SignatureSwf];
			SignatureBitmap = new Bitmap(new BitmapData(Signature.width, Signature.height, true, 0));
			stage.quality = StageQuality.HIGH;
			SignatureBitmap.bitmapData.draw(Signature);
			stage.quality = StageQuality.LOW;
			addChild(SignatureBitmap);

			addChild(new AwayStats(view));
		}

		/**
		 * Initialise the lights in a scene
		 */
		private function initLights():void
		{
			light = new PointLight();
			light.x = 15000;
			light.z = 15000;
			light.color = 0xffddbb;
			light.ambient = 1;
			lightPicker = new StaticLightPicker([light]);

			scene.addChild(light);
		}

		/**
		 * Initialise the materials
		 */
		private function initMaterials():void
		{
			//setup custom bitmap material
			headMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[Diffuse]));
			headMaterial.normalMap = Cast.bitmapTexture(resourceDic[Normal]);
			headMaterial.specularMap = Cast.bitmapTexture(resourceDic[Specular]);
			headMaterial.lightPicker = lightPicker;
			headMaterial.gloss = 10;
			headMaterial.specular = 3;
			headMaterial.ambientColor = 0x303040;
			headMaterial.ambient = 1;

			//create subscattering diffuse method
//			subsurfaceMethod = new SubsurfaceScatteringDiffuseMethod(2048, 2);
//			subsurfaceMethod.scatterColor = 0xff7733;
//			subsurfaceMethod.scattering = 0.05;
//			subsurfaceMethod.translucency = 4;
//			headMaterial.diffuseMethod = subsurfaceMethod;

			//create fresnel specular method
			fresnelMethod = new FresnelSpecularMethod(true);
			headMaterial.specularMethod = fresnelMethod;

			//add default diffuse method
			diffuseMethod = new BasicDiffuseMethod();

			//add default specular method
			specularMethod = new BasicSpecularMethod();
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			var parser:OBJParser = new OBJParser();
			parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			parser.parseAsync(resourceDic[HeadModel]);
		}

		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			if (move)
			{
				cameraController.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}

			light.x = Math.sin(getTimer() / 10000) * 15000;
			light.y = 1000;
			light.z = Math.cos(getTimer() / 10000) * 15000;

			view.render();
		}

		/**
		 * Listener function for asset complete event on loader
		 */
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.MESH)
			{
				headModel = event.asset as Mesh;
				headModel.geometry.scale(100); //TODO scale cannot be performed on mesh when using sub-surface diffuse method
//				headModel.y = -50;
//				headModel.rotationY = 180;
				headModel.material = headMaterial;

				//将需要以线框查看的模型顶点索引以及顶点数据传入即可
				var _wireframeTriangle:WireframeGeometry = new WireframeGeometry();
//				_wireframeTriangle.setDrawGeometry(headModel.geometry);
//				scene.addChild(_wireframeTriangle);

				scene.addChild(headModel);
			}
		}

		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * Key up listener for swapping between standard diffuse & specular shading, and sub-surface diffuse shading with fresnel specular shading
		 */
		private function onKeyUp(event:KeyboardEvent):void
		{
			advancedMethod = !advancedMethod;

			headMaterial.gloss = (advancedMethod) ? 10 : 50;
			headMaterial.specular = (advancedMethod) ? 3 : 1;
			headMaterial.diffuseMethod = (advancedMethod) ? subsurfaceMethod : diffuseMethod;
			headMaterial.specularMethod = (advancedMethod) ? fresnelMethod : specularMethod;
		}

		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			SignatureBitmap.y = stage.stageHeight - Signature.height;
		}
	}
}
