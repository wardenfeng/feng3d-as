package com.Tevoydes.objectView
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.VBox;

	/**
	 * 模型的组信息
	 * @author Tevoydes 2015-10-24
	 */
	public class ObjectAttributeGroup
	{
		/**组名*/
		private var groupName:String;
		/**模型属性数组*/
		private var objectAttrUnitVec:Vector.<ObjectAttributeUnit>;

		public function ObjectAttributeGroup()
		{
		}

		/**
		 *创建组结构
		 *
		 */
		public function create(_obj:*, _name:String):void
		{
			objectAttrUnitVec = new Vector.<ObjectAttributeUnit>;
			groupName = "";
			//if(!(_obj is Object))
			{
				groupName = "";
				var tempUnit:ObjectAttributeUnit = new ObjectAttributeUnit;
				tempUnit.create(_obj, _name);
				objectAttrUnitVec.push(tempUnit);
				return;
			}
//			groupName = _name;
//			for(var str:String in _obj)
//			{
//				var tempObj:ObjectAttributeUnit = new ObjectAttributeUnit;
//				tempObj.create(_obj[str],str);
//				objectAttrUnitVec.push(tempObj);
//			}
		}

		/**
		 *获取组数据
		 * @param _obj
		 * @return
		 *
		 */
		public function getGroupData(_obj:Object):VBox
		{
			var vBox:VBox = new VBox;
			if (groupName != "")
			{
				var text:Label = new Label;
				text.text = groupName;
				text.height = 20;
				vBox.addChildAt(text, vBox.numChildren);
				;
			}
			for (var i:int = 0; i < objectAttrUnitVec.length; i++)
			{
				var hBox:HBox;
				hBox = objectAttrUnitVec[i].getUnitData(_obj);
				vBox.addChildAt(hBox, vBox.numChildren);
			}
			return vBox;
		}
	}
}
