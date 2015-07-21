package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.mov;

	/**
	 * 环境光片段渲染程序
	 * @author warden_feng 2014-11-7
	 */
	public function F_Ambient(ambientInputReg:Register, ambientTempReg:Register):void
	{
		mov(ambientTempReg, ambientInputReg);
	}
}
