package me.feng3d.passes
{
	import flash.geom.Matrix3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.OCBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.fragment.shadowMap.F_Main_DepthMap;
	import me.feng3d.fagal.vertex.shadowMap.V_Main_DepthMap;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagalRE.FagalShaderResult;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * 深度映射通道
	 * @author warden_feng 2015-5-29
	 */
	public class DepthMapPass extends MaterialPassBase
	{
		/**
		 * 物体投影变换矩阵（模型空间坐标-->GPU空间坐标）
		 */
		private const modelViewProjection:Matrix3D = new Matrix3D();

		/**
		 * 通用数据
		 */
		private var depthCommonsData0:Vector.<Number> = Vector.<Number>([1.0, 255.0, 255.0 * 255.0, 255.0 * 255.0 * 255.0]);

		/**
		 * 通用数据
		 */
		private var depthCommonsData1:Vector.<Number> = Vector.<Number>([1.0 / 255.0, 1.0 / 255.0, 1.0 / 255.0, 0.0]);

		private var _depthMap:TextureProxyBase;

		/**
		 * 创建深度映射通道
		 */
		public function DepthMapPass()
		{
			super();
		}

		/**
		 * 深度图纹理
		 */
		public function get depthMap():TextureProxyBase
		{
			return _depthMap;
		}

		public function set depthMap(value:TextureProxyBase):void
		{
			_depthMap = value;
			markBufferDirty(_.depthMap_oc);
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.projection_vc_matrix, updateProjectionBuffer);
			mapContext3DBuffer(_.depthCommonData0_fc_vector, updateDepthCommonData0Buffer);
			mapContext3DBuffer(_.depthCommonData1_fc_vector, updateDepthCommonData1Buffer);
			mapContext3DBuffer(_.depthMap_oc, updateTextureBuffer);
		}

		/**
		 * 更新投影矩阵缓冲
		 * @param projectionBuffer		投影矩阵缓冲
		 */
		protected function updateProjectionBuffer(projectionBuffer:VCMatrixBuffer):void
		{
			projectionBuffer.update(modelViewProjection, true);
		}

		/**
		 * 更新深度顶点常数0 (1.0, 255.0, 65025.0, 16581375.0)
		 * @param fcVectorBuffer
		 */
		protected function updateDepthCommonData0Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(depthCommonsData0);
		}

		/**
		 * 更新深度顶点常数1 (1.0/255.0, 1.0/255.0, 1.0/255.0, 0.0)
		 * @param fcVectorBuffer
		 */
		protected function updateDepthCommonData1Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(depthCommonsData1);
		}

		/**
		 * 更新深度图纹理
		 * @param textureBuffer
		 */
		private function updateTextureBuffer(textureBuffer:OCBuffer):void
		{
			textureBuffer.update(_depthMap);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(camera:Camera3D, target:TextureProxyBase = null):void
		{
			//初始化渲染参数
			shaderParams.initParams();

			super.activate(camera, target);

			_depthMap = target;
		}

		/**
		 * @inheritDoc
		 */
		arcane override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, renderIndex:int):void
		{
			//场景变换矩阵（物体坐标-->世界坐标）
			var sceneTransform:Matrix3D = renderable.sourceEntity.getRenderSceneTransform(camera);
			//投影矩阵（世界坐标-->投影坐标）
			var projectionmatrix:Matrix3D = camera.viewProjection;

			//物体投影变换矩阵
			modelViewProjection.identity();
			modelViewProjection.append(sceneTransform);
			modelViewProjection.append(projectionmatrix);

			super.render(renderable, stage3DProxy, camera, renderIndex);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			var result:FagalShaderResult = FagalRE.runShader(V_Main_DepthMap, F_Main_DepthMap);

			//上传程序
			programBuffer.update(result.vertexCode, result.fragmentCode);
		}
	}
}
