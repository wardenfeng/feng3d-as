package me.feng3d.fagal.fragment
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.tex;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 天空盒片段渲染程序
	 * @author warden_feng 2014-11-4
	 */
	public class F_SkyBox extends FagalMethod
	{
		public function F_SkyBox()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		override public function runFunc():void
		{
			//片段程序的纹理
			var texture:Register = requestRegister(Context3DBufferTypeID.texture_fs);
			//uv变量数据
			var uv_v:Register = requestRegister(Context3DBufferTypeID.uv_v);
			//颜色输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeID._oc);

			//获取纹理数据
			tex(out, uv_v, texture);
		}
	}
}
