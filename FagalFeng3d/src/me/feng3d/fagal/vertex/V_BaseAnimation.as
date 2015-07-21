package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.mov;

	/**
	 * 基础动画顶点渲染函数(无动画)
	 * @param animatedPosition			动画后的顶点坐标数据
	 * @param position					顶点坐标数据
	 * @author warden_feng 2014-11-3
	 */
	public function V_BaseAnimation(animatedPosition:Register, position:Register):void
	{
		mov(animatedPosition, position);
	}
}
