package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;

	/**
	 * destination=1/source1:一个寄存器的倒数，分量形式
	 * @author warden_feng 2014-10-22
	 */
	public function rcp(destination:IField, source1:IField):void
	{
		var code:String = "rcp " + destination + ", " + source1;
		append(code);
	}
}

