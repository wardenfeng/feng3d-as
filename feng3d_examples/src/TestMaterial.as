package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng3d.containers.View3D;
	import me.feng3d.debug.Debug;
	import me.feng3d.entities.Mesh;
	import me.feng3d.materials.ColorMaterial;
	import me.feng3d.primitives.PlaneGeometry;
	import me.feng3d.test.TestBase;

	/**
	 * 测试颜色材质
	 * @author feng 2014-3-27
	 */
	[SWF(width = "640", height = "640", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class TestMaterial extends TestBase
	{
		private var _view:View3D;

		private var mesh:Mesh;

		public function TestMaterial()
		{
			super();
		}

		public function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_view = new View3D();
			addChild(_view);

			Debug.agalDebug = true;

			//setup the camera
			_view.camera.transform3D.z = -600;
			_view.camera.transform3D.y = 500;
			_view.camera.transform3D.lookAt(new Vector3D());

			//setup the scene
//			mesh = new Mesh(new PlaneGeometry(700, 700), MaterialUtils.createTextureMaterial("img/photo.jpg"));
			mesh = new Mesh(new PlaneGeometry(700, 700), new ColorMaterial(0xff0000));

			mesh.geometry.scaleUV(2, 2);
			mesh.material.repeat = true;
			mesh.material.smooth = true;
			mesh.material.mipmap = false;

			_view.scene.addChild(mesh);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
		 * render loop
		 */
		private function onEnterFrame(e:Event):void
		{
			mesh.transform3D.rotationY += 1;

			_view.render();
		}
	}
}
