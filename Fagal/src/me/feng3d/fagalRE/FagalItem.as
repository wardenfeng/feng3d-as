package me.feng3d.fagalRE
{
	import flash.utils.Dictionary;

	import me.feng3d.core.register.RegisterArrayComplexItem;
	import me.feng3d.fagal.IField;

	/**
	 * fagal函数单元
	 * @author warden_feng 2015-8-8
	 */
	public class FagalItem
	{
		public var funcName:String;
		public var parameters:Array;

		/**
		 * 创建一个fagal函数单元
		 * @param funcName			函数名称
		 * @param parameters		参数
		 */
		public function FagalItem(funcName:String, parameters:Array)
		{
			this.funcName = funcName;
			this.parameters = parameters;
		}

		/**
		 * 获取参数中出现的寄存器id以及次数
		 * @param parameters			拥有寄存器的参数
		 * @return						寄存器id字典(key:regID,value:count)
		 */
		public function getRegCountDic():Dictionary
		{
			var dic:Dictionary = new Dictionary();

			//针对使用到的寄存器计数
			if (funcName == "comment")
			{
				return dic;
			}

			var list:Vector.<IField> = getIFieldList();
			for each (var reg:IField in list)
			{
				dic[reg.regId] = int(dic[reg.regId]) + 1;
			}

			return dic;
		}

		/**
		 * 获取寄存器列表
		 */
		private function getIFieldList():Vector.<IField>
		{
			var list:Vector.<IField> = new Vector.<IField>();

			for each (var reg:IField in parameters)
			{
				var registerArrayComplexItem:RegisterArrayComplexItem = reg as RegisterArrayComplexItem;
				if (registerArrayComplexItem != null)
				{
					for each (var complexArg:IField in registerArrayComplexItem.complexArgs)
					{
						list.push(complexArg);
					}
				}
				//记录寄存器使用次数
				if (reg != null)
				{
					list.push(reg);
				}
			}

			return list;
		}
	}
}
