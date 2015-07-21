package me.feng3d.fagal.register
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;

	/**
	 * 通用渲染寄存器
	 * @author warden_feng 2015-5-21
	 */
	public class ShaderRegisterCommon
	{
		private var _position:Register;

		public function ShaderRegisterCommon()
		{
		}

		/**
		 * 顶点坐标数据
		 */
		public function get position():Register
		{
			return _position ||= requestRegister(Context3DBufferTypeIDCommon.POSITION_VA_3);
		}

		public function init():void
		{
			_position = null;
		}
	}
}
