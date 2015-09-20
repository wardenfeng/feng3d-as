package me.feng3d.passes
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DWrapMode;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.DepthTestBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.fagal.fragment.F_SkyBox;
	import me.feng3d.fagal.vertex.V_SkyBox;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagalRE.FagalShaderResult;
	import me.feng3d.textures.CubeTextureBase;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * 天空盒通道
	 * @author warden_feng 2014-7-11
	 */
	public class SkyBoxPass extends MaterialPassBase
	{
		private const cameraPos:Vector.<Number> = new Vector.<Number>(4);
		private const scaleSkybox:Vector.<Number> = new Vector.<Number>(4);
		private const modelViewProjection:Matrix3D = new Matrix3D();

		private var _cubeTexture:CubeTextureBase;

		/**
		 * 创建一个天空盒通道
		 */
		public function SkyBoxPass()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.skyboxTexture_fs, updateTextureBuffer);
			mapContext3DBuffer(_.projection_vc_matrix, updateProjectionBuffer);
			mapContext3DBuffer(_.camerapos_vc_vector, updateCameraPosBuffer);
			mapContext3DBuffer(_.scaleSkybox_vc_vector, updateScaleSkyboxBuffer);
		}

		private function updateProjectionBuffer(projectionBuffer:VCMatrixBuffer):void
		{
			projectionBuffer.update(modelViewProjection, true);
		}

		private function updateCameraPosBuffer(cameraPosBuffer:VCVectorBuffer):void
		{
			cameraPosBuffer.update(cameraPos);
		}

		private function updateScaleSkyboxBuffer(scaleSkyboxBuffer:VCVectorBuffer):void
		{
			scaleSkyboxBuffer.update(scaleSkybox);
		}

		private function updateTextureBuffer(textureBuffer:FSBuffer):void
		{
			textureBuffer.update(_cubeTexture);
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateDepthTestBuffer(depthTestBuffer:DepthTestBuffer):void
		{
			super.updateDepthTestBuffer(depthTestBuffer);

			depthTestBuffer.update(false, Context3DCompareMode.LESS);
		}

		/**
		 * 立方体纹理
		 */
		public function get cubeTexture():CubeTextureBase
		{
			return _cubeTexture;
		}

		public function set cubeTexture(value:CubeTextureBase):void
		{
			_cubeTexture = value;
			markBufferDirty(_.skyboxTexture_fs);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			var result:FagalShaderResult = FagalRE.runShader(V_SkyBox, F_SkyBox);

			//上传程序
			programBuffer.update(result.vertexCode, result.fragmentCode);
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateConstantData(renderable:IRenderable, camera:Camera3D):void
		{
			super.updateConstantData(renderable, camera);
			modelViewProjection.identity();
			modelViewProjection.append(renderable.sourceEntity.sceneTransform);
			modelViewProjection.append(camera.viewProjection);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(camera:Camera3D, target:TextureProxyBase = null):void
		{
			super.activate(camera, target);

			var pos:Vector3D = camera.scenePosition;
			cameraPos[0] = pos.x;
			cameraPos[1] = pos.y;
			cameraPos[2] = pos.z;
			cameraPos[3] = 0;

			scaleSkybox[0] = scaleSkybox[1] = scaleSkybox[2] = camera.lens.far / Math.sqrt(4);
			scaleSkybox[3] = 1;

			//通用渲染参数
			shaderParams.addSampleFlags(_.skyboxTexture_fs, _cubeTexture, Context3DWrapMode.CLAMP);
		}
	}
}
