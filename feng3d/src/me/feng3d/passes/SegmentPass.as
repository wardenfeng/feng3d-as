package me.feng3d.passes
{

	import flash.geom.Matrix3D;
	
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.debug.Debug;
	import me.feng3d.entities.segment.SegmentContext3DBufferTypeID;
	import me.feng3d.fagal.fragment.F_Segment;
	import me.feng3d.fagal.runFagalMethod;
	import me.feng3d.fagal.vertex.V_Segment;

	use namespace arcane;

	/**
	 * 线段渲染通道
	 * @author warden_feng 2014-4-16
	 */
	public class SegmentPass extends MaterialPassBase
	{
		protected static const ONE_VECTOR:Vector.<Number> = Vector.<Number>([1, 1, 1, 1]);
		protected static const FRONT_VECTOR:Vector.<Number> = Vector.<Number>([0, 0, -1, 0]);

		private var _c2pMatrix:Matrix3D;

		private var _thickness:Number;
		private var _m2cMatrix:Matrix3D;
		private var _constants:Vector.<Number> = new Vector.<Number>(4, true);

		public var c2pMatrixBuffer:VCMatrixBuffer;
		public var m2cMatrixBuffer:VCMatrixBuffer;

		protected var oneBuffer:VCVectorBuffer;
		protected var frontBuffer:VCVectorBuffer;
		protected var constantsBuffer:VCVectorBuffer;

		public function SegmentPass(thickness:Number)
		{
			_m2cMatrix = new Matrix3D();
			_thickness = thickness;
			constants[1] = 1 / 255;

			super();
		}

		public function get constants():Vector.<Number>
		{
			return _constants;
		}

		public function set constants(value:Vector.<Number>):void
		{
			_constants = value;
			constantsBuffer.invalid();
		}

		/**
		 * 模型坐标系到照相机坐标系转换矩阵（m：model，c：camera）
		 */
		public function get m2cMatrix():Matrix3D
		{
			return _m2cMatrix;
		}

		public function set m2cMatrix(value:Matrix3D):void
		{
			_m2cMatrix = value;
			m2cMatrixBuffer.invalid();
		}

		/**
		 * 照相机坐标系到投影坐标系转换矩阵（c：camera，p：projection）
		 */
		public function get c2pMatrix():Matrix3D
		{
			return _c2pMatrix;
		}

		public function set c2pMatrix(value:Matrix3D):void
		{
			_c2pMatrix = value;
			c2pMatrixBuffer.invalid();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			c2pMatrixBuffer = new VCMatrixBuffer(SegmentContext3DBufferTypeID.SEGMENTC2PMATRIX_VC_MATRIX, updateC2pMatrixBuffer);
			m2cMatrixBuffer = new VCMatrixBuffer(SegmentContext3DBufferTypeID.SEGMENTM2CMATRIX_VC_MATRIX, updateM2cMatrixBuffer);

			oneBuffer = new VCVectorBuffer(SegmentContext3DBufferTypeID.SEGMENTONE_VC_VECTOR, updateOneBuffer);
			frontBuffer = new VCVectorBuffer(SegmentContext3DBufferTypeID.SEGMENTFRONT_VC_VECTOR, updateFrontBuffer);
			constantsBuffer = new VCVectorBuffer(SegmentContext3DBufferTypeID.SEGMENTCONSTANTS_VC_VECTOR, updateConstantsBuffer);
		}

		private function updateConstantsBuffer():void
		{
			constantsBuffer.update(constants);
		}

		private function updateFrontBuffer():void
		{
			frontBuffer.update(FRONT_VECTOR);
		}

		private function updateOneBuffer():void
		{
			oneBuffer.update(ONE_VECTOR);
		}

		private function updateC2pMatrixBuffer():void
		{
			//设置照相机投影矩阵
			c2pMatrixBuffer.update(c2pMatrix, true);
		}

		private function updateM2cMatrixBuffer():void
		{
			//设置投影矩阵
			m2cMatrixBuffer.update(m2cMatrix, true);
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);

			context3dCache.addDataBuffer(c2pMatrixBuffer);
			context3dCache.addDataBuffer(m2cMatrixBuffer);

			context3dCache.addDataBuffer(oneBuffer);
			context3dCache.addDataBuffer(frontBuffer);
			context3dCache.addDataBuffer(constantsBuffer);
		}

		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);

			context3dCache.removeDataBuffer(c2pMatrixBuffer);
			context3dCache.removeDataBuffer(m2cMatrixBuffer);

			context3dCache.removeDataBuffer(oneBuffer);
			context3dCache.removeDataBuffer(frontBuffer);
			context3dCache.removeDataBuffer(constantsBuffer);
		}

		override arcane function updateProgramBuffer():void
		{
			var vertexCode:String = runFagalMethod(V_Segment);
			var fragmentCode:String = runFagalMethod(F_Segment);

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
			//线段厚度
			if (stage3DProxy.scissorRect)
				constants[0] = _thickness / Math.min(stage3DProxy.scissorRect.width, stage3DProxy.scissorRect.height);
			else
				constants[0] = _thickness / Math.min(stage3DProxy.width, stage3DProxy.height);

			//照相机最近距离
			constants[2] = camera.lens.near;
			constants = constants;

			var calcMtx:Matrix3D = new Matrix3D();
			//
			calcMtx.copyFrom(renderable.sourceEntity.sceneTransform);
			calcMtx.append(camera.inverseSceneTransform);
			m2cMatrix = calcMtx;

			c2pMatrix = camera.lens.matrix;
		}
	}
}
