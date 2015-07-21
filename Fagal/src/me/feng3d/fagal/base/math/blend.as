package me.feng3d.fagal.base.math
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.sub;

	/**
	 * 混合数据
	 * <p>destination = source1 + (source2-source1) x factor</p>
	 * @author warden_feng 2015-7-4
	 */
	public function blend(destination:IField, source1:IField, source2:IField, factor:IField):void
	{
		sub(source2, source2, source1);
		mul(source2, source2, factor);
		add(destination, source1, source2);
	}
}
