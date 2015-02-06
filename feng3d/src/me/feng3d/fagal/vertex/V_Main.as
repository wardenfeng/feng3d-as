package me.feng3d.fagal.vertex
{
	import me.feng3d.animators.AnimationType;
	import me.feng3d.fagal.methods.FagalVertexMethod;
	import me.feng3d.fagal.vertex.animation.V_SkeletonAnimationCPU;
	import me.feng3d.fagal.vertex.animation.V_SkeletonAnimationGPU;
	import me.feng3d.fagal.vertex.animation.V_VertexAnimationCPU;
	import me.feng3d.fagal.vertex.animation.V_VertexAnimationGPU;
	import me.feng3d.fagal.vertex.particle.V_Particles;

	/**
	 * 顶点渲染程序主入口
	 * @author warden_feng 2014-10-30
	 */
	public class V_Main extends FagalVertexMethod
	{
		override public function runFunc():void
		{
			//生成动画代码
			buildAnimationAGAL();

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

		/**
		 * 生成动画代码
		 */
		protected function buildAnimationAGAL():void
		{
			switch (shaderParams.animationType)
			{
				case AnimationType.NONE:
					call(V_BaseAnimation);
					break;
				case AnimationType.VERTEX_CPU:
					call(V_VertexAnimationCPU);
					break;
				case AnimationType.VERTEX_GPU:
					call(V_VertexAnimationGPU);
					break;
				case AnimationType.SKELETON_CPU:
					call(V_SkeletonAnimationCPU);
					break;
				case AnimationType.SKELETON_GPU:
					call(V_SkeletonAnimationGPU);
					break;
				case AnimationType.PARTICLE:
					call(V_Particles);
					break;
				default:
					throw new Error(AnimationType.PARTICLE + "类型动画缺少FAGAL代码");
					break;
			}
		}
	}
}
