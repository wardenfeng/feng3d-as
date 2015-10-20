package me.feng3d.fagal.fragment
{
	import me.feng3d.fagalRE.FagalRE;


	/**
	 * 漫反射材质颜色
	 * @author feng 2014-11-6
	 */
	public function F_DiffuseColor():void
	{
		var _:* = FagalRE.instance.space;

		//漫射输入静态数据 
		_.mov(_.mDiff_ft, _.diffuseInput_fc_vector);
	}
}
