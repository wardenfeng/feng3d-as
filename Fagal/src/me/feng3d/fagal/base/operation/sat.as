package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;
	
	/**
	 * destination=max(min(source1,1),0):将一个寄存器锁0-1的范围里
	 * @author warden_feng 2014-10-22
	 */
	public function sat(destination:IField, source1:IField):void
	{
		var code:String = "sat " + destination + ", " + source1;
		append(code);
	}
}