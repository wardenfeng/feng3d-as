package fagal
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 基础片段渲染
	 * @author feng 2014-10-24
	 */
	public class F_colorTerrain extends FagalMethod
	{
		public function F_colorTerrain()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			var numSplattingLayers:int = 3;

			//最终颜色寄存器（输出到oc寄存器的颜色）
			var finalColorReg:Register = _.getFreeTemp("最终颜色寄存器（输出到oc寄存器的颜色）");
			var currentColorReg:Register = _.getFreeTemp("当前纹理颜色值");
			var isFirst:Boolean = true;

			for (var i:int = 0; i < numSplattingLayers; ++i)
			{
				_.tex(currentColorReg, _.uv_v, _.terrainTextures_fs_array.getReg(i)); // 使用地面纹理 得到该纹理颜色值

				if (isFirst)
				{
					_.mov(finalColorReg, currentColorReg);
				}
				else
				{
					_.sub(currentColorReg, currentColorReg, finalColorReg); // uvtemp = uvtemp - targetreg; --------------1
					_.mul(currentColorReg, currentColorReg, _.color_v.c(i)); // uvtemp = uvtemp * blendtemp; ----------2  (0 <= blendtemp <= 1)
					_.add(finalColorReg, finalColorReg, currentColorReg); // 添加到默认颜色值上  targetreg = targetreg + uvtemp; ------------3
				}
				isFirst = false;
			}

			_.mov(_._oc, finalColorReg);
		}
	}
}


