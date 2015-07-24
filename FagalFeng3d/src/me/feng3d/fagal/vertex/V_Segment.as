package me.feng3d.fagal.vertex
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.getFreeTemp;
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
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

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
			var _:* = FagalRE.instance.space;

			var cStartPosReg:Register = getFreeTemp("摄像机空间起点坐标");
			var cEndPosReg:Register = getFreeTemp("摄像机空间终点坐标");
			var lenghtReg:Register = getFreeTemp("线段长度");
			var temp3:Register = getFreeTemp("");
			var temp4:Register = getFreeTemp("");
			var temp5:Register = getFreeTemp("");

			comment("计算相机坐标系起点位置、终点位置、线段距离");
			m44(cStartPosReg, _.segmentStart_va_3, _.segmentM2cMatrix_vc_matrix);
			m44(cEndPosReg, _.segmentEnd_va_3, _.segmentM2cMatrix_vc_matrix);
			sub(lenghtReg, cEndPosReg, cStartPosReg);

			// test if behind camera near plane
			// if 0 - Q0.z < Camera.near then the point needs to be clipped
			//"neg "+temp5+".x, "+temp0+".z				\n" + // 0 - Q0.z
			slt(temp5.x, cStartPosReg.z, _.segmentConstants_vc_vector.z); // behind = ( 0 - Q0.z < -Camera.near ) ? 1 : 0
			sub(temp5.y, _.segmentOne_vc_vector.x, temp5.x); // !behind = 1 - behind

			// p = point on the plane (0,0,-near)
			// n = plane normal (0,0,-1)
			// D = Q1 - Q0
			// t = ( dot( n, ( p - Q0 ) ) / ( dot( n, d )

			// solve for t where line crosses Camera.near
			add(temp4.x, cStartPosReg.z, _.segmentConstants_vc_vector.z); // Q0.z + ( -Camera.near )
			sub(temp4.y, cStartPosReg.z, cEndPosReg.z); // Q0.z - Q1.z

			// fix divide by zero for horizontal lines
			seq(temp4.z, temp4.y, _.segmentFront_vc_vector.x); // offset = (Q0.z - Q1.z)==0 ? 1 : 0
			add(temp4.y, temp4.y, temp4.z); // ( Q0.z - Q1.z ) + offset

			div(temp4.z, temp4.x, temp4.y); // t = ( Q0.z - near ) / ( Q0.z - Q1.z )

			mul(temp4.xyz, temp4.zzz, lenghtReg.xyz); // t(L)
			add(temp3.xyz, cStartPosReg.xyz, temp4.xyz); // Qclipped = Q0 + t(L)
			mov(temp3.w, _.segmentOne_vc_vector.x); // Qclipped.w = 1

			// If necessary, replace Q0 with new Qclipped
			mul(cStartPosReg, cStartPosReg, temp5.yyyy); // !behind * Q0
			mul(temp3, temp3, temp5.xxxx); // behind * Qclipped
			add(cStartPosReg, cStartPosReg, temp3); // newQ0 = Q0 + Qclipped

			// calculate side vector for line
			sub(lenghtReg, cEndPosReg, cStartPosReg); // L = Q1 - Q0
			nrm(lenghtReg.xyz, lenghtReg.xyz); // normalize( L )
			nrm(temp5.xyz, cStartPosReg.xyz); // D = normalize( Q1 )
			mov(temp5.w, _.segmentOne_vc_vector.x); // D.w = 1
			crs(temp3.xyz, lenghtReg, temp5); // S = L x D
			nrm(temp3.xyz, temp3.xyz); // normalize( S )

			// face the side vector properly for the given point
			mul(temp3.xyz, temp3.xyz, _.segmentThickness_va_1.xxx); // S *= weight
			mov(temp3.w, _.segmentOne_vc_vector.x); // S.w = 1

			// calculate the amount required to move at the point's distance to correspond to the line's pixel width
			// scale the side vector by that amount
			dp3(temp4.x, cStartPosReg, _.segmentFront_vc_vector); // distance = dot( view )
			mul(temp4.x, temp4.x, _.segmentConstants_vc_vector.x); // distance *= vpsod
			mul(temp3.xyz, temp3.xyz, temp4.xxx); // S.xyz *= pixelScaleFactor

			// add scaled side vector to Q0 and transform to clip space
			add(cStartPosReg.xyz, cStartPosReg.xyz, temp3.xyz); // Q0 + S

			m44(_._op, cStartPosReg, _.segmentC2pMatrix_vc_matrix); // transform Q0 to clip space

			// interpolate color
			mov(_.color_v, _.segmentColor_va_4);
		}
	}
}


