package me.feng3d.fagal.vertex
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.animators.AnimationType;
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagal.params.ShaderParamsAnimation;
	import me.feng3d.fagal.params.ShaderParamsCommon;
	import me.feng3d.fagal.params.ShaderParamsLight;
	import me.feng3d.fagal.params.ShaderParamsShadowMap;
	import me.feng3d.fagal.register.ShaderRegisterAnimation;
	import me.feng3d.fagal.register.ShaderRegisterCommon;
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

			//生成动画代码
			var animatedPosition:Register = buildAnimationAGAL();

			//顶点世界坐标
			var positionSceneReg:Register;

			//计算世界顶点坐标
			if (shaderParamsLight.needWorldPosition)
				positionSceneReg = V_WorldPosition();

			//输出世界坐标到片段寄存器
			if (shaderParamsLight.usesGlobalPosFragment)
				V_WorldPositionOut(positionSceneReg);

			//计算投影坐标
			V_BaseOut();

			//通用渲染参数
			var common:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);
			//输出数据到片段寄存器
			if (common.needsUV > 0)
			{
				//uv数据
				var uv:Register = requestRegister(Context3DBufferTypeIDCommon.UV_VA_2);
				//uv变量数据
				var uv_v:Register = requestRegister(Context3DBufferTypeIDCommon.UV_V);
				mov(uv_v, uv);
			}

			//处理法线相关数据
			if (shaderParamsLight.needsNormals > 0)
			{
				if (shaderParamsLight.hasNormalTexture)
				{
					//法线数据
					var normalInput:Register = requestRegister(Context3DBufferTypeID.NORMAL_VA_3);
					//切线数据
					var tangentInput:Register = requestRegister(Context3DBufferTypeID.TANGENT_VA_3);
					//法线场景变换矩阵(模型空间转场景空间)
					var matrix:Register = requestRegister(Context3DBufferTypeID.NORMALSCENETRANSFORM_VC_MATRIX);
					//切线变量寄存器
					var tangentVarying:Register = requestRegister(Context3DBufferTypeID.TANGENT_V);
					//双切线变量寄存器
					var bitangentVarying:Register = requestRegister(Context3DBufferTypeID.BITANGENT_V);
					//法线变量寄存器
					var normalVarying:Register = requestRegister(Context3DBufferTypeID.NORMAL_V);

					V_TangentNormalMap(normalInput, tangentInput, matrix, normalVarying, tangentVarying, bitangentVarying);
				}
				else
				{
					//法线数据
					var animatedNormalReg:Register = requestRegister(Context3DBufferTypeID.NORMAL_VA_3);
					//法线变量寄存器
					var normalVaryingReg:Register = requestRegister(Context3DBufferTypeID.NORMAL_V);
					//法线场景变换矩阵(模型空间转场景空间)
					var normalMatrixReg:Register = requestRegister(Context3DBufferTypeID.NORMALSCENETRANSFORM_VC_MATRIX);

					V_TangentNormalNoMap(animatedNormalReg, normalVaryingReg, normalMatrixReg);
				}
			}

			//计算视线方向
			if (shaderParamsLight.needsViewDir > 0)
			{
				//顶点世界坐标
				var globalPositionReg:Register = requestRegister(Context3DBufferTypeID.GLOBALPOSITION_VT_4);
				//视线变量寄存器
				var viewDirVaryingReg:Register = requestRegister(Context3DBufferTypeID.VIEWDIR_V);
				//摄像机世界坐标
				var cameraPositionReg:Register = requestRegister(Context3DBufferTypeID.CAMERAPOSITION_VC_VECTOR);
				V_ViewDir(globalPositionReg, viewDirVaryingReg, cameraPositionReg);
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
		protected function buildAnimationAGAL():Register
		{
			//动画渲染参数
			var shaderParamsAnimation:ShaderParamsAnimation = shaderParams.getComponent(ShaderParamsAnimation.NAME);
			//动画渲染寄存器
			var registerAnimation:ShaderRegisterAnimation = shaderParamsAnimation.registerAnimation;
			//通用渲染参数
			var shaderParamsCommon:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);
			//通用渲染寄存器
			var registerCommon:ShaderRegisterCommon = shaderParamsCommon.registerCommon;

			switch (shaderParamsAnimation.animationType)
			{
				case AnimationType.NONE:
					V_BaseAnimation(registerAnimation.animatedPosition, registerCommon.position);
					break;
				case AnimationType.VERTEX_CPU:
					V_VertexAnimationCPU(registerAnimation.animatedPosition, registerCommon.position);
					break;
				case AnimationType.VERTEX_GPU:
					V_VertexAnimationGPU(registerAnimation.animatedPosition, registerAnimation.p0, registerAnimation.p1, registerAnimation.weight);
					break;
				case AnimationType.SKELETON_CPU:
					V_SkeletonAnimationCPU(registerAnimation.animatedPosition, registerAnimation.animatedReg);
					break;
				case AnimationType.SKELETON_GPU:
					V_SkeletonAnimationGPU(registerAnimation.animatedPosition);
					break;
				case AnimationType.PARTICLE:
					V_Particles(registerAnimation.animatedPosition);
					break;
				default:
					throw new Error(AnimationType.PARTICLE + "类型动画缺少FAGAL代码");
					break;
			}
			return registerAnimation.animatedPosition;
		}
	}
}


