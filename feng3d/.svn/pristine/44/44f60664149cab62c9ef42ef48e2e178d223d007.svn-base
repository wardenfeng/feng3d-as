package me.feng3d.fagal.base.operation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.base.append;

	/**
	 * m44:由一个4*4的矩阵对一个4分量的向量进行矩阵乘法
	 * <br/>
	 * destination.x=(source1.x*source2[0].x)+(source1.y*source2[0].y)+(source1.z*source2[0].z)+(source1.w*source2[0].w)
	 * <br/>
	 * destination.y=(source1.x*source2[1].x)+(source1.y*source2[1].y)+(source1.z*source2[1].z)+(source1.w*source2[1].w)
	 * <br/>
	 * destination.z=(source1.x*source2[2].x)+(source1.y*source2[2].y)+(source1.z*source2[2].z)+(source1.w*source2[2].w)
	 * <br/>
	 * destination.w=(source1.x*source2[3].x)+(source1.y*source2[3].y)+(source1.z*source2[3].z)+(source1.w*source2[3].w)
	 * @author warden_feng 2014-10-22
	 */
	public function m44(destination:Register, source1:Register, source2:RegisterMatrix):void
	{
		var code:String = "m44 " + destination + ", " + source1 + ", " + source2;
		append(code);
	}
}
