package me.feng3d.fagal.vertex.shadowMap
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 深度图顶点主程序
	 * @author warden_feng 2015-5-30
	 */
	public class V_Main_DepthMap extends FagalMethod
	{
		/**
		 * 构建 深度图顶点主程序
		 */
		public function V_Main_DepthMap()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		/**
		 * @inheritDoc
		 */
		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			//普通动画
			_.mov(_.animatedPosition_vt_4, _.position_va_3);
			var outPosition:Register = _.getFreeTemp("投影后的坐标");
			//计算投影
			_.m44(outPosition, _.animatedPosition_vt_4, _.projection_vc_matrix);
			//输出顶点坐标数据			
			_.mov(_._op, outPosition);
			//把顶点投影坐标输出到片段着色器
			_.mov(_.positionProjected_v, outPosition);
		}
	}
}
