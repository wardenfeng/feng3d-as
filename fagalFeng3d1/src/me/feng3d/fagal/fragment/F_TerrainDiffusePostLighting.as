package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 地形渲染函数
	 * @author feng 2014-11-6
	 */
	public function F_TerrainDiffusePostLighting():void
	{
		var _:* = FagalRE.instance.space;

		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var numSplattingLayers:int = shaderParams.splatNum;

		//缩放后的uv坐标、uv计算后的颜色值
		var uvTemp:Register = _.getFreeTemp("缩放后的uv坐标");
		//混合比例（4个分量表示4个纹理所占比重）
		var blendTemp:Register = _.getFreeTemp("混合比例");

		_.mul(uvTemp, _.uv_v, _.tile_fc_vector.c(0)); // 缩放uv （表示将重复x*x遍） x=scaleRegister.c(0)

		_.tex(_.finalColor_ft_4, uvTemp, _.texture_fs); // 使用默认贴图 得到默认颜色值
		_.tex(blendTemp, _.uv_v, _.blendingtexture_fs); // 计算混合纹理

		for (var i:int = 0; i < numSplattingLayers; ++i)
		{
			_.mul(uvTemp, _.uv_v, _.tile_fc_vector.c(i + 1)); //  缩放uv （表示将重复x*x遍） x=scaleRegister.c(i + 1)
			_.tex(uvTemp, uvTemp, _.terrainTextures_fs_array.getReg(i)); // 使用地面纹理 得到该纹理颜色值

			_.sub(uvTemp, uvTemp, _.finalColor_ft_4); // uvtemp = uvtemp - targetreg; --------------1
			_.mul(uvTemp, uvTemp, blendTemp.c(i)); // uvtemp = uvtemp * blendtemp; ----------2  (0 <= blendtemp <= 1)
			_.add(_.finalColor_ft_4, _.finalColor_ft_4, uvTemp); // 添加到默认颜色值上  targetreg = targetreg + uvtemp; ------------3
				//由 1代入2得		uvtemp = (uvtemp - targetreg) * blendtemp; ----------------4
				//由 4代入3得		targetreg = targetreg + (uvtemp - targetreg) * blendtemp; -------------------5
				//整理5得			targetreg = targetreg * (1 - blendtemp) + uvtemp * blendtemp; (0 <= blendtemp <= 1) -----------------6 
				//公式6很容易看出是平分公式，由此得 引用1、2、3的渲染代码是为了节约变量与计算次数的平分运算。(至少节约1个变量与一次运算)
		}
	}
}
