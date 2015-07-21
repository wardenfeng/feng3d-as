package fagal
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterVector;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.requestRegisterVector;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.base.operation.tex;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 基础片段渲染
	 * @author warden_feng 2014-10-24
	 */
	public class F_colorTerrain extends FagalMethod
	{
		public function F_colorTerrain()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		override public function runFunc():void
		{
			var numSplattingLayers:int = 3;

			//颜色变量寄存器 (此处用作为混合值)
			var color_v:Register = requestRegister(Context3DBufferTypeID.COLOR_V);
			//颜色输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeID.OC);
			//uv变量数据
			var uv_v:Register = requestRegister(Context3DBufferTypeID.UV_V);
			//土壤纹理列表
			var splatFsarr:RegisterVector = requestRegisterVector(Context3DBufferTypeID.TERRAINTEXTURES_FS_ARRAY, numSplattingLayers);

			//最终颜色寄存器（输出到oc寄存器的颜色）
			var finalColorReg:Register = getFreeTemp("最终颜色寄存器（输出到oc寄存器的颜色）");

			var currentColorReg:Register = getFreeTemp("当前纹理颜色值");
			var isFirst:Boolean = true;

			for (var i:int = 0; i < numSplattingLayers; ++i)
			{
				tex(currentColorReg, uv_v, splatFsarr.getReg(i)); // 使用地面纹理 得到该纹理颜色值

				if (isFirst)
				{
					mov(finalColorReg, currentColorReg);
				}
				else
				{
					sub(currentColorReg, currentColorReg, finalColorReg); // uvtemp = uvtemp - targetreg; --------------1
					mul(currentColorReg, currentColorReg, color_v.c(i)); // uvtemp = uvtemp * blendtemp; ----------2  (0 <= blendtemp <= 1)
					add(finalColorReg, finalColorReg, currentColorReg); // 添加到默认颜色值上  targetreg = targetreg + uvtemp; ------------3
				}
				isFirst = false;
			}

//			comment("传递顶点颜色数据" + color_v + "到片段寄存器" + out);
			mov(out, finalColorReg);
		}
	}
}


