package me.feng3d.passes
{
	import flash.geom.Vector3D;
	
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.PointLight;
	import me.feng3d.materials.MaterialBase;

	use namespace arcane;

	/**
	 *
	 * @author warden_feng 2014-7-1
	 */
	public class SuperShaderPass extends CompiledPass
	{
		/** 方向光源场景方向数据缓冲 */
		protected var dirLightSceneDirBuffer:FCVectorBuffer;

		/** 方向光源场景方向数据 */
		private var dirLightSceneDirData:Vector.<Number> = new Vector.<Number>(4);

		/** 方向光源漫反射光颜色数据缓冲 */
		protected var dirLightDiffuseBuffer:FCVectorBuffer;

		/** 方向光源漫反射光颜色数据 */
		private var dirLightDiffuseData:Vector.<Number> = new Vector.<Number>(4);

		/** 方向光源镜面反射颜色数据缓冲 */
		protected var dirLightSpecularBuffer:FCVectorBuffer;

		/** 方向光源镜面反射颜色数据 */
		private var dirLightSpecularData:Vector.<Number> = new Vector.<Number>(4);

		/** 点光源场景方向数据缓冲 */
		protected var pointLightSceneDirBuffer:FCVectorBuffer;

		/** 点光源场景方向数据 */
		private var pointLightSceneDirData:Vector.<Number> = new Vector.<Number>(4);

		/** 点光源漫反射光颜色数据缓冲 */
		protected var pointLightDiffuseBuffer:FCVectorBuffer;

		/** 点光源漫反射光颜色数据 */
		private var pointLightDiffuseData:Vector.<Number> = new Vector.<Number>(4);

		/** 点光源镜面反射颜色数据缓冲 */
		protected var pointLightSpecularBuffer:FCVectorBuffer;

		/** 点光源镜面反射颜色数据 */
		private var pointLightSpecularData:Vector.<Number> = new Vector.<Number>(4);

		public function SuperShaderPass(material:MaterialBase)
		{
			super(material);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			dirLightSceneDirBuffer = new FCVectorBuffer(Context3DBufferTypeID.DIRLIGHTSCENEDIR_FC_VECTOR, updateDirLightSceneDirBuffer);
			dirLightDiffuseBuffer = new FCVectorBuffer(Context3DBufferTypeID.DIRLIGHTDIFFUSE_FC_VECTOR, updateDirLightDiffuseReg);
			dirLightSpecularBuffer = new FCVectorBuffer(Context3DBufferTypeID.DIRLIGHTSPECULAR_FC_VECTOR, updateDirLightSpecularBuffer);

			pointLightSceneDirBuffer = new FCVectorBuffer(Context3DBufferTypeID.POINTLIGHTSCENEPOS_FC_VECTOR, updatePointLightSceneDirBuffer);
			pointLightDiffuseBuffer = new FCVectorBuffer(Context3DBufferTypeID.POINTLIGHTDIFFUSE_FC_VECTOR, updatePointLightDiffuseReg);
			pointLightSpecularBuffer = new FCVectorBuffer(Context3DBufferTypeID.POINTLIGHTSPECULAR_FC_VECTOR, updatePointLightSpecularBuffer);
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);

			context3dCache.addDataBuffer(dirLightSceneDirBuffer);
			context3dCache.addDataBuffer(dirLightDiffuseBuffer);
			context3dCache.addDataBuffer(dirLightSpecularBuffer);

			context3dCache.addDataBuffer(pointLightSceneDirBuffer);
			context3dCache.addDataBuffer(pointLightDiffuseBuffer);
			context3dCache.addDataBuffer(pointLightSpecularBuffer);
		}

		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);

			context3dCache.removeDataBuffer(dirLightSceneDirBuffer);
			context3dCache.removeDataBuffer(dirLightDiffuseBuffer);
			context3dCache.removeDataBuffer(dirLightSpecularBuffer);

			context3dCache.removeDataBuffer(pointLightSceneDirBuffer);
			context3dCache.removeDataBuffer(pointLightDiffuseBuffer);
			context3dCache.removeDataBuffer(pointLightSpecularBuffer);
		}

		private function updateDirLightSpecularBuffer():void
		{
			dirLightSpecularBuffer.update(dirLightSpecularData);
		}

		private function updateDirLightDiffuseReg():void
		{
			dirLightDiffuseBuffer.update(dirLightDiffuseData);
		}

		private function updateDirLightSceneDirBuffer():void
		{
			dirLightSceneDirBuffer.update(dirLightSceneDirData);
		}

		private function updatePointLightSpecularBuffer():void
		{
			pointLightSpecularBuffer.update(pointLightSpecularData);
		}

		private function updatePointLightDiffuseReg():void
		{
			pointLightDiffuseBuffer.update(pointLightDiffuseData);
		}

		private function updatePointLightSceneDirBuffer():void
		{
			pointLightSceneDirBuffer.update(pointLightSceneDirData);
		}

		override arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			if (_lightPicker)
				_lightPicker.activate(shaderParams, stage3DProxy, camera);

			super.activate(shaderParams, stage3DProxy, camera);
		}

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
				dirLightSceneDirBuffer.invalid();

				dirLightDiffuseData[i * 4 + 0] = dirLight._diffuseR;
				dirLightDiffuseData[i * 4 + 1] = dirLight._diffuseG;
				dirLightDiffuseData[i * 4 + 2] = dirLight._diffuseB;
				dirLightDiffuseData[i * 4 + 3] = 1;
				dirLightDiffuseBuffer.invalid();

				dirLightSpecularData[i * 4 + 0] = dirLight._specularR;
				dirLightSpecularData[i * 4 + 1] = dirLight._specularG;
				dirLightSpecularData[i * 4 + 2] = dirLight._specularB;
				dirLightSpecularData[i * 4 + 3] = 1;
				dirLightSpecularBuffer.invalid();

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

				pointLightSceneDirData[i * 4 + 0] = scenePosition.x;
				pointLightSceneDirData[i * 4 + 1] = scenePosition.y;
				pointLightSceneDirData[i * 4 + 2] = scenePosition.z;
				pointLightSceneDirData[i * 4 + 3] = 1;
				pointLightSceneDirBuffer.invalid();

				pointLightDiffuseData[i * 4 + 0] = pointLight._diffuseR;
				pointLightDiffuseData[i * 4 + 1] = pointLight._diffuseG;
				pointLightDiffuseData[i * 4 + 2] = pointLight._diffuseB;
				pointLightDiffuseData[i * 4 + 3] = pointLight._radius * pointLight._radius;
				pointLightDiffuseBuffer.invalid();

				pointLightSpecularData[i * 4 + 0] = pointLight._specularR;
				pointLightSpecularData[i * 4 + 1] = pointLight._specularG;
				pointLightSpecularData[i * 4 + 2] = pointLight._specularB;
				pointLightSpecularData[i * 4 + 3] = pointLight._fallOffFactor;
				pointLightSpecularBuffer.invalid();
			}

		}
	}
}
