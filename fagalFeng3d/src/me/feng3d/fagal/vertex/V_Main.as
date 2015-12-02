package me.feng3d.fagal.vertex
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.animators.AnimationType;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagal.params.AnimationShaderParams;
	import me.feng3d.fagal.params.CommonShaderParams;
	import me.feng3d.fagal.params.LightShaderParams;
	import me.feng3d.fagal.params.ShadowShaderParams;
	import me.feng3d.fagal.vertex.animation.V_SkeletonAnimationCPU;
	import me.feng3d.fagal.vertex.animation.V_SkeletonAnimationGPU;
	import me.feng3d.fagal.vertex.animation.V_SpriteSheetAnimation;
	import me.feng3d.fagal.vertex.animation.V_UVAnimation;
	import me.feng3d.fagal.vertex.animation.V_VertexAnimationCPU;
	import me.feng3d.fagal.vertex.animation.V_VertexAnimationGPU;
	import me.feng3d.fagal.vertex.particle.V_Particles;
	import me.feng3d.fagal.vertex.shadowMap.V_ShadowMap;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 顶点渲染程序主入口
	 * @author feng 2014-10-30
	 */
	public class V_Main extends FagalMethod
	{
		/**
		 * 创建顶点渲染程序主入口
		 *
		 */
		public function V_Main()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		/**
		 * @inheritDoc
		 */
		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;
			var commonShaderParams:CommonShaderParams = shaderParams.getComponentByClass(CommonShaderParams);
			var animationShaderParams:AnimationShaderParams = shaderParams.getComponentByClass(AnimationShaderParams);
			var lightShaderParams:LightShaderParams = shaderParams.getComponentByClass(LightShaderParams);
			var shadowShaderParams:ShadowShaderParams = shaderParams.getComponentByClass(ShadowShaderParams);

			buildPositionAnimationAGAL();

			//计算世界顶点坐标
			if (lightShaderParams.needWorldPosition)
				V_WorldPosition();

			//输出世界坐标到片段寄存器
			if (lightShaderParams.usesGlobalPosFragment)
				V_WorldPositionOut();

			//计算投影坐标
			V_BaseOut();

			//输出数据到片段寄存器
			if (commonShaderParams.needsUV > 0)
			{
				//
				if (animationShaderParams.useUVAnimation > 0)
				{
					V_UVAnimation(_.uv_va_2, _.uv_v);
				}
				else if (animationShaderParams.useSpriteSheetAnimation > 0)
				{
					V_SpriteSheetAnimation(_.uv_va_2, _.uv_v);
				}
				else
				{
					_.mov(_.uv_v, _.uv_va_2);
				}
			}

			//处理法线相关数据
			if (lightShaderParams.needsNormals > 0)
			{
				if (lightShaderParams.hasNormalTexture)
				{
					V_TangentNormalMap();
				}
				else
				{
					V_TangentNormalNoMap();
				}
			}

			//计算视线方向
			if (lightShaderParams.needsViewDir > 0)
			{
				V_ViewDir();
			}

			//计算阴影相关数据
			if (shadowShaderParams.usingShadowMapMethod > 0)
			{
				V_ShadowMap();
			}
		}

		/**
		 * 生成动画代码
		 */
		protected function buildPositionAnimationAGAL():void
		{
			var animationShaderParams:AnimationShaderParams = shaderParams.getComponentByClass(AnimationShaderParams);

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


