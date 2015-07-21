package me.feng3d.core.buffer
{
	import flash.display3D.Context3D;
	import flash.utils.Dictionary;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.context3d.Context3DBuffer;
	import me.feng3d.core.buffer.context3d.IndexBuffer;
	import me.feng3d.core.buffer.context3d.OCBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.RegisterBuffer;
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterType;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcanefagal;

	/**
	 * 3D环境缓存类(方便调试与管理渲染操作)
	 * @author warden_feng 2014-6-6
	 */
	public class Context3DCache extends Context3DBufferCollector
	{
		/** 寄存器数据缓存 */
		private var regBufferDic:Dictionary = new Dictionary();
		/** 其他数据缓存 */
		arcanefagal var otherBufferDic:Dictionary = new Dictionary();

		/**
		 * 运行寄存器缓冲列表
		 */
		arcanefagal var runRegBufferList:Array;

		/** 渲染程序缓存 */
		arcanefagal var programBuffer:ProgramBuffer;

		/** 索引缓存 */
		arcanefagal var indexBuffer:IndexBuffer;

		/**
		 * 片段输出缓冲
		 */
		arcanefagal var ocBuffer:OCBuffer;

		/**
		 * 数据寄存器字典
		 */
		private var _dataRegisterDic:Dictionary;

		/**
		 * 渲染参数
		 */
		public var shaderParams:ShaderParams;

		/**
		 * 创建3D环境缓存类
		 */
		public function Context3DCache()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		arcanefagal override function addDataBuffer(context3DDataBuffer:Context3DBuffer):void
		{
			super.addDataBuffer(context3DDataBuffer);

			var dataTypeId:String = context3DDataBuffer.dataTypeId;
			if (context3DDataBuffer is RegisterBuffer)
				regBufferDic[dataTypeId] = context3DDataBuffer;
			else if (context3DDataBuffer is ProgramBuffer)
				programBuffer = context3DDataBuffer as ProgramBuffer;
			else if (context3DDataBuffer is IndexBuffer)
				indexBuffer = context3DDataBuffer as IndexBuffer;
			else
				otherBufferDic[dataTypeId] = context3DDataBuffer;
		}

		/**
		 * @inheritDoc
		 */
		arcanefagal override function removeDataBuffer(context3DDataBuffer:Context3DBuffer):void
		{
			super.removeDataBuffer(context3DDataBuffer);

			var dataTypeId:String = context3DDataBuffer.dataTypeId;
			delete regBufferDic[dataTypeId];
			delete otherBufferDic[dataTypeId];

			if (context3DDataBuffer is ProgramBuffer)
			{
				programBuffer = null;
			}
		}

		/**
		 * 使用Context3D缓存绘制
		 * <p>过程：渲染程序缓存（标记使用的寄存器数据缓存）-->寄存器数据缓存(标记使用的数据)-->其他缓存-->绘制三角形</p>
		 * @param context3D		3d环境
		 */
		public function render(context3D:Context3D):void
		{
			//更新渲染程序（标记使用寄存器）
			fagalRE.context3DCache = this;

			programBuffer.doBuffer(context3D);

			fagalRE.context3DCache = null;

			dataRegisterDic = programBuffer.dataRegisterDic;

			//处理 其他数据缓存
			for each (var context3DDataBuffer:Context3DBuffer in otherBufferDic)
			{
				context3DDataBuffer.doBuffer(context3D);
			}
			//处理 需要执行的寄存器数据缓存
			for each (var registerBuffer:RegisterBuffer in runRegBufferList)
			{
				registerBuffer.doBuffer(context3D);
			}

			//执行索引数据缓存
			indexBuffer.doBuffer(context3D);

			context3D.setRenderToBackBuffer();

			//清理缓存
			clearContext3D(context3D);
		}

		/**
		 * 使用到的数据寄存器
		 */
		private function get dataRegisterDic():Dictionary
		{
			return _dataRegisterDic;
		}

		/**
		 * @private
		 */
		private function set dataRegisterDic(value:Dictionary):void
		{
			if (_dataRegisterDic != value)
			{
				_dataRegisterDic = value;
				mapRegister();
			}
		}

		/**
		 * 清理3D环境
		 */
		private function clearContext3D(context3D:Context3D):void
		{
			for (var i:uint = 0; i < 8; ++i)
			{
				context3D.setVertexBufferAt(i, null);
				context3D.setTextureAt(i, null);
			}
		}

		/**
		 * 映射寄存器
		 */
		private function mapRegister():void
		{
			runRegBufferList = [];

			for each (var register:Register in dataRegisterDic)
			{
				var registerBuffer:RegisterBuffer = regBufferDic[register.regId];
				//输入数据寄存器必须有对应的数据缓存
				if (RegisterType.isInputDataRegister(register))
				{
					if (registerBuffer == null)
					{
						throw new Error("缺少【" + register.regId + "】寄存器数据缓存");
					}
				}
				if (registerBuffer != null)
				{
					registerBuffer.shaderRegister = register;
					runRegBufferList.push(registerBuffer);
				}
			}
			runRegBufferList.sortOn("dataTypeId");
		}

		/**
		 * Fagal函数运行环境
		 */
		private function get fagalRE():FagalRE
		{
			return FagalRE.instance;
		}
	}
}
