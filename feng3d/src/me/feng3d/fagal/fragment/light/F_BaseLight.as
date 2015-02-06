package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalFragmentMethod;

	/**
	 * 光照基本计算所需函数
	 * @author warden_feng 2014-11-8
	 */
	public class F_BaseLight extends FagalFragmentMethod
	{
		[Register(regName = "commonsData_fc_vector", regType = "uniform", description = "公用数据片段常量数据")]
		public var commonsReg:Register;

		[Register(regName = "specularData_fc_vector", regType = "uniform", description = "材质镜面反射光数据")]
		public var _specularDataRegister:Register;

		[Register(regName = "specularTexData_ft_4", regType = "in", description = "光泽纹理数据片段临时寄存器")]
		public var specularTexData:Register;

		[Register(regName = "normal_ft_4", regType = "in", description = "法线临时片段寄存器")]
		public var normalFragmentReg:Register;

		[Register(regName = "viewDir_ft_4", regType = "in", description = "视线方向片段临时数据")]
		public var viewDirReg:Register;

		[Register(regName = "totalDiffuseLightColor_ft_4", regType = "out", description = "总漫反射颜色寄存器")]
		public var totalLightColorReg:Register;

		[Register(regName = "totalSpecularLightColor_ft_4", regType = "out", description = "总镜面反射颜色寄存器")]
		public var totalSpecularColorReg:Register;

		protected function getDiffCodePerLight(lightDirReg:Register, diffuseColorReg:Register, _isFirstLight:Boolean):void
		{
			var diffuseColorFtReg:Register;
			if (_isFirstLight)
			{
				diffuseColorFtReg = totalLightColorReg;
			}
			else
			{
				diffuseColorFtReg = getFreeTemp("单个漫反射光寄存器")
			}

			//计算灯光方向与法线夹角
			dp3(diffuseColorFtReg.x, lightDirReg, normalFragmentReg);
			//过滤负数
			max(diffuseColorFtReg.w, diffuseColorFtReg.x, commonsReg.y);

			//灯光衰减
			if (shaderParams.useLightFallOff)
				mul(diffuseColorFtReg.w, diffuseColorFtReg.w, lightDirReg.w);

			//计算灯光颜色
			mul(diffuseColorFtReg, diffuseColorFtReg.w, diffuseColorReg);

			//叠加灯光
			if (!_isFirstLight)
			{
				add(totalLightColorReg.xyz, totalLightColorReg, diffuseColorFtReg);
				removeTemp(diffuseColorFtReg);
			}
		}

		protected function getSpecCodePerLight(lightDirReg:Register, specularColorReg:Register, _isFirstLight:Boolean):void
		{
			//镜面反射光原理
			//法线 = 入射光方向 - 反射光方向------------1
			//物理光学已知：当视线方向与反射光方向相反时，反射光达到最亮。反射光强度和（反射光方向与-视线方向 的 夹角余弦值）相关
			//反射光方向与-视线 的 夹角 ---(代入1)--> (入射光方向 - 法线) 与 -视线 的 夹角 ----> 入射光方向+视线 与 法线的夹角
			//反射光方向与-视线方向 的 夹角余弦值 == 入射光方向+视线 与 法线 的 夹角余弦值  == 反射光强度

			var singleSpecularColorReg:Register;
			if (_isFirstLight)
			{
				singleSpecularColorReg = totalSpecularColorReg;
			}
			else
			{
				singleSpecularColorReg = getFreeTemp("单个镜面反射光寄存器");
			}

			//入射光与视线方向的和 = 光照场景方向 add 标准视线方向
			add(singleSpecularColorReg, lightDirReg, viewDirReg);
			//标准化入射光与视线的和
			nrm(singleSpecularColorReg.xyz, singleSpecularColorReg);
			//镜面反射光强度 = 法线 dp3 入射光与视线方向的和
			dp3(singleSpecularColorReg.w, normalFragmentReg, singleSpecularColorReg);
			//镜面反射光强度 锁定在0-1之间
			sat(singleSpecularColorReg.w, singleSpecularColorReg.w);

			if (shaderParams.hasSpecularTexture)
			{
				//使用光照图调整高光
				mul(specularTexData.w, specularTexData.y, _specularDataRegister.w);
				pow(singleSpecularColorReg.w, singleSpecularColorReg.w, specularTexData.w);
			}
			else
			{
				//镜面反射光强度 = 镜面反射光强度 pow 光泽度
				pow(singleSpecularColorReg.w, singleSpecularColorReg.w, _specularDataRegister.w);
			}

			if (shaderParams.useLightFallOff)
			{
				//镜面反射光强度 = 镜面反射强度  nul (入射光强度？)
				mul(singleSpecularColorReg.w, singleSpecularColorReg.w, lightDirReg.w);
			}

			//镜面反射光颜色 = 灯光镜面反射颜色 mul 镜面反射光强度
			mul(singleSpecularColorReg.xyz, specularColorReg, singleSpecularColorReg.w);

			//叠加镜面反射光
			if (!_isFirstLight)
			{
				//总镜面反射光 = 总镜面反射光 + 单个镜面反射光
				add(totalSpecularColorReg.xyz, totalSpecularColorReg, singleSpecularColorReg);
				removeTemp(singleSpecularColorReg);
			}
		}
	}
}
