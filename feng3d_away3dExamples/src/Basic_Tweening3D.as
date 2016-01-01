/*

3D Tweening example in Away3d

Demonstrates:

How to use Tweener within a 3D coordinate system.
How to create a 3D mouse event listener on a scene object.
How to return the scene coordinates of a mouse click on the surface of a scene object.

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
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;

	import me.feng3d.containers.View3D;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.MouseEvent3D;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.primitives.CubeGeometry;
	import me.feng3d.primitives.PlaneGeometry;
	import me.feng3d.test.TestBase;
	import me.feng3d.utils.Cast;

	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW")]

	public class Basic_Tweening3D extends TestBase
	{
		//plane texture
		public static var FloorDiffuse:String = "embeds/floor_diffuse.jpg";

		//cube texture jpg
		public static var TrinketDiffuse:String = "embeds/trinket_diffuse.jpg";

		//engine variables
		private var _view:View3D;

		//scene objects
		private var _plane:Mesh;
		private var _cube:Mesh;

		/**
		 * Constructor
		 */
		public function Basic_Tweening3D()
		{
			resourceList = [FloorDiffuse, TrinketDiffuse];
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
			_view.camera.transform3D.y = 500;
			_view.camera.transform3D.lookAt(new Vector3D());

			//setup the scene
			_cube = new Mesh(new CubeGeometry(100, 100, 100, 1, 1, 1, false), new TextureMaterial(Cast.bitmapTexture(resourceDic[TrinketDiffuse])));
			_cube.transform3D.y = 50;
			_view.scene.addChild(_cube);

			_plane = new Mesh(new PlaneGeometry(700, 700), new TextureMaterial(Cast.bitmapTexture(resourceDic[FloorDiffuse])));
//			_plane.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
			_plane.mouseEnabled = true;
			_view.scene.addChild(_plane);

			//add mouse listener
			_plane.addEventListener(MouseEvent3D.MOUSE_UP, _onMouseUp);

			//initialize Tweener curve modifiers
			CurveModifiers.init();

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
			_view.render();
		}

		/**
		 * mesh listener for mouse up interaction
		 */
		private function _onMouseUp(ev:MouseEvent3D):void
		{
			var scenePosition:Vector3D = ev.collider.scenePosition;
			Tweener.addTween(_cube, {time: 0.5, x: scenePosition.x, z: scenePosition.z, _bezier: {x: _cube.transform3D.x, z: scenePosition.z}});
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
