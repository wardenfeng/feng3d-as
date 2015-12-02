package me.feng3d.fagal.vertex.shadowMap
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.animators.AnimationType;
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagal.params.AnimationShaderParams;
	import me.feng3d.fagal.vertex.V_BaseAnimation;
	import me.feng3d.fagal.vertex.animation.V_SkeletonAnimationCPU;
	import me.feng3d.fagal.vertex.animation.V_SkeletonAnimationGPU;
	import me.feng3d.fagal.vertex.animation.V_VertexAnimationCPU;
	import me.feng3d.fagal.vertex.animation.V_VertexAnimationGPU;
	import me.feng3d.fagal.vertex.particle.V_Particles;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 平面阴影顶点主程序
	 * @author feng 2015-5-30
	 */
	public class V_Main_PlanarShadow extends FagalMethod
	{
		/**
		 * 构建 深度图顶点主程序
		 */
		public function V_Main_PlanarShadow()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		/**
		 * @inheritDoc
		 */
		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			buildAnimationAGAL();

			var outPosition:Register = _.getFreeTemp("投影后的坐标");
			//计算投影
			_.m44(outPosition, _.animatedPosition_vt_4, _.projection_vc_matrix);
			//输出顶点坐标数据			
			_.mov(_._op, outPosition);
			//把顶点投影坐标输出到片段着色器
			_.mov(_.positionProjected_v, outPosition);
		}

		/**
		 * 生成动画代码
		 */
		protected function buildAnimationAGAL():void
		{
			var animationShaderParams:AnimationShaderParams = shaderParams.getComponent(AnimationShaderParams.NAME);

			switch (animationShaderParams.animationType)
			{
				case AnimationType.NONE:
					V_BaseAnimation();
					break;
				case AnimationType.VERTEX_CPU:
					V_VertexAnimationCPU();
					break;
				case AnimationType.VERTEX_GPU:
					V_VertexAnimationGPU();
					break;
				case AnimationType.SKELETON_CPU:
					V_SkeletonAnimationCPU();
					break;
				case AnimationType.SKELETON_GPU:
					V_SkeletonAnimationGPU();
					break;
				case AnimationType.PARTICLE:
					V_Particles();
					break;
				default:
					throw new Error(AnimationType.PARTICLE + "类型动画缺少FAGAL代码");
					break;
			}
		}
	}
}
