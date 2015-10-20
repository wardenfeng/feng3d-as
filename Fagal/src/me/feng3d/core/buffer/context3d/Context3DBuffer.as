package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.utils.getQualifiedClassName;

	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng.utils.formatString;
	import me.feng3d.arcanefagal;

	use namespace arcanefagal;

	/**
	 * Context3D可执行的数据缓存
	 * @author feng 2014-6-9
	 */
	public class Context3DBuffer
	{
		/** 3d缓存类型编号 */
		private var _dataTypeId:String;

		/** 数据脏了 */
		protected var _dataDirty:Boolean = true;

		/** 更新回调函数 */
		protected var _updateFunc:Function;

		/**
		 * 创建一个Context3D可执行的数据缓存
		 * @param dataTypeId 		数据缓存编号
		 * @param updateFunc 		更新回调函数
		 */
		public function Context3DBuffer(dataTypeId:String, updateFunc:Function)
		{
			_dataTypeId = dataTypeId;
			_updateFunc = updateFunc;

			AbstractClassError.check(this);
		}

		/**
		 * 使缓存无效
		 */
		public function invalid():void
		{
			_dataDirty = true;
		}

		/**
		 * 运行更新回调函数
		 */
		protected function doUpdateFunc():void
		{
			if (_updateFunc != null && _dataDirty)
			{
				_updateFunc(this);
				_dataDirty = false;
			}
		}

		/**
		 * 缓存类型编号
		 */
		public function get dataTypeId():String
		{
			return _dataTypeId;
		}

		/**
		 * 执行Context3DBuffer
		 * <p><b>注：</b>该函数为虚函数</p>
		 *
		 * @param context3D		3d环境
		 *
		 * @see me.feng3d.core.buffer.Context3DCache
		 */
		arcanefagal function doBuffer(context3D:Context3D):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 字符串描述
		 */
		public function toString():String
		{
			return formatString("[{0} dataType=\"{1}\"]", getQualifiedClassName(this).split("::").pop(), _dataTypeId);
		}
	}
}
