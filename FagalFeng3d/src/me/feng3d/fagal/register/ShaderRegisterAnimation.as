package me.feng3d.fagal.register
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDAnimation;

	/**
	 * 动画渲染相关寄存器
	 * @author warden_feng 2015-5-21
	 */
	public class ShaderRegisterAnimation
	{
		private var _animatedPosition:Register;
		private var _p0:Register;
		private var _p1:Register;
		private var _weight:Register;
		private var _animatedReg:Register;

		/**
		 * 初始化
		 */
		public function init():void
		{
			_animatedPosition = null;
			_p0 = null;
			_p1 = null;
			_weight = null;
			_animatedReg = null;
		}

		/**
		 * 顶点动画第0个坐标数据
		 */
		public function get p0():Register
		{
			return _p0 ||= requestRegister(Context3DBufferTypeIDAnimation.POSITION0_VA_3);
		}

		/**
		 * 顶点动画第1个坐标数据
		 */
		public function get p1():Register
		{
			return _p1 ||= requestRegister(Context3DBufferTypeIDAnimation.POSITION1_VA_3);
		}

		/**
		 * 顶点程序权重向量静态数据
		 */
		public function get weight():Register
		{
			return _weight ||= requestRegister(Context3DBufferTypeIDAnimation.WEIGHTS_VC_VECTOR);
		}

		/**
		 * 动画后的顶点坐标数据
		 */
		public function get animatedPosition():Register
		{
			return _animatedPosition ||= requestRegister(Context3DBufferTypeIDAnimation.ANIMATEDPOSITION_VT_4);
		}

		/**
		 * @private
		 */
		public function set animatedPosition(value:Register):void
		{
			_animatedPosition = value;
		}

		/**
		 * 骨骼动画计算完成后的顶点坐标数据
		 */
		public function get animatedReg():Register
		{
			return _animatedReg ||= requestRegister(Context3DBufferTypeIDAnimation.ANIMATED_VA_3);
		}
	}
}
