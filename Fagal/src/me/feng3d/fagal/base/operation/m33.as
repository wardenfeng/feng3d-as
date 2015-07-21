package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;
	
	/**
	 * m33:由一个3*3的矩阵对一个3分量的向量进行矩阵乘法
	 * <br/>
	 * destination.x=(source1.x*source2[0].x)+(source1.y*source2[0].y)+(source1.z*source2[0].z)
	 * <br/>
	 * destination.y=(source1.x*source2[1].x)+(source1.y*source2[1].y)+(source1.z*source2[1].z)
	 * <br/>
	 * destination.z=(source1.x*source2[2].x)+(source1.y*source2[2].y)+(source1.z*source2[2].z)
	 * @author warden_feng 2014-10-22
	 */
	public function m33(destination:IField, source1:IField, source2:IField):void
	{
		var code:String = "m33 " + destination + ", " + source1 + ", " + source2;
		append(code);
	}
}