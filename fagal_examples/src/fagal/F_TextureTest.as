package fagal
{
	import flash.display3D.Context3DProgramType;
	
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;
	
	
	/**
	 * 
	 * @author cdz 2015-11-9
	 */
	public class F_TextureTest extends FagalMethod
	{
		public function F_TextureTest()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}
		
		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;
						
			//最终颜色寄存器（输出到oc寄存器的颜色）
			var finalColorReg:Register = _.getFreeTemp("最终颜色寄存器（输出到oc寄存器的颜色）");
			var currentColorReg:Register = _.getFreeTemp("当前纹理颜色值");

			_.tex(currentColorReg, _.uv_v, _.texture_fs); // 使用地面纹理 得到该纹理颜色值

			_.mov(finalColorReg, currentColorReg);
			
			_.mov(_._oc, finalColorReg);
		}
	}
}