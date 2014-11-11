package me.feng3d.fagal.vertex
{
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 顶点渲染程序主入口
	 * @author warden_feng 2014-10-30
	 */
	[FagalMethod(methodType = "vertex")]
	public class V_Main extends FagalMethod
	{
		override public function runFunc():void
		{
			if (shaderParams.hasAnimation)
				call(shaderParams.animationFagalMethod);
			else
				call(V_BaseAnimation);

			if (shaderParams.needWorldPosition)
				call(V_WorldPosition);

			if (shaderParams.usesGlobalPosFragment)
				call(V_WorldPositionOut);

			//计算投影坐标
			call(V_BaseOut);

			//输出数据到片段寄存器
			if (shaderParams.needsUV)
				call(V_BaseUV);

			if (shaderParams.needsNormals)
				if (shaderParams.hasNormalTexture)
					call(V_TangentNormalMap);
				else
					call(V_TangentNormalNoMap);

			if (shaderParams.needsViewDir)
				call(V_ViewDir);
		}
	}
}
