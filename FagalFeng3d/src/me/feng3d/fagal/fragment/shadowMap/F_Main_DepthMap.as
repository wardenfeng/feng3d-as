package me.feng3d.fagal.fragment.shadowMap
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.div;
	import me.feng3d.fagal.base.operation.frc;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 深度图片段主程序
	 * @author warden_feng 2015-5-30
	 */
	public class F_Main_DepthMap extends FagalMethod
	{
		/**
		 * 创建深度图片段主程序
		 */
		public function F_Main_DepthMap()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		/**
		 * @inheritDoc
		 */
		override public function runFunc():void
		{
			//投影后的顶点坐标 变量数据
			var positionProjectedVarying:Register = requestRegister(Context3DBufferTypeID.positionProjected_v);
			var positionReg:Register = getFreeTemp("坐标"); //ft2
			//深度顶点常数0 (1.0, 255.0, 65025.0, 16581375.0)
			var depthCommonData0Reg:Register = requestRegister(Context3DBufferTypeID.depthCommonData0_fc_vector);
			//深度的（乘以1,255,255*255,255*255*255后）不同值
			var depthValueReg:Register = getFreeTemp("深度值");
			//深度顶点常数1 (1.0/255.0, 1.0/255.0, 1.0/255.0, 0.0)
			var depthCommonData1Reg:Register = requestRegister(Context3DBufferTypeID.depthCommonData1_fc_vector);

			var ft1:Register = getFreeTemp("");
			//颜色输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeID.depthMap_oc);

			//计算深度值depth属于（0,1）,该范围外的将会被frc处理为0或1
			div(positionReg, positionProjectedVarying, positionProjectedVarying.w);
			//深度值保存为颜色值
			mul(depthValueReg, depthCommonData0Reg, positionReg.z);
			//和上行代码配合，保存了深度的1/255/255/255的精度的值
			frc(depthValueReg, depthValueReg);
			//计算多余的值
			mul(ft1, depthValueReg.yzww, depthCommonData1Reg);
			//真正的深度值 = 减去多余的(1/255)值  （精度在1/255/255/255）
			sub(out, depthValueReg, ft1);


		/*
片段着色器计算貌似有些高深。。,
其目的是使用rgba高精度方式保存深度值，并且可以从rgba中获取深度值。
此处应把深度看为255进制数据，rgba分别保存4个位(1，1/255，1/255/255,1/255/255/255)的值。
此处使用rgba分别保存（1，1/255,1/255/255,1/255/255/255）这4个不同精度的值
depth = r*1 + g/255 + b/255/255 + a/255/255/255 + x；此处有depth,r,g,b,a属于(0,1)范围;地处x<1/255/255/255,x可忽略不计

正常计算rgba的方法
r=frc(depth)-frc(depth*255)/255;
g=frc(depth*255)-frc(depth*255*255)/255;
b=frc(depth*255*255)-frc(depth*255*255)/255;
a=frc(depth*255*255*255)-frc(depth*255*255*255*255)/255;
由于无法生成depth*255*255*255*255的值，精度就定在1/255/255/255，精度只会在1/255/255/255出有损失
因此 a= frc(depth*255*255*255)


通过渲染程序推倒
mul ft0, fc0, ft2.z 		=> depth*(1,255,255*255,255*255*255)=(depth,depth*255,depth*255*255,depth*255*255*255)
frc ft0, ft0				=> (frc(depth),frc(depth*255),frc(depth*255*255),frc(depth*255*255*255))
mul ft1, ft0.yzww, fc1		=>	(frc(depth*255)/255,frc(depth*255*255)/255,frc(depth*255*255*255)/255,0)
sub oc, ft0, ft1			=>	(frc(depth)-frc(depth*255)/255,frc(depth*255)-frc(depth*255*255)/255,frc(depth*255*255)-frc(depth*255*255*255)/255,frc(depth*255*255*255))
			=>	(r,g,b,a)
			*/
		}
	}
}
