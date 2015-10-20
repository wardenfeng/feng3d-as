package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.Dictionary;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.AGALProgram3DCache;
	import me.feng3d.core.register.ShaderRegisterCache;

	use namespace arcanefagal;

	/**
	 * 渲染程序缓存
	 * @author feng 2014-8-14
	 */
	public class ProgramBuffer extends Context3DBuffer
	{
		private var bufferItemDic:Dictionary = new Dictionary();

		arcanefagal var vertexCode:String;
		arcanefagal var fragmentCode:String;

		/** 是否无效 */
		private var bufferInvalid:Boolean = true;

		/** 使用到的数据寄存器 */
		arcanefagal var dataRegisterDic:Dictionary;

		/**
		 * 创建一个渲染程序缓存
		 * @param dataTypeId 		数据缓存编号
		 * @param updateFunc 		更新回调函数
		 */
		public function ProgramBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		/**
		 * @inheritDoc
		 */
		override protected function doUpdateFunc():void
		{
			if (_updateFunc != null && _dataDirty)
			{
				ShaderRegisterCache.invalid();
				_updateFunc(this);
				_dataDirty = false;
				dataRegisterDic = ShaderRegisterCache.instance.dataRegisterDic;
			}
		}

		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			var program3D:Program3D;

			if (bufferInvalid)
			{
				for (var key:* in bufferItemDic)
				{
					var contextTemp:Context3D = key as Context3D;
					AGALProgram3DCache.getInstance(contextTemp).freeProgram3D(bufferItemDic[contextTemp]);
				}
				bufferItemDic = new Dictionary();
				bufferInvalid = false;
			}

			var oldProgram3D:Program3D = bufferItemDic[context3D];
			program3D = bufferItemDic[context3D] = AGALProgram3DCache.getInstance(context3D).getProgram3D(oldProgram3D, vertexCode, fragmentCode);

			context3D.setProgram(program3D);
		}

		public function update(vertexCode:String, fragmentCode:String):void
		{
			this.bufferInvalid = true;
			this.vertexCode = vertexCode;
			this.fragmentCode = fragmentCode;
		}
	}
}
