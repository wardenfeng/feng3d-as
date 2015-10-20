package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng.core.GlobalDispatcher;
	import me.feng3d.containers.View3D;
	import me.feng3d.debug.Debug;
	import me.feng3d.entities.Mesh;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.primitives.PlaneGeometry;
	import me.feng3d.utils.MaterialUtils;

	/**
	 * 测试加载纹理材质
	 * @author feng 2014-7-7
	 */
	[SWF(width = "640", height = "640", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class TestLoadTexture extends TestBase
	{
		private var _view:View3D;

		private var mesh:Mesh;

		private var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		public function TestLoadTexture()
		{
			super();
		}

		public function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_view = new View3D(null, null);
			addChild(_view);

			Debug.agalDebug = true;

			//setup the camera
			_view.camera.z = -100;
			_view.camera.y = 50;
			_view.camera.lookAt(new Vector3D());

			var textureMaterial:TextureMaterial = MaterialUtils.createTextureMaterial("img/photo.jpg");

			//setup the scene
			mesh = new Mesh(new PlaneGeometry(), textureMaterial);

			_view.scene.addChild(mesh);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
		 * render loop
		 */
		private function onEnterFrame(e:Event):void
		{
			mesh.rotationY += 1;

			_view.render();
		}
	}
}
