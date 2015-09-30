package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * CompositeDiffuseMethod provides a base class for diffuse methods that wrap a diffuse method to alter the
	 * calculated diffuse reflection strength.
	 */
	public class CompositeDiffuseMethod extends BasicDiffuseMethod
	{
		protected var _baseMethod:BasicDiffuseMethod;

		/**
		 * Creates a new WrapDiffuseMethod object.
		 * @param modulateMethod The method which will add the code to alter the base method's strength. It needs to have the signature clampDiffuse(t : ShaderRegisterElement, regCache : ShaderRegisterCache) : String, in which t.w will contain the diffuse strength.
		 * @param baseDiffuseMethod The base diffuse method on which this method's shading is based.
		 */
		public function CompositeDiffuseMethod(modulateMethod:Function = null, baseDiffuseMethod:BasicDiffuseMethod = null)
		{
			_baseMethod = baseDiffuseMethod || new BasicDiffuseMethod();
			_baseMethod._modulateMethod = modulateMethod;
			_baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
		}

		/**
		 * The base diffuse method on which this method's shading is based.
		 */
		public function get baseMethod():BasicDiffuseMethod
		{
			return _baseMethod;
		}

		public function set baseMethod(value:BasicDiffuseMethod):void
		{
			if (_baseMethod == value)
				return;
			_baseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_baseMethod = value;
			_baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated, false, 0, true);
			invalidateShaderProgram();
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			_baseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_baseMethod.dispose();
		}

		/**
		 * @inheritDoc
		 */
		override public function get alphaThreshold():Number
		{
			return _baseMethod.alphaThreshold;
		}

		override public function set alphaThreshold(value:Number):void
		{
			_baseMethod.alphaThreshold = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function get texture():Texture2DBase
		{
			return _baseMethod.texture;
		}

		/**
		 * @inheritDoc
		 */
		override public function set texture(value:Texture2DBase):void
		{
			_baseMethod.texture = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function get diffuseAlpha():Number
		{
			return _baseMethod.diffuseAlpha;
		}

		/**
		 * @inheritDoc
		 */
		override public function get diffuseColor():uint
		{
			return _baseMethod.diffuseColor;
		}

		/**
		 * @inheritDoc
		 */
		override public function set diffuseColor(diffuseColor:uint):void
		{
			_baseMethod.diffuseColor = diffuseColor;
		}

		/**
		 * @inheritDoc
		 */
		override public function set diffuseAlpha(value:Number):void
		{
			_baseMethod.diffuseAlpha = value;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(shaderParams:ShaderParams):void
		{
			_baseMethod.activate(shaderParams);
		}

		/**
		 * @inheritDoc
		 */
		arcane override function cleanCompilationData():void
		{
			super.cleanCompilationData();
			_baseMethod.cleanCompilationData();
		}

		/**
		 * Called when the base method's shader code is invalidated.
		 */
		private function onShaderInvalidated(event:ShadingMethodEvent):void
		{
			invalidateShaderProgram();
		}
	}
}
