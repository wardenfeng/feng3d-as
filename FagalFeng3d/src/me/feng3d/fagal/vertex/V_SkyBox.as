package me.feng3d.fagal.vertex
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.requestRegisterMatrix;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.m44;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 天空盒顶点渲染程序
	 * @author warden_feng 2014-11-4
	 */
	public class V_SkyBox extends FagalMethod
	{
		public function V_SkyBox()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		override public function runFunc():void
		{
			//顶点坐标数据
			var position:Register = requestRegister(Context3DBufferTypeID.position_va_3);
			//uv变量数据
			var uv_v:Register = requestRegister(Context3DBufferTypeID.uv_v);
			//顶点程序投影矩阵静态数据
			var projection:RegisterMatrix = requestRegisterMatrix(Context3DBufferTypeID.projection_vc_matrix);
			//摄像机位置静态数据
			var camerapos:Register = requestRegister(Context3DBufferTypeID.camerapos_vc_vector);
			//天空盒缩放静态数据
			var scaleSkybox:Register = requestRegister(Context3DBufferTypeID.scaleSkybox_vc_vector);
			//位置输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeID._op);

			var vt0:Register = getFreeTemp("缩放后的顶点坐标");
			comment("缩放到天空盒应有的大小");
			mul(vt0, position, scaleSkybox);
			comment("把天空盒中心放到摄像机位置");
			add(vt0, vt0, camerapos);
			comment("投影天空盒坐标");
			m44(out, vt0, projection)
			comment("占坑用的，猜的");
			mov(uv_v, position);
		}
	}
}


