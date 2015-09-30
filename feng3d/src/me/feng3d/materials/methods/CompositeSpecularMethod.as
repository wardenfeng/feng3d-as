package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * CompositeSpecularMethod provides a base class for specular methods that wrap a specular method to alter the
	 * calculated specular reflection strength.
	 */
	public class CompositeSpecularMethod extends BasicSpecularMethod
	{
		private var _baseMethod:BasicSpecularMethod;

		/**
		 * Creates a new WrapSpecularMethod object.
		 * @param modulateMethod The method which will add the code to alter the base method's strength. It needs to have the signature modSpecular(t : ShaderRegisterElement, regCache : ShaderRegisterCache) : String, in which t.w will contain the specular strength and t.xyz will contain the half-vector or the reflection vector.
		 * @param baseSpecularMethod The base specular method on which this method's shading is based.
		 */
		public function CompositeSpecularMethod(modulateMethod:Function, baseSpecularMethod:BasicSpecularMethod = null)
		{
			super();
			_baseMethod = baseSpecularMethod || new BasicSpecularMethod();
			_baseMethod._modulateMethod = modulateMethod;
			_baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
		}

		/**
		 * The base specular method on which this method's shading is based.
		 */
		public function get baseMethod():BasicSpecularMethod
		{
			return _baseMethod;
		}

		public function set baseMethod(value:BasicSpecularMethod):void
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
		override public function get gloss():Number
		{
			return _baseMethod.gloss;
		}

		override public function set gloss(value:Number):void
		{
			_baseMethod.gloss = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function get specular():Number
		{
			return _baseMethod.specular;
		}

		override public function set specular(value:Number):void
		{
			_baseMethod.specular = value;
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
		override public function get texture():Texture2DBase
		{
			return _baseMethod.texture;
		}

		override public function set texture(value:Texture2DBase):void
		{
			_baseMethod.texture = value;
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
