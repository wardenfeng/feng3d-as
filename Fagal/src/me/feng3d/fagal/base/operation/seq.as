package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;

	/**
	 * destination= source1==source2 ? 1 : 0
	 * @author warden_feng 2014-10-22
	 */
	public function seq(destination:IField, source1:IField, source2:IField):void
	{
		var code:String="seq " + destination + ", " + source1 + ", " + source2;
		append(code);
	}
}

