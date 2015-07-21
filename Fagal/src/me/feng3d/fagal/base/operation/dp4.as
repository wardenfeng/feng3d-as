package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;

	/**
	 * dp4:两个寄存器间的点积，4分量
	 * <br/>
	 * destination=source1.x*source2.x+source1.y*source2.y+source1.z*source2.z+source1.w+source2.w
	 * @author warden_feng 2014-10-22
	 */
	public function dp4(destination:IField, source1:IField, source2:IField):void
	{
		var code:String = "dp4 " + destination + ", " + source1 + ", " + source2;
		append(code);
	}
}
