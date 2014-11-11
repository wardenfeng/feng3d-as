package me.feng3d.passes
{
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix3D;
	
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.debug.Debug;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.fagal.runFagalMethod;
	import me.feng3d.fagal.fragment.F_SkyBox;
	import me.feng3d.fagal.vertex.V_SkyBox;
	import me.feng3d.textures.CubeTextureBase;

	use namespace arcane;

	/**
	 * 天空盒通道
	 * @author warden_feng 2014-7-11
	 */
	public class SkyBoxPass extends MaterialPassBase
	{
		protected var textureBuffer:FSBuffer;

		protected var projectionBuffer:VCMatrixBuffer;

		private var _cubeTexture:CubeTextureBase;

		private var _modelViewProjection:Matrix3D

		public function SkyBoxPass()
		{
			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			textureBuffer = new FSBuffer(Context3DBufferTypeID.TEXTURE_FS, updateTextureBuffer);
			projectionBuffer = new VCMatrixBuffer(Context3DBufferTypeID.PROJECTION_VC_MATRIX, updateProjectionBuffer);
		}

		private function updateProjectionBuffer():void
		{
			projectionBuffer.update(_modelViewProjection, true);
		}

		private function updateTextureBuffer():void
		{
			textureBuffer.update(_cubeTexture);
		}

		override protected function updateDepthTestBuffer():void
		{
			super.updateDepthTestBuffer();

			depthTestBuffer.update(false, Context3DCompareMode.LESS);
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);

			context3dCache.addDataBuffer(textureBuffer);
			context3dCache.addDataBuffer(projectionBuffer);
		}

		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);

			context3dCache.removeDataBuffer(textureBuffer);
			context3dCache.removeDataBuffer(projectionBuffer);
		}

		public function get cubeTexture():CubeTextureBase
		{
			return _cubeTexture;
		}

		public function set cubeTexture(value:CubeTextureBase):void
		{
			_cubeTexture = value;
			textureBuffer.invalid();
		}

		override arcane function updateProgramBuffer():void
		{
			var vertexCode:String = runFagalMethod(V_SkyBox);
			var fragmentCode:String = runFagalMethod(F_SkyBox);
			
			if (Debug.agalDebug)
			{
				trace("Compiling AGAL Code:");
				trace("--------------------");
				trace(vertexCode);
				trace("--------------------");
				trace(fragmentCode);
			}
			
			//上传程序
			programBuffer.update(vertexCode, fragmentCode);
		}
		
		override arcane function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			var mtx:Matrix3D = new Matrix3D();
			mtx.identity();
			mtx.append(renderable.sourceEntity.sceneTransform);
			mtx.append(camera.viewProjection);

			_modelViewProjection = mtx;
			projectionBuffer.invalid();
		}
		
		override arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			super.activate(shaderParams, stage3DProxy, camera);
			
			shaderParams.addSampleFlags(Context3DBufferTypeID.TEXTURE_FS, _cubeTexture);
		}
	}
}
