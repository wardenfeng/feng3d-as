package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;

	/**
	 * 如果寄存器有任意一个分量小于0，则丢弃该像素不进行绘制(只适用于片段着色器)
	 * @author warden_feng 2014-10-22
	 */
	public function kil(destination:IField, source1:IField):void
	{
		var code:String = "kil " + source1;
		append(code);
	}
}

