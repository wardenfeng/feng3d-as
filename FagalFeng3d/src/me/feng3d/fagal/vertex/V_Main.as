package me.feng3d.fagal.vertex
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.animators.AnimationType;
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagal.params.ShaderParamsAnimation;
	import me.feng3d.fagal.params.ShaderParamsCommon;
	import me.feng3d.fagal.params.ShaderParamsLight;
	import me.feng3d.fagal.params.ShaderParamsShadowMap;
	import me.feng3d.fagal.vertex.animation.V_SkeletonAnimationCPU;
	import me.feng3d.fagal.vertex.animation.V_SkeletonAnimationGPU;
	import me.feng3d.fagal.vertex.animation.V_VertexAnimationCPU;
	import me.feng3d.fagal.vertex.animation.V_VertexAnimationGPU;
	import me.feng3d.fagal.vertex.particle.V_Particles;
	import me.feng3d.fagal.vertex.shadowMap.V_ShadowMap;

	/**
	 * 顶点渲染程序主入口
	 * @author warden_feng 2014-10-30
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
			var shaderParamsLight:ShaderParamsLight = shaderParams.getComponent(ShaderParamsLight.NAME);
			var shaderParamsShadowMap:ShaderParamsShadowMap = shaderParams.getComponent(ShaderParamsShadowMap.NAME);

			buildAnimationAGAL();

			//计算世界顶点坐标
			if (shaderParamsLight.needWorldPosition)
				V_WorldPosition();

			//输出世界坐标到片段寄存器
			if (shaderParamsLight.usesGlobalPosFragment)
				V_WorldPositionOut();

			//计算投影坐标
			V_BaseOut();

			//通用渲染参数
			var common:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);
			//输出数据到片段寄存器
			if (common.needsUV > 0)
			{
				//uv数据
				var uv:Register = requestRegister(Context3DBufferTypeID.UV_VA_2);
				//uv变量数据
				var uv_v:Register = requestRegister(Context3DBufferTypeID.UV_V);
				mov(uv_v, uv);
			}

			//处理法线相关数据
			if (shaderParamsLight.needsNormals > 0)
			{
				if (shaderParamsLight.hasNormalTexture)
				{
					V_TangentNormalMap();
				}
				else
				{
					V_TangentNormalNoMap();
				}
			}

			//计算视线方向
			if (shaderParamsLight.needsViewDir > 0)
			{
				V_ViewDir();
			}

			//计算阴影相关数据
			if (shaderParamsShadowMap.usingShadowMapMethod > 0)
			{
				V_ShadowMap();
			}
		}

		/**
		 * 生成动画代码
		 */
		protected function buildAnimationAGAL():void
		{
			//动画渲染参数
			var shaderParamsAnimation:ShaderParamsAnimation = shaderParams.getComponent(ShaderParamsAnimation.NAME);
			//通用渲染参数
			var shaderParamsCommon:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);

			switch (shaderParamsAnimation.animationType)
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


