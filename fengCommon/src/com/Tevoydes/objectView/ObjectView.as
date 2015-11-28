package com.Tevoydes.objectView
{
	import com.bit101.components.VBox;
	import com.bit101.components.Window;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;


	/**
	 * 模型界面类
	 * @author Tevoydes 2015-10-23
	 */
	public class ObjectView extends Window
	{
		/**界面是否在显示状态*/
		private var isShow:Boolean;
		/**界面是否被创造*/
		private var isCreate:Boolean;
		/**模型组数组 */
		private var objectAttrGroupVec:Vector.<ObjectAttributeGroup>;
		/**待显示信息的模型*/
		private var object:Object;
		/**类对应Json结构的字典 */
		private var classToJsonDic:Dictionary;
		/**上层对象*/
		private var mom:DisplayObjectContainer;

		/**
		 *构建时初始化
		 *
		 */
		public function ObjectView(_mom:DisplayObjectContainer)
		{
			title = "ObjectView";
			hasCloseButton = true;
			hasMinimizeButton = true;
			isShow = false;
			isCreate = false;
			mom = _mom;
			classToJsonDic = new Dictionary;
		}

		/**
		 *注册新的结构
		 *
		 */
		public function register():void
		{

		}

		/**
		 *显示界面
		 * @param _obj
		 *
		 */
		public function showObjectView(_obj:Object):void
		{
			object = _obj;

			if (!isCreate)
			{
				isCreate = true;
				createView();
			}
			openOrCloseView();
		}

		/**
		 *创建界面
		 *
		 */
		private function createView():void
		{
			//MyCC.initFlashConsole(mom, "11111");
			this.x = 200;
			this.y = 200;
			mom.addChild(this);
		}

		/**
		 *创建结构
		 *
		 */
		private function createStruct():void
		{
			objectAttrGroupVec = new Vector.<ObjectAttributeGroup>;
			for (var str:String in object)
			{
				var tempGroup:ObjectAttributeGroup = new ObjectAttributeGroup;
				tempGroup.create(object[str], str);
				objectAttrGroupVec.push(tempGroup);
			}

			//var str:String = getQualifiedClassName(object);


		}

		/**
		 *添加数据到界面
		 *
		 */
		public function addDataToView():void
		{

			var str:String = getQualifiedClassName(object);
			if (classToJsonDic[str] == null)
			{
				createStruct();

			}

			var vBox:VBox = new VBox;
			for (var i:int = 0; i < objectAttrGroupVec.length; i++)
			{
				var tempVBox:VBox = objectAttrGroupVec[i].getGroupData(object);
				vBox.addChildAt(tempVBox, vBox.numChildren);
			}
			vBox.x = 0;
			vBox.y = 20;
			this.content.addChildAt(vBox, this.content.numChildren);
			this.draw();
			this.width = 300;
			this.height = 500;



		}

		/**
		 *打开/关闭界面
		 *
		 */
		public function openOrCloseView():void
		{
			if (isShow)
			{
				isShow = false;
				if (this.parent != null)
				{
					this.parent.removeChild(this);
				}
				return;
			}
			ObjectAttributeUnit.clearDic();
			isShow = true;
			addDataToView();

		}

		/**
		 *关闭时的事件
		 * @param event
		 *
		 */
		override protected function onClose(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}
