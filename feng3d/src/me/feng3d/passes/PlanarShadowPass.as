package me.feng3d.passes
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.fragment.shadowMap.F_Main_PlanarShadow;
	import me.feng3d.fagal.vertex.shadowMap.V_Main_PlanarShadow;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagalRE.FagalShaderResult;

	use namespace arcane;

	/**
	 * 平面阴影映射通道
	 * @author feng 2015-5-29
	 */
	public class PlanarShadowPass extends MaterialPassBase
	{
		/**
		 * 物体投影变换矩阵（模型空间坐标-->GPU空间坐标）
		 */
		private const modelViewProjection:Matrix3D = new Matrix3D();

		/**
		 * 阴影颜色
		 */
		private var shadowColorCommonsData:Vector.<Number> = new Vector.<Number>(4);

		public static var groundY:Number = 50;

		/**
		 * 创建深度映射通道
		 */
		public function PlanarShadowPass()
		{
			super();
			shadowColorCommonsData = Vector.<Number>([1, 0, 0, 1]);
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.projection_vc_matrix, updateProjectionBuffer);
			mapContext3DBuffer(_.shadowColorCommonsData_fc_vector, updateShadowColorCommonsDataBuffer);
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
		 * 更新阴影颜色常数
		 * @param fcVectorBuffer
		 */
		protected function updateShadowColorCommonsDataBuffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(shadowColorCommonsData);
		}

		/**
		 * @inheritDoc
		 */
		arcane override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, renderIndex:int):void
		{
			//场景变换矩阵（物体坐标-->世界坐标）
			var sceneTransform:Matrix3D = renderable.sourceEntity.getRenderSceneTransform(camera);

			var shadowMatrix3D:Matrix3D = getShadowMatrix3D();

			//投影矩阵（世界坐标-->投影坐标）
			var projectionmatrix:Matrix3D = camera.viewProjection;

			//物体投影变换矩阵
			modelViewProjection.identity();
			modelViewProjection.append(sceneTransform);
			modelViewProjection.append(shadowMatrix3D);
			modelViewProjection.append(projectionmatrix);

			super.render(renderable, stage3DProxy, camera, renderIndex)
		}

		/**
		 * 参考《实时阴影技术》P22
		 * @return 平面投影矩阵
		 */
		private function getShadowMatrix3D():Matrix3D
		{
			var _sunVector3D:Vector3D = new Vector3D(0, 10000, 0); //太阳的方向

			var l:Vector3D = _sunVector3D.clone();
			var n:Vector3D = new Vector3D(0, 1, 0);
			var nl:Number = n.dotProduct(l);
			var d:Number = -groundY;

			var mat1:Matrix3D = new Matrix3D(Vector.<Number>( //
				[nl + d - n.x * l.x, -n.y * l.x, -n.z * l.x, -d * l.x, //
				-n.x * l.y, nl + d - n.y * l.y, -n.z * l.y, -d * l.y, //
				-n.x * l.y, -n.y * l.z, nl + d - n.z * l.z, -d * l.z, //
				-n.x, -n.y, -n.z, nl //
				]
				//
				));
			mat1.transpose();
			return mat1;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			var result:FagalShaderResult = FagalRE.runShader(V_Main_PlanarShadow, F_Main_PlanarShadow);

			//上传程序
			programBuffer.update(result.vertexCode, result.fragmentCode);
		}
	}
}
