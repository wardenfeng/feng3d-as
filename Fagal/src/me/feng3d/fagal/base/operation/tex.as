package me.feng3d.fagal.base.operation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.append;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsEvent;
	import me.feng3d.fagal.params.data.SampleFlagsData;

	/**
	 * 纹理取样
	 * @param	colorReg	目标寄存器
	 * @param	uvReg		UV坐标
	 * @param	textureReg	纹理寄存器
	 * @param	flags		取样参数
	 * @author warden_feng 2014-10-22
	 */
	public function tex(colorReg:Register, uvReg:Register, textureReg:Register):void
	{
		var code:String = "tex " + colorReg + ", " + uvReg + ", " + textureReg;

		//获取法线纹理采样参数
		var flags:Array = getSampleFlags(textureReg);
		if (flags && flags.length > 0)
		{
			code += " <" + flags.join(",") + ">";
		}
		append(code);

		/**
		 * 获取取样参数
		 * @param textureReg 纹理寄存器
		 * @return 取样参数
		 */
		function getSampleFlags(textureReg:Register):Array
		{
			var sampleFlagsData:SampleFlagsData = new SampleFlagsData();
			sampleFlagsData.textureRegId = textureReg.regId;
			//抛出 获取取样标记 事件
			var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
			shaderParams.dispatchEvent(new ShaderParamsEvent(ShaderParamsEvent.GET_SAMPLE_FLAGS, sampleFlagsData));
			//提取 渲染标记
			var flags:Array = sampleFlagsData.flags;
			return flags;
		}
	}


}
