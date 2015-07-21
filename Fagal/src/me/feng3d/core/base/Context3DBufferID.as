package me.feng3d.core.base
{

	/**
	 * 3D环境缓冲编号集合
	 * @author warden_feng 2015-7-21
	 */
	public dynamic class Context3DBufferID
	{
		private static var _instance:Context3DBufferID;

		/**
		 * 创建3D环境缓冲编号集合
		 */
		public function Context3DBufferID()
		{
		}

		public static function get instance():Context3DBufferID
		{
			return _instance ||= new Context3DBufferID();
		}
	}
}
