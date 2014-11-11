package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 环境光函数
	 * 
	 * 参考《3d数学基础：图形与游戏开发》337页，15.4.6 环境光分量
	 * Camb = Gamb X Mamb
	 * Camb：环境光分量。
	 * Gamb：整个场景的环境光值。
	 * Mamb：材质的环境光分量。它总是等于漫反射分量——由纹理图定义。
	 * 
	 * @author warden_feng 2014-7-1
	 */
	public class BasicAmbientMethod extends ShadingMethodBase
	{
		private var _ambientColor:uint = 0xffffff;
		private var _ambient:Number = 1;

		arcane var _lightAmbientR:Number = 0;
		arcane var _lightAmbientG:Number = 0;
		arcane var _lightAmbientB:Number = 0;

		/** 环境光分量缓冲 */
		protected var ambientInputBuffer:FCVectorBuffer;
		/** 环境光分量数据 */
		private var ambientInputData:Vector.<Number> = new Vector.<Number>(4);

		public function BasicAmbientMethod(pass:MaterialPassBase)
		{
			super(pass);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			ambientInputBuffer = new FCVectorBuffer(Context3DBufferTypeID.AMBIENTINPUT_FC_VECTOR, updateAmbientInputBuffer);
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);
			context3dCache.addDataBuffer(ambientInputBuffer);
		}
		
		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);
			context3dCache.removeDataBuffer(ambientInputBuffer);
		}
		
		private function updateAmbientInputBuffer():void
		{
			ambientInputBuffer.update(ambientInputData);
		}

		/**
		 * 更新环境光数据
		 */
		private function updateAmbient():void
		{
			ambientInputData[0] = ((_ambientColor >> 16) & 0xff) / 0xff * _ambient * _lightAmbientR;
			ambientInputData[1] = ((_ambientColor >> 8) & 0xff) / 0xff * _ambient * _lightAmbientG;
			ambientInputData[2] = (_ambientColor & 0xff) / 0xff * _ambient * _lightAmbientB;
			ambientInputData[3] = 1;
			ambientInputBuffer.invalid();
		}

		/**
		 * @inheritDoc
		 */
		override arcane function setRenderState(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			updateAmbient();

		}

		/**
		 * 环境光强
		 */
		public function get ambient():Number
		{
			return _ambient;
		}

		public function set ambient(value:Number):void
		{
			_ambient = value;
			updateAmbient();
		}

		/**
		 * 环境光颜色
		 */
		public function get ambientColor():uint
		{
			return _ambientColor;
		}

		public function set ambientColor(value:uint):void
		{
			_ambientColor = value;
			updateAmbient();
		}

		override public function copyFrom(method:ShadingMethodBase):void
		{
			var diff:BasicAmbientMethod = BasicAmbientMethod(method);
			ambient = diff.ambient;
			ambientColor = diff.ambientColor;
		}
	}
}
