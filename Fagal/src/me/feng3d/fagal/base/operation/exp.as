package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;

	/**
	 * destination=2^source1:2的source1次方，分量形式
	 * @author warden_feng 2014-10-22
	 */
	public function exp(destination:IField, source1:IField):void
	{
		var code:String = "exp " + destination + ", " + source1;
		append(code);
	}
}

