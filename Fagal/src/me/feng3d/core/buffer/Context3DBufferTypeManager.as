package me.feng3d.core.buffer
{
	import flash.utils.Dictionary;

	import me.feng3d.core.buffer.context3d.BlendFactorsBuffer;
	import me.feng3d.core.buffer.context3d.CullingBuffer;
	import me.feng3d.core.buffer.context3d.DepthTestBuffer;
	import me.feng3d.core.buffer.context3d.FCByteArrayBuffer;
	import me.feng3d.core.buffer.context3d.FCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSArrayBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.buffer.context3d.IndexBuffer;
	import me.feng3d.core.buffer.context3d.OCBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VABuffer;
	import me.feng3d.core.buffer.context3d.VCByteArrayBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.core.buffer.type.Context3DBufferType;

	/**
	 * 3d环境缓存类型管理者
	 * @author warden_feng 2014-9-3
	 */
	public class Context3DBufferTypeManager
	{
		/** 缓存类型字典 */
		private var bufferTypeDic:Dictionary;

		private var typeClassDic:Dictionary;

		/** 实例 */
		private static var _instance:Context3DBufferTypeManager;

		private static const config:Array = [ //
			["blendFactors", BlendFactorsBuffer], //
			["culling", CullingBuffer], //
			["depthTest", DepthTestBuffer], //
			["([a-zA-Z0-9]+)?_fc_bytes", FCByteArrayBuffer], //
			["([a-zA-Z0-9]+)?_fc_matrix", FCMatrixBuffer], //
			["([a-zA-Z0-9]+)?_fc_vector", FCVectorBuffer], //
			["([a-zA-Z0-9]+)?_fs_array", FSArrayBuffer], //
			["([a-zA-Z0-9]+)?_fs", FSBuffer], //
			["index", IndexBuffer], //
			["([a-zA-Z0-9]+)?_oc", OCBuffer], //
			["program", ProgramBuffer], //
			["([a-zA-Z0-9]+)?_va_([1-4x])", VABuffer], //
			["([a-zA-Z0-9]+)?_vc_bytes", VCByteArrayBuffer], //
			["([a-zA-Z0-9]+)?_vc_matrix", VCMatrixBuffer], //
			["([a-zA-Z0-9]+)?_vc_vector", VCVectorBuffer], //
			];

		/**
		 * 创建3d环境缓存类型管理者
		 */
		public function Context3DBufferTypeManager()
		{
			if (_instance)
				throw new Error("单例模式");
			_instance = this;
			bufferTypeDic = new Dictionary();
			typeClassDic = new Dictionary();
		}

		/**
		 * 3d环境缓存类型管理者实例
		 */
		private static function get instance():Context3DBufferTypeManager
		{
			return _instance || new Context3DBufferTypeManager();
		}

		/**
		 * 获取或创建3d缓存类型
		 * @param typeId 		3d缓存类型编号
		 * @return				3d缓存类型实例
		 */
		public static function getBufferType(typeId:String):Context3DBufferType
		{
			return instance.getBufferType(typeId);
		}

		/**
		 * 获取3d缓存类定义
		 * @param typeId 		3d缓存类型编号
		 * @return				3d缓存类定义
		 */
		public static function getBufferClass(typeId:String):Class
		{
			return instance.getBufferClass(typeId);
		}

		/**
		 * 获取或创建3d缓存类型
		 * @param typeId 		3d缓存类型编号
		 * @return				3d缓存类型实例
		 */
		public function getBufferType(typeId:String):Context3DBufferType
		{
			var bufferType:Context3DBufferType = bufferTypeDic[typeId];

			if (bufferType)
				return bufferType;

			bufferTypeDic[typeId] = bufferType = new Context3DBufferType();

			var types:Array = typeId.split("_");
			bufferType.registerType = types[1];
			bufferType.dataType = types[2];

			return bufferType;
		}

		/**
		 * 获取3d缓存类定义
		 * @param typeId 		3d缓存类型编号
		 * @return				3d缓存类定义
		 */
		public function getBufferClass(typeId:String):Class
		{
			var cls:Class = typeClassDic[typeId];
			if (cls == null)
			{
				for (var i:int = 0; i < config.length; i++)
				{
					var result:Array = typeId.match(config[i][0]);
					if (result != null && result.input == result[0])
					{
						return config[i][1];
					}
				}
			}
			throw new Error("无法为" + typeId + "匹配到3d缓存类");
		}
	}
}
