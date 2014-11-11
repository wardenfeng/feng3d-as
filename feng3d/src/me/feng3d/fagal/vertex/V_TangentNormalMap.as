package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 编译切线顶点程序
	 * @author warden_feng 2014-11-7
	 */
	[FagalMethod(methodType = "vertex")]
	public class V_TangentNormalMap extends FagalMethod
	{
		[Register(regName = "normal_va_3", regType = "in", description = "法线数据")]
		public var normalInput:Register;

		[Register(regName = "tangent_va_3", regType = "in", description = "切线数据")]
		public var tangentInput:Register;

		[Register(regName = "normalglobaltransform_vc_matrix", regType = "uniform", description = "法线全局转换矩阵(物体坐标转世界坐标)")]
		public var matrix:Register;

		[Register(regName = "normal_v", regType = "out", description = "法线变量寄存器")]
		public var normalVarying:Register;

		[Register(regName = "tangent_v", regType = "out", description = "切线变量寄存器")]
		public var tangentVarying:Register;

		[Register(regName = "bitangent_v", regType = "out", description = "双切线变量寄存器")]
		public var bitangentVarying:Register;

		override public function runFunc():void
		{
			var animatedNormal:Register = getFreeTemp("动画后顶点法线临时寄存器");
			var animatedTangent:Register = getFreeTemp("动画后顶点切线临时寄存器");
			var bitanTemp:Register = getFreeTemp("动画后顶点双切线临时寄存器");

			//赋值法线数据
			mov(animatedNormal, normalInput);
			//赋值切线数据
			mov(animatedTangent, tangentInput);

			//计算顶点世界法线 vc8：模型转世界矩阵
			m33(animatedNormal.xyz, animatedNormal, matrix);
			//标准化顶点世界法线
			nrm(animatedNormal.xyz, animatedNormal);

			//计算顶点世界切线
			m33(animatedTangent.xyz, animatedTangent, matrix);
			//标准化顶点世界切线
			nrm(animatedTangent.xyz, animatedTangent);

			//计算切线x
			mov(tangentVarying.x, animatedTangent.x);
			//计算切线z
			mov(tangentVarying.z, animatedNormal.x);
			//计算切线w
			mov(tangentVarying.w, normalInput.w);
			//计算双切线x
			mov(bitangentVarying.x, animatedTangent.y);
			//计算双切线z
			mov(bitangentVarying.z, animatedNormal.y);
			//计算双切线w
			mov(bitangentVarying.w, normalInput.w);
			//计算法线x
			mov(normalVarying.x, animatedTangent.z);
			//计算法线z
			mov(normalVarying.z, animatedNormal.z);
			//计算法线w
			mov(normalVarying.w, normalInput.w);
			//计算双切线
			crs(bitanTemp.xyz, animatedNormal, animatedTangent);
			//计算切线y
			mov(tangentVarying.y, bitanTemp.x);
			//计算双切线y
			mov(bitangentVarying.y, bitanTemp.y);
			//计算法线y
			mov(normalVarying.y, bitanTemp.z);
			
			removeTemp(animatedNormal);
			removeTemp(animatedTangent);
			removeTemp(bitanTemp);
		}

	}
}
