package me.feng3d.fagal.fragment.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;

	/**
	 *
	 * @author warden_feng 2015-1-21
	 */
	public function F_ParticleColorCombination(colorMulVary:Register, colorAddVary:Register, finalColorReg:Register):void
	{
//			if (hasColorMulNode)
		mul(finalColorReg, finalColorReg, colorMulVary);
//			if (hasColorAddNode)
		add(finalColorReg, finalColorReg, colorAddVary);
	}
}
