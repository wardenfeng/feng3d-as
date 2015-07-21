package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng3d.containers.View3D;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.pick.PickingColliderType;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.MouseEvent3D;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;

	import parser.ObjParser1;

	/**
	 * 测试鼠标事件
	 * @author warden_feng 2014-3-14
	 */
	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class TestMouseEvent extends TestBase
	{
		public var head:Mesh;

		public var _view:View3D;

		private var archMageObjData:String = "art/head.obj";

		public function TestMouseEvent()
		{
			resourceList = [archMageObjData];
			super();
		}

		public function init():void
		{
			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_view = new View3D();
			addChild(_view);

			_view.camera.z = 200;
			_view.camera.y = 200;
			_view.camera.x = 200;
			_view.camera.lookAt(new Vector3D());

			var objParser:ObjParser1 = new ObjParser1(resourceDic[archMageObjData], 25, true, true);
			var terrainGeometry:Geometry = new Geometry();

			var sub:SubGeometry = new SubGeometry();
			terrainGeometry.addSubGeometry(sub);
			sub.updateIndexData(objParser.rawIndexBuffer);
			sub.numVertices = objParser.rawPositionsBuffer.length / 3;
			sub.updateVertexPositionData(objParser.rawPositionsBuffer);
			sub.setVAData(Context3DBufferTypeIDCommon.UV_VA_2, objParser.rawUvBuffer);

			head = new Mesh();
			head.name = "head";
			head.geometry = terrainGeometry;
			head.geometry.scaleUV(4, 4);
			head.material.repeat = true;

			_view.scene.addChild(head);

			head.pickingCollider = PickingColliderType.PB_BEST_HIT;
//			head.pickingCollider = PickingColliderType.AS3_BEST_HIT;

			head.mouseEnabled = true;

			head.addEventListener(MouseEvent3D.CLICK, onMouseEvent);
			head.addEventListener(MouseEvent3D.MOUSE_OVER, onMouseEvent);
			head.addEventListener(MouseEvent3D.MOUSE_OUT, onMouseEvent);
			head.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseEvent);
			head.addEventListener(MouseEvent3D.DOUBLE_CLICK, onMouseEvent);
			head.addEventListener(MouseEvent3D.MOUSE_WHEEL, onMouseEvent);
			head.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseEvent);
			head.addEventListener(MouseEvent3D.MOUSE_UP, onMouseEvent);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected function onEnterFrame(event:Event):void
		{
			head.rotationY = 0;
		}

		/**
		 * mesh listener for mouse over interaction
		 */
		private function onMouseEvent(event:MouseEvent3D):void
		{
			var mesh:Mesh = event.object as Mesh;
			switch (event.type)
			{
				case MouseEvent3D.MOUSE_OVER:
					mesh.showBounds = true;
					break;
				case MouseEvent3D.MOUSE_OUT:
					mesh.showBounds = false;
					break;
			}
			trace(event.type);
		}

	}
}
