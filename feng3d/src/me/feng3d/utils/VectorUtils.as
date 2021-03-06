package me.feng3d.utils
{


	/**
	 * 向量工具类
	 * @author feng 2014-12-10
	 */
	public class VectorUtils
	{
		/**
		 * 把source添加到target中
		 * @param source 源向量
		 * @param target 目标向量
		 */
		public static function add(source:Vector.<Number>, target:Vector.<Number>):Vector.<Number>
		{
			var sourceLen:uint = target.length;
			var targetLen:uint = source.length;
			var sourceFixed:Boolean = target.fixed;
			target.fixed = false;
			target.length = target.length + source.length;
			target.fixed = sourceFixed;
			for (var i:int = 0; i < targetLen; i++)
			{
				target[sourceLen + i] = source[i];
			}
			return target;
		}

		/**
		 * 拷贝数组
		 * @param source		源数组
		 * @param target		目标数组
		 * @param offset		在源数组中的偏移量
		 */
		public static function copy(source:Vector.<Number>, target:Vector.<Number>, offset:uint):void
		{
			source.forEach(function(item:Number, index:int, ... args):void
			{
				target[offset + index] = item;
			});
		}

		/**
		 * 把source添加到target中
		 * @param source 源向量
		 * @param target 目标向量
		 */
		public static function add1(source:Vector.<uint>, target:Vector.<uint>, addNum:uint):Vector.<uint>
		{
			var sourceLen:uint = target.length;
			var targetLen:uint = source.length;
			var sourceFixed:Boolean = target.fixed;
			target.fixed = false;
			target.length = target.length + source.length;
			target.fixed = sourceFixed;
			for (var i:int = 0; i < targetLen; i++)
			{
				target[sourceLen + i] = source[i] + addNum;
			}
			return target;
		}


	}
}
