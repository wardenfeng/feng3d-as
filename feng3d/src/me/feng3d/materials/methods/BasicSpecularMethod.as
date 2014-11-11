package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 镜面反射方法
	 * @author warden_feng 2014-5-19
	 */
	public class BasicSpecularMethod extends LightingMethodBase
	{
		protected var _useTexture:Boolean;

		private var _gloss:int = 50;
		private var _specular:Number = 1;
		private var _specularColor:uint = 0xffffff;

		protected var textureSpecularData:Vector.<Number> = new Vector.<Number>(4);
		protected var textureSpecularBuffer:FCVectorBuffer;


		private var _isFirstLight:Boolean;

		public function BasicSpecularMethod(pass:MaterialPassBase)
		{
			super(pass);
			updateSpecular();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			textureSpecularBuffer = new FCVectorBuffer(Context3DBufferTypeID.TEXTURESPECULAR_FC_VECTOR, updateTextureSpecularBuffer);
		}

		private function updateTextureSpecularBuffer():void
		{
			textureSpecularBuffer.update(textureSpecularData);
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);

			context3dCache.addDataBuffer(textureSpecularBuffer);
		}

		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);

			context3dCache.removeDataBuffer(textureSpecularBuffer);
		}

		override arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy):void
		{
			shaderParams.needsUV += _useTexture ? 1 : 0;
			shaderParams.needsNormals += shaderParams.numLights > 0 ? 1 : 0;
			shaderParams.needsViewDir += shaderParams.numLights > 0 ? 1 : 0;
			
			shaderParams.usingSpecularMethod += 1;
		}

		/**
		 * 镜面反射颜色
		 */
		public function get specularColor():uint
		{
			return _specularColor;
		}

		public function set specularColor(value:uint):void
		{
			if (_specularColor == value)
				return;

			if (_specularColor == 0 || value == 0)
				invalidateShaderProgram();

			_specularColor = value;
			updateSpecular();
		}

		private function updateSpecular():void
		{
			textureSpecularData[0] = ((_specularColor >> 16) & 0xff) / 0xff * _specular;
			textureSpecularData[1] = ((_specularColor >> 8) & 0xff) / 0xff * _specular;
			textureSpecularData[2] = (_specularColor & 0xff) / 0xff * _specular;
			textureSpecularData[3] = _gloss;
			textureSpecularBuffer.invalid();
		}

		/**
		 * 镜面反射光强
		 */
		public function get specular():Number
		{
			return _specular;
		}

		public function set specular(value:Number):void
		{
			if (value == _specular)
				return;

			_specular = value;
			updateSpecular();
		}
	}
}
