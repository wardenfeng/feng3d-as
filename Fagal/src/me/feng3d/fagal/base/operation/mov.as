package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.base.append;

	/**
	 * mov:destination=source :将数据从源寄存器复制到目标寄存器
	 * @author warden_feng 2014-10-22
	 */
	public function mov(destination:*, source1:*):void
	{
		var code:String = "mov " + destination + ", " + source1;
		append(code);
	}
}
