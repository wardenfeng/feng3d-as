package
{
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	import data.PanParser;

	import me.feng.core.GlobalDispatcher;
	import me.feng.events.load.LoadModuleEvent;
	import me.feng.events.load.LoadModuleEventData;
	import me.feng.load.Load;
	import me.feng.load.LoadUrlEvent;
	import me.feng.load.data.LoadTaskItem;
	import me.feng3d.animators.vertex.VertexAnimationSet;
	import me.feng3d.animators.vertex.VertexAnimator;
	import me.feng3d.animators.vertex.VertexClipNode;
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.entities.Mesh;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.test.TestBase;
	import me.feng3d.utils.Cast;

	/**
	 *
	 * @author feng 2014-6-11
	 */
	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class VertexAnimatorTest extends TestBase
	{
		public var view:View3D;

		/** 世界 */
		private var world:ObjectContainer3D;

		/** 几何体字典 */
		private var geometryDic:Dictionary = new Dictionary();
		/** 动画字典 */
		private var animationDic:Dictionary = new Dictionary();
		/** 材质字典 */
		private var materialDic:Dictionary = new Dictionary();

		private var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		/** 地面 */
		private var ground:Mesh;

		public function VertexAnimatorTest()
		{
			super();
		}

		public function init(e:Event = null):void
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			view = new View3D();
			view.name = "mainView3D";
			addChild(view);

			view.camera.y = 100;
			view.camera.x = 200;
			view.camera.z = 200;
			view.camera.lookAt(new Vector3D());

			world = new ObjectContainer3D();
			world.name = "world";
			view.scene.addChild(world);

			Load.init();
			loadConfig();

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected function onEnterFrame(event:Event):void
		{
			view.render();
		}

		/** 添加场景元件 */
		private function addElements(itemList:Vector.<Element>):void
		{
			var element:Element;
			for (var i:int = 0; i < itemList.length; i++)
			{
				element = itemList[i];
				element.geometryUrl = rootPath + "model/" + element.geometryName + ".xml";
				element.materialUrl = rootPath + "img/" + element.materialName + ".jpg";

				element.geometry ||= geometryDic[element.geometryUrl];
				element.material ||= materialDic[element.materialUrl];

				if (element.geometry && element.material)
				{
					createElement(element);
				}
				else
				{
					var loadEventData:LoadModuleEventData = new LoadModuleEventData();
					loadEventData.urls = [element.geometryUrl, element.materialUrl];
					loadEventData.addEventListener(LoadUrlEvent.LOAD_SINGLE_COMPLETE, singleGeometryComplete);
					loadEventData.addEventListener(LoadUrlEvent.LOAD_COMPLETE, allItemsLoaded);
					loadEventData.data = {element: element}

					dispatcher.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_RESOURCE, loadEventData));
				}
			}
		}

		/** 加载配置 */
		private function loadConfig():void
		{
			var itemList:Vector.<Element> = new Vector.<Element>();
			var j:XML = <item name="hero" x="0" y="35" z="0" scale="3" rotationX="0" rotationY="0" geometry="people01" material="people01"/>;
			itemList.push(new Element(j));

			addElements(itemList);
		}

		/** 一个场景对象的所有资源加载完毕 */
		private function allItemsLoaded(event:LoadUrlEvent):void
		{
			var loadData:LoadModuleEventData = event.target as LoadModuleEventData;
			var element:Element = loadData.data.element;
			element.geometry ||= geometryDic[element.geometryUrl];
			element.animation ||= animationDic[element.geometryUrl];
			element.material ||= materialDic[element.materialUrl];

			if (element.geometry && element.material)
			{
				createElement(element);
			}
			else
			{
				trace("创建" + element.name + "失败！");
			}
		}

		/** 单个模型数据加载完毕 */
		private function singleGeometryComplete(event:LoadUrlEvent):void
		{
			var loadData:LoadModuleEventData = event.currentTarget as LoadModuleEventData;
			var loadItemData:LoadTaskItem = event.loadTaskItem;

			var element:Element = loadData.data.element;
			if (loadItemData.url == element.geometryUrl)
			{
				if (geometryDic[loadItemData.url])
					return;
				var config:XML = Load.loader.getXML(loadItemData.url);
				config.ignoreWhitespace = true;

				var _groundStringV:String;
				var _groundStringU:String
				var _groundStringUV:String
				if (config.vlist && config.vlist.length() > 0)
				{
					var _groundStringVList:Array = [];
					for (var i:int = 0; i < config.vlist.v.length(); i++)
					{
						_groundStringVList[i] = String(config.vlist.v[i]);
					}
					_groundStringU = config.u;
					_groundStringUV = config.uv;
					var geometrys:* = PanParser.getPanAnimationGeometry(_groundStringVList, _groundStringU, _groundStringUV);
					geometryDic[loadItemData.url] = geometrys[0];

					var _animationSet:VertexAnimationSet = new VertexAnimationSet();
					var clip:VertexClipNode = new VertexClipNode();
					var FPS:int = 5;
					for (var j:int = 0; j < geometrys.length; j++)
					{
						clip.addFrame(geometrys[j], 1000 / FPS);
					}
					clip.name = "walk";
					_animationSet.addAnimation(clip);
					animationDic[loadItemData.url] = new VertexAnimator(_animationSet);
				}
				else
				{
					_groundStringV = config.v;
					_groundStringU = config.u;
					_groundStringUV = config.uv;
					geometryDic[loadItemData.url] = PanParser.getPanGeometry(_groundStringV, _groundStringU, _groundStringUV);
				}
			}
			else if (loadItemData.url == element.materialUrl)
			{
				var bitmapdata:BitmapData = Load.loader.getBitmapData(loadItemData.url);
				materialDic[loadItemData.url] = new TextureMaterial(Cast.bitmapTexture(bitmapdata));
			}
		}

		/** 创建场景对象 */
		private function createElement(element:Element):void
		{
			var mesh:Mesh = new Mesh(element.geometry, element.material);
			if (element.animation)
			{
				mesh.animator = element.animation;

				VertexAnimator(mesh.animator).play("walk", null, 0);
			}
			mesh.name = element.name;
			mesh.x = element.x;
			mesh.y = element.y;
			mesh.z = element.z;
			mesh.scale(element.scale);
			mesh.rotationX = element.rotationX;
			mesh.rotationY = element.rotationY;
			mesh.rotationZ = element.rotationZ;
			world.addChild(mesh);
		}

	}
}
import me.feng3d.animators.vertex.VertexAnimator;
import me.feng3d.core.base.Geometry;
import me.feng3d.materials.MaterialBase;

class Element
{
	public var name:String;
	public var x:Number;
	public var y:Number;
	public var z:Number;
	public var scale:Number;
	public var rotationX:Number;
	public var rotationY:Number;
	public var rotationZ:Number;
	public var geometryName:String;
	public var materialName:String;

	public var geometry:Geometry;
	public var animation:VertexAnimator;
	public var material:MaterialBase;

	public var geometryUrl:String;
	public var materialUrl:String;

	public function Element(j:*)
	{
		name = j.@name;
		x = j.@x;
		y = j.@y;
		z = j.@z;
		scale = j.@scale;
		rotationX = j.@rotationX;
		rotationY = j.@rotationY;
		rotationZ = j.@rotationZ;
		geometryName = j.@geometry;
		materialName = j.@material;
	}
}
