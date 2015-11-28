package me.feng3d.passes
{
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.PointLight;
	import me.feng3d.materials.methods.EffectMethodBase;
	import me.feng3d.materials.methods.ShadingMethodBase;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * 超级渲染通道
	 * <p>提供灯光渲染相关信息</p>
	 * @author feng 2014-7-1
	 */
	public class SuperShaderPass extends CompiledPass
	{
		/** 方向光源场景方向数据 */
		private const dirLightSceneDirData:Vector.<Number> = new Vector.<Number>();

		/** 方向光源漫反射光颜色数据 */
		private const dirLightDiffuseData:Vector.<Number> = new Vector.<Number>();

		/** 方向光源镜面反射颜色数据 */
		private const dirLightSpecularData:Vector.<Number> = new Vector.<Number>();

		/** 点光源场景位置数据 */
		private const pointLightScenePositionData:Vector.<Number> = new Vector.<Number>();

		/** 点光源漫反射光颜色数据 */
		private const pointLightDiffuseData:Vector.<Number> = new Vector.<Number>();

		/** 点光源镜面反射颜色数据 */
		private const pointLightSpecularData:Vector.<Number> = new Vector.<Number>();

		/**
		 * 创建超级渲染通道
		 */
		public function SuperShaderPass()
		{
			super();
		}

		/**
		 * The number of "effect" methods added to the material.
		 */
		public function get numMethods():int
		{
			return _methodSetup.numMethods;
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.dirLightSceneDir_fc_vector, updateDirLightSceneDirBuffer);
			mapContext3DBuffer(_.dirLightDiffuse_fc_vector, updateDirLightDiffuseReg);
			mapContext3DBuffer(_.dirLightSpecular_fc_vector, updateDirLightSpecularBuffer);
			mapContext3DBuffer(_.pointLightScenePos_fc_vector, updatePointLightScenePositionBuffer);
			mapContext3DBuffer(_.pointLightDiffuse_fc_vector, updatePointLightDiffuseReg);
			mapContext3DBuffer(_.pointLightSpecular_fc_vector, updatePointLightSpecularBuffer);
		}

		private function updateDirLightSpecularBuffer(dirLightSpecularBuffer:FCVectorBuffer):void
		{
			dirLightSpecularBuffer.update(dirLightSpecularData);
		}

		private function updateDirLightDiffuseReg(dirLightDiffuseBuffer:FCVectorBuffer):void
		{
			dirLightDiffuseBuffer.update(dirLightDiffuseData);
		}

		private function updateDirLightSceneDirBuffer(dirLightSceneDirBuffer:FCVectorBuffer):void
		{
			dirLightSceneDirBuffer.update(dirLightSceneDirData);
		}

		private function updatePointLightSpecularBuffer(pointLightSpecularBuffer:FCVectorBuffer):void
		{
			pointLightSpecularBuffer.update(pointLightSpecularData);
		}

		private function updatePointLightDiffuseReg(pointLightDiffuseBuffer:FCVectorBuffer):void
		{
			pointLightDiffuseBuffer.update(pointLightDiffuseData);
		}

		private function updatePointLightScenePositionBuffer(pointLightScenePositionBuffer:FCVectorBuffer):void
		{
			pointLightScenePositionBuffer.update(pointLightScenePositionData);
		}

		/**
		 * 添加特效函数
		 * @param method		特效函数
		 */
		public function addMethod(method:EffectMethodBase):void
		{
			_methodSetup.addMethod(method);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(camera:Camera3D, target:TextureProxyBase = null):void
		{
			if (_lightPicker)
			{
				shaderParams.numPointLights = _lightPicker.numPointLights;
				shaderParams.numDirectionalLights = _lightPicker.numDirectionalLights;
			}

			var methods:Vector.<ShadingMethodBase> = _methodSetup.methods;
			var len:uint = methods.length;
			for (var i:int = 0; i < len; ++i)
			{
				methods[i].activate(shaderParams);
			}

			super.activate(camera);
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateLightConstants():void
		{
			var dirLight:DirectionalLight;
			var pointLight:PointLight;
			var sceneDirection:Vector3D;
			var scenePosition:Vector3D;
			var len:int;
			var i:uint, k:uint;

			var dirLights:Vector.<DirectionalLight> = _lightPicker.directionalLights;
			len = dirLights.length;
			for (i = 0; i < len; ++i)
			{
				dirLight = dirLights[i];
				sceneDirection = dirLight.sceneDirection;

				_ambientLightR += dirLight._ambientR;
				_ambientLightG += dirLight._ambientG;
				_ambientLightB += dirLight._ambientB;

				dirLightSceneDirData[i * 4 + 0] = -sceneDirection.x;
				dirLightSceneDirData[i * 4 + 1] = -sceneDirection.y;
				dirLightSceneDirData[i * 4 + 2] = -sceneDirection.z;
				dirLightSceneDirData[i * 4 + 3] = 1;

				dirLightDiffuseData[i * 4 + 0] = dirLight._diffuseR;
				dirLightDiffuseData[i * 4 + 1] = dirLight._diffuseG;
				dirLightDiffuseData[i * 4 + 2] = dirLight._diffuseB;
				dirLightDiffuseData[i * 4 + 3] = 1;

				dirLightSpecularData[i * 4 + 0] = dirLight._specularR;
				dirLightSpecularData[i * 4 + 1] = dirLight._specularG;
				dirLightSpecularData[i * 4 + 2] = dirLight._specularB;
				dirLightSpecularData[i * 4 + 3] = 1;
			}

			var pointLights:Vector.<PointLight> = _lightPicker.pointLights;
			len = pointLights.length;
			for (i = 0; i < len; ++i)
			{
				pointLight = pointLights[i];
				scenePosition = pointLight.scenePosition;

				_ambientLightR += pointLight._ambientR;
				_ambientLightG += pointLight._ambientG;
				_ambientLightB += pointLight._ambientB;

				pointLightScenePositionData[i * 4 + 0] = scenePosition.x;
				pointLightScenePositionData[i * 4 + 1] = scenePosition.y;
				pointLightScenePositionData[i * 4 + 2] = scenePosition.z;
				pointLightScenePositionData[i * 4 + 3] = 1;

				pointLightDiffuseData[i * 4 + 0] = pointLight._diffuseR;
				pointLightDiffuseData[i * 4 + 1] = pointLight._diffuseG;
				pointLightDiffuseData[i * 4 + 2] = pointLight._diffuseB;
				pointLightDiffuseData[i * 4 + 3] = pointLight._radius * pointLight._radius;

				pointLightSpecularData[i * 4 + 0] = pointLight._specularR;
				pointLightSpecularData[i * 4 + 1] = pointLight._specularG;
				pointLightSpecularData[i * 4 + 2] = pointLight._specularB;
				pointLightSpecularData[i * 4 + 3] = pointLight._fallOffFactor;
			}

		}
	}
}
