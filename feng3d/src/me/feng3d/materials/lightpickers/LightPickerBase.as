package me.feng3d.materials.lightpickers
{
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAssetBase;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.PointLight;

	use namespace arcane;

	/**
	 * 灯光采集器
	 * @author warden_feng 2014-9-11
	 */
	public class LightPickerBase extends NamedAssetBase implements IAsset
	{
		protected var _numPointLights:uint;
		protected var _numDirectionalLights:uint;

		protected var _pointLights:Vector.<PointLight>;
		protected var _directionalLights:Vector.<DirectionalLight>;

		protected var _ambientLightR:Number;
		protected var _ambientLightG:Number;
		protected var _ambientLightB:Number;

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

		public function LightPickerBase()
		{
			super();
			initBuffers();
		}

		public function get assetType():String
		{
			return AssetType.LIGHT_PICKER;
		}

		/**
		 * 方向光数量
		 */
		public function get numDirectionalLights():uint
		{
			return _numDirectionalLights;
		}

		/**
		 * 点光源数量
		 */
		public function get numPointLights():uint
		{
			return _numPointLights;
		}

		/**
		 * 点光源列表
		 */
		public function get pointLights():Vector.<PointLight>
		{
			return _pointLights;
		}

		/**
		 * 方向光列表
		 */
		public function get directionalLights():Vector.<DirectionalLight>
		{
			return _directionalLights;
		}

		public function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			shaderParams.numPointLights = numPointLights;
			shaderParams.numDirectionalLights = numDirectionalLights;

//			if (usesLights())
//				updateLightConstants();
		}

		/**
		 * Indicates whether the shader uses any lights.
		 */
		protected function usesLights():Boolean
		{
			return (_numPointLights > 0 || _numDirectionalLights > 0);
		}

		protected function updateLightConstants():void
		{
			var dirLight:DirectionalLight;
			var pointLight:PointLight;
			var sceneDirection:Vector3D;
			var scenePosition:Vector3D;
			var len:int;
			var i:uint, k:uint;

			len = directionalLights.length;
			for (i = 0; i < len; ++i)
			{
				dirLight = directionalLights[i];
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

		protected function initBuffers():void
		{
			dirLightSceneDirBuffer = new FCVectorBuffer(Context3DBufferTypeID.DIRLIGHTSCENEDIR_FC_VECTOR, updateDirLightSceneDirBuffer);
			dirLightDiffuseBuffer = new FCVectorBuffer(Context3DBufferTypeID.DIRLIGHTDIFFUSE_FC_VECTOR, updateDirLightDiffuseReg);
			dirLightSpecularBuffer = new FCVectorBuffer(Context3DBufferTypeID.DIRLIGHTSPECULAR_FC_VECTOR, updateDirLightSpecularBuffer);

			pointLightSceneDirBuffer = new FCVectorBuffer(Context3DBufferTypeID.POINTLIGHTSCENEPOS_FC_VECTOR, updatePointLightSceneDirBuffer);
			pointLightDiffuseBuffer = new FCVectorBuffer(Context3DBufferTypeID.POINTLIGHTDIFFUSE_FC_VECTOR, updatePointLightDiffuseReg);
			pointLightSpecularBuffer = new FCVectorBuffer(Context3DBufferTypeID.POINTLIGHTSPECULAR_FC_VECTOR, updatePointLightSpecularBuffer);
		}

		public function collectCache(context3dCache:Context3DCache):void
		{
			context3dCache.addDataBuffer(dirLightSceneDirBuffer);
			context3dCache.addDataBuffer(dirLightDiffuseBuffer);
			context3dCache.addDataBuffer(dirLightSpecularBuffer);

			context3dCache.addDataBuffer(pointLightSceneDirBuffer);
			context3dCache.addDataBuffer(pointLightDiffuseBuffer);
			context3dCache.addDataBuffer(pointLightSpecularBuffer);
		}

		public function releaseCache(context3dCache:Context3DCache):void
		{
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
	}
}
