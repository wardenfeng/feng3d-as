package me.feng3d.fagal.vertex
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	
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

			var cStartPosReg:Register = _.getFreeTemp("摄像机空间起点坐标");
			var cEndPosReg:Register = _.getFreeTemp("摄像机空间终点坐标");
			var lenghtReg:Register = _.getFreeTemp("线段长度");
			var temp3:Register = _.getFreeTemp("");
			var temp4:Register = _.getFreeTemp("");
			var temp5:Register = _.getFreeTemp("");

			_.comment("计算相机坐标系起点位置、终点位置、线段距离");
			_.m44(cStartPosReg, _.segmentStart_va_3, _.segmentM2cMatrix_vc_matrix);
			_.m44(cEndPosReg, _.segmentEnd_va_3, _.segmentM2cMatrix_vc_matrix);
			_.sub(lenghtReg, cEndPosReg, cStartPosReg);

			// test if behind camera near plane
			// if 0 - Q0.z < Camera.near then the point needs to be clipped
			//"neg "+temp5+".x, "+temp0+".z				\n" + // 0 - Q0.z
			_.slt(temp5.x, cStartPosReg.z, _.segmentConstants_vc_vector.z); // behind = ( 0 - Q0.z < -Camera.near ) ? 1 : 0
			_.sub(temp5.y, _.segmentOne_vc_vector.x, temp5.x); // !behind = 1 - behind

			// p = point on the plane (0,0,-near)
			// n = plane normal (0,0,-1)
			// D = Q1 - Q0
			// t = ( dot( n, ( p - Q0 ) ) / ( dot( n, d )

			// solve for t where line crosses Camera.near
			_.add(temp4.x, cStartPosReg.z, _.segmentConstants_vc_vector.z); // Q0.z + ( -Camera.near )
			_.sub(temp4.y, cStartPosReg.z, cEndPosReg.z); // Q0.z - Q1.z

			// fix divide by zero for horizontal lines
			_.seq(temp4.z, temp4.y, _.segmentFront_vc_vector.x); // offset = (Q0.z - Q1.z)==0 ? 1 : 0
			_.add(temp4.y, temp4.y, temp4.z); // ( Q0.z - Q1.z ) + offset

			_.div(temp4.z, temp4.x, temp4.y); // t = ( Q0.z - near ) / ( Q0.z - Q1.z )

			_.mul(temp4.xyz, temp4.zzz, lenghtReg.xyz); // t(L)
			_.add(temp3.xyz, cStartPosReg.xyz, temp4.xyz); // Qclipped = Q0 + t(L)
			_.mov(temp3.w, _.segmentOne_vc_vector.x); // Qclipped.w = 1

			// If necessary, replace Q0 with new Qclipped
			_.mul(cStartPosReg, cStartPosReg, temp5.yyyy); // !behind * Q0
			_.mul(temp3, temp3, temp5.xxxx); // behind * Qclipped
			_.add(cStartPosReg, cStartPosReg, temp3); // newQ0 = Q0 + Qclipped

			// calculate side vector for line
			_.sub(lenghtReg, cEndPosReg, cStartPosReg); // L = Q1 - Q0
			_.nrm(lenghtReg.xyz, lenghtReg.xyz); // normalize( L )
			_.nrm(temp5.xyz, cStartPosReg.xyz); // D = normalize( Q1 )
			_.mov(temp5.w, _.segmentOne_vc_vector.x); // D.w = 1
			_.crs(temp3.xyz, lenghtReg, temp5); // S = L x D
			_.nrm(temp3.xyz, temp3.xyz); // normalize( S )

			// face the side vector properly for the given point
			_.mul(temp3.xyz, temp3.xyz, _.segmentThickness_va_1.xxx); // S *= weight
			_.mov(temp3.w, _.segmentOne_vc_vector.x); // S.w = 1

			// calculate the amount required to move at the point's distance to correspond to the line's pixel width
			// scale the side vector by that amount
			_.dp3(temp4.x, cStartPosReg, _.segmentFront_vc_vector); // distance = dot( view )
			_.mul(temp4.x, temp4.x, _.segmentConstants_vc_vector.x); // distance *= vpsod
			_.mul(temp3.xyz, temp3.xyz, temp4.xxx); // S.xyz *= pixelScaleFactor

			// add scaled side vector to Q0 and transform to clip space
			_.add(cStartPosReg.xyz, cStartPosReg.xyz, temp3.xyz); // Q0 + S

			_.m44(_._op, cStartPosReg, _.segmentC2pMatrix_vc_matrix); // transform Q0 to clip space

			// interpolate color
			_.mov(_.color_v, _.segmentColor_va_4);
		}
	}
}


