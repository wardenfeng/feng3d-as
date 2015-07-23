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
	import me.feng3d.fagal.base.operation.crs;
	import me.feng3d.fagal.base.operation.div;
	import me.feng3d.fagal.base.operation.dp3;
	import me.feng3d.fagal.base.operation.m44;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.nrm;
	import me.feng3d.fagal.base.operation.seq;
	import me.feng3d.fagal.base.operation.slt;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 线段顶点渲染程序
	 * @author warden_feng 2014-10-28
	 */
	public class V_Segment extends FagalMethod
	{
		public function V_Segment()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		override public function runFunc():void
		{
			//起点坐标寄存器
			var startPositionReg:Register = requestRegister(Context3DBufferTypeID.segmentStart_va_3);
			//终点坐标寄存器
			var endPositionReg:Register = requestRegister(Context3DBufferTypeID.segmentEnd_va_3);
			//线段厚度寄存器
			var thicknessReg:Register = requestRegister(Context3DBufferTypeID.segmentThickness_va_1);
			//顶点颜色寄存器
			var colorReg:Register = requestRegister(Context3DBufferTypeID.segmentColor_va_4);
			//摄像机坐标系到投影坐标系变换矩阵寄存器
			var c2pMatrixReg:RegisterMatrix = requestRegisterMatrix(Context3DBufferTypeID.segmentC2pMatrix_vc_matrix);
			//模型坐标系到摄像机坐标系变换矩阵寄存器
			var m2cMatrixReg:RegisterMatrix = requestRegisterMatrix(Context3DBufferTypeID.segmentM2cMatrix_vc_matrix);
			//常数1寄存器
			var oneReg:Register = requestRegister(Context3DBufferTypeID.segmentOne_vc_vector);
			//常数前向量寄存器
			var frontReg:Register = requestRegister(Context3DBufferTypeID.segmentFront_vc_vector);
			//常数寄存器
			var constantsReg:Register = requestRegister(Context3DBufferTypeID.segmentConstants_vc_vector);
			//颜色变量寄存器
			var color_v:Register = requestRegister("color_v");
			//位置输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeID._op);

			var cStartPosReg:Register = getFreeTemp("摄像机空间起点坐标");
			var cEndPosReg:Register = getFreeTemp("摄像机空间终点坐标");
			var lenghtReg:Register = getFreeTemp("线段长度");
			var temp3:Register = getFreeTemp("");
			var temp4:Register = getFreeTemp("");
			var temp5:Register = getFreeTemp("");

			comment("计算相机坐标系起点位置、终点位置、线段距离");
			m44(cStartPosReg, startPositionReg, m2cMatrixReg);
			m44(cEndPosReg, endPositionReg, m2cMatrixReg);
			sub(lenghtReg, cEndPosReg, cStartPosReg);

			// test if behind camera near plane
			// if 0 - Q0.z < Camera.near then the point needs to be clipped
			//"neg "+temp5+".x, "+temp0+".z				\n" + // 0 - Q0.z
			slt(temp5.x, cStartPosReg.z, constantsReg.z); // behind = ( 0 - Q0.z < -Camera.near ) ? 1 : 0
			sub(temp5.y, oneReg.x, temp5.x); // !behind = 1 - behind

			// p = point on the plane (0,0,-near)
			// n = plane normal (0,0,-1)
			// D = Q1 - Q0
			// t = ( dot( n, ( p - Q0 ) ) / ( dot( n, d )

			// solve for t where line crosses Camera.near
			add(temp4.x, cStartPosReg.z, constantsReg.z); // Q0.z + ( -Camera.near )
			sub(temp4.y, cStartPosReg.z, cEndPosReg.z); // Q0.z - Q1.z

			// fix divide by zero for horizontal lines
			seq(temp4.z, temp4.y, frontReg.x); // offset = (Q0.z - Q1.z)==0 ? 1 : 0
			add(temp4.y, temp4.y, temp4.z); // ( Q0.z - Q1.z ) + offset

			div(temp4.z, temp4.x, temp4.y); // t = ( Q0.z - near ) / ( Q0.z - Q1.z )

			mul(temp4.xyz, temp4.zzz, lenghtReg.xyz); // t(L)
			add(temp3.xyz, cStartPosReg.xyz, temp4.xyz); // Qclipped = Q0 + t(L)
			mov(temp3.w, oneReg.x); // Qclipped.w = 1

			// If necessary, replace Q0 with new Qclipped
			mul(cStartPosReg, cStartPosReg, temp5.yyyy); // !behind * Q0
			mul(temp3, temp3, temp5.xxxx); // behind * Qclipped
			add(cStartPosReg, cStartPosReg, temp3); // newQ0 = Q0 + Qclipped

			// calculate side vector for line
			sub(lenghtReg, cEndPosReg, cStartPosReg); // L = Q1 - Q0
			nrm(lenghtReg.xyz, lenghtReg.xyz); // normalize( L )
			nrm(temp5.xyz, cStartPosReg.xyz); // D = normalize( Q1 )
			mov(temp5.w, oneReg.x); // D.w = 1
			crs(temp3.xyz, lenghtReg, temp5); // S = L x D
			nrm(temp3.xyz, temp3.xyz); // normalize( S )

			// face the side vector properly for the given point
			mul(temp3.xyz, temp3.xyz, thicknessReg.xxx); // S *= weight
			mov(temp3.w, oneReg.x); // S.w = 1

			// calculate the amount required to move at the point's distance to correspond to the line's pixel width
			// scale the side vector by that amount
			dp3(temp4.x, cStartPosReg, frontReg); // distance = dot( view )
			mul(temp4.x, temp4.x, constantsReg.x); // distance *= vpsod
			mul(temp3.xyz, temp3.xyz, temp4.xxx); // S.xyz *= pixelScaleFactor

			// add scaled side vector to Q0 and transform to clip space
			add(cStartPosReg.xyz, cStartPosReg.xyz, temp3.xyz); // Q0 + S

			m44(out, cStartPosReg, c2pMatrixReg); // transform Q0 to clip space

			// interpolate color
			mov(color_v, colorReg);
		}
	}
}


