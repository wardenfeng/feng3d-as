package com.Tevoydes.objectView
{
	import com.bit101.components.VBox;

	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;


	/**
	 * 模型界面类
	 * @author Tevoydes 2015-10-23
	 */
	public class ObjectView
	{
		/**类对应Json结构的字典 */
		private static var classToJsonDic:Dictionary = new Dictionary();

		/**
		 *显示界面
		 * @param _obj
		 *
		 */
		public static function getView(object:Object):VBox
		{
			var container:VBox = new VBox();

//			ObjectAttributeUnit.clearDic();
			addDataToView(object, container);

			return container;
		}

		/**
		 *创建结构
		 *
		 */
		private static function createStruct(object:Object):Vector.<ObjectAttributeGroup>
		{
			/**模型组数组 */
			var objectAttrGroupVec:Vector.<ObjectAttributeGroup> = new Vector.<ObjectAttributeGroup>;
			for (var str:String in object)
			{
				var tempGroup:ObjectAttributeGroup = new ObjectAttributeGroup;
				tempGroup.create(object[str], str);
				objectAttrGroupVec.push(tempGroup);
			}

			//var str:String = getQualifiedClassName(object);

			return objectAttrGroupVec;
		}

		/**
		 *添加数据到界面
		 *
		 */
		public static function addDataToView(object:Object, container:DisplayObjectContainer):void
		{

			var str:String = getQualifiedClassName(object);
			/**模型组数组 */
			var objectAttrGroupVec:Vector.<ObjectAttributeGroup> = createStruct(object);

			var vBox:VBox = new VBox;
			for (var i:int = 0; i < objectAttrGroupVec.length; i++)
			{
				var tempVBox:VBox = objectAttrGroupVec[i].getGroupData(object);
				vBox.addChildAt(tempVBox, vBox.numChildren);
			}
			vBox.x = 0;
			vBox.y = 20;
			container.addChild(vBox);
		}

	}
}
