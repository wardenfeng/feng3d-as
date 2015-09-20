package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * Sprite动画顶点渲染程序
	 * @author warden_feng 2015-9-5
	 */
	public function V_SpriteSheetAnimation(UVSource:Register, UVTarget:Register):void
	{
		var _:* = FagalRE.instance.space;

		var tempUV:Register = _.getFreeTemp();

		var constantRegID:Register = _.spriteSheetVectorFrame_vc_vector;

		//计算平移缩放
		_.mov(tempUV, UVSource);
		_.mul(tempUV.xy, tempUV.xy, constantRegID.zw);
		_.add(tempUV.xy, tempUV.xy, constantRegID.xy);
		_.mov(UVTarget, tempUV);
	}
}
