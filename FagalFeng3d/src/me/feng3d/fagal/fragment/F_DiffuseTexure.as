package me.feng3d.fagal.fragment
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 漫反射纹理取样
	 * @author warden_feng 2014-11-6
	 */
	public function F_DiffuseTexure():void
	{
		var _:* = FagalRE.instance.space;

		_.tex(_.mDiff_ft, _.uv_v, _.texture_fs);
	}
}
