package me.feng3d.materials
{
	import flash.display.BlendMode;

	import me.feng3d.arcane;
	import me.feng3d.materials.lightpickers.LightPickerBase;
	import me.feng3d.materials.methods.BasicAmbientMethod;
	import me.feng3d.materials.methods.BasicDiffuseMethod;
	import me.feng3d.materials.methods.BasicNormalMethod;
	import me.feng3d.materials.methods.BasicSpecularMethod;
	import me.feng3d.materials.methods.EffectMethodBase;
	import me.feng3d.materials.methods.ShadowMapMethodBase;
	import me.feng3d.passes.SuperShaderPass;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 单通道纹理
	 * @author feng 2014-6-5
	 */
	public class SinglePassMaterialBase extends MaterialBase
	{
		protected var _screenPass:SuperShaderPass;
		private var _alphaBlending:Boolean;

		/**
		 * 创建一个单通道纹理
		 */
		public function SinglePassMaterialBase()
		{
			super();
			addPass(_screenPass = new SuperShaderPass());
		}

		/**
		 * The number of "effect" methods added to the material.
		 */
		public function get numMethods():int
		{
			return _screenPass.numMethods;
		}

		/**
		 * @inheritDoc
		 */
		override public function set blendMode(value:String):void
		{
			super.blendMode = value;
			_screenPass.setBlendMode(blendMode == BlendMode.NORMAL && requiresBlending ? BlendMode.LAYER : blendMode);
		}

		/**
		 * @inheritDoc
		 */
		override public function get requiresBlending():Boolean
		{
			return super.requiresBlending || _alphaBlending;
		}

		/**
		 * The minimum alpha value for which pixels should be drawn. This is used for transparency that is either
		 * invisible or entirely opaque, often used with textures for foliage, etc.
		 * Recommended values are 0 to disable alpha, or 0.5 to create smooth edges. Default value is 0 (disabled).
		 */
		public function get alphaThreshold():Number
		{
			return _screenPass.diffuseMethod.alphaThreshold;
		}

		public function set alphaThreshold(value:Number):void
		{
			_screenPass.diffuseMethod.alphaThreshold = value;
		}

		/**
		 * 环境光反射颜色
		 */
		public function get ambientColor():uint
		{
			return _screenPass.ambientMethod.ambientColor;
		}

		public function set ambientColor(value:uint):void
		{
			_screenPass.ambientMethod.ambientColor = value;
		}

		/**
		 * 镜面反射光反射颜色
		 */
		public function get specularColor():uint
		{
			return _screenPass.specularMethod.specularColor;
		}

		public function set specularColor(value:uint):void
		{
			_screenPass.specularMethod.specularColor = value;
		}

		/**
		 * 镜面反射光反射强度
		 */
		public function get specular():Number
		{
			return _screenPass.specularMethod ? _screenPass.specularMethod.specular : 0;
		}

		public function set specular(value:Number):void
		{
			if (_screenPass.specularMethod)
				_screenPass.specularMethod.specular = value;
		}

		/**
		 * 环境光反射强度
		 */
		public function get ambient():Number
		{
			return _screenPass.ambientMethod.ambient;
		}

		public function set ambient(value:Number):void
		{
			_screenPass.ambientMethod.ambient = value;
		}

		/**
		 * 是否透明度混合
		 */
		public function get alphaBlending():Boolean
		{
			return _alphaBlending;
		}

		public function set alphaBlending(value:Boolean):void
		{
			_alphaBlending = value;
			_screenPass.setBlendMode(blendMode == BlendMode.NORMAL && requiresBlending ? BlendMode.LAYER : blendMode);
//			_screenPass.preserveAlpha = requiresBlending;
		}

		/**
		 * 漫反射函数
		 */
		public function get diffuseMethod():BasicDiffuseMethod
		{
			return _screenPass.diffuseMethod;
		}

		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			_screenPass.diffuseMethod = value;
		}

		/**
		 * The method used to generate the per-pixel normals. Defaults to BasicNormalMethod.
		 */
		public function get normalMethod():BasicNormalMethod
		{
			return _screenPass.normalMethod;
		}

		public function set normalMethod(value:BasicNormalMethod):void
		{
			_screenPass.normalMethod = value;
		}

		/**
		 * 环境光函数
		 */
		public function get ambientMethod():BasicAmbientMethod
		{
			return _screenPass.ambientMethod;
		}

		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			_screenPass.ambientMethod = value;
		}

		/**
		 * 镜面反射函数
		 */
		public function get specularMethod():BasicSpecularMethod
		{
			return _screenPass.specularMethod;
		}

		public function set specularMethod(value:BasicSpecularMethod):void
		{
			_screenPass.specularMethod = value;
		}

		/**
		 * 法线贴图
		 */
		public function get normalMap():Texture2DBase
		{
			return _screenPass.normalMethod.normalMap;
		}

		public function set normalMap(value:Texture2DBase):void
		{
			_screenPass.normalMethod.normalMap = value;
		}

		/**
		 * 镜面反射光泽图
		 */
		public function get specularMap():Texture2DBase
		{
			return _screenPass.specularMethod.texture;
		}

		public function set specularMap(value:Texture2DBase):void
		{
			if (_screenPass.specularMethod)
				_screenPass.specularMethod.texture = value;
			else
				throw new Error("No specular method was set to assign the specularGlossMap to");
		}

		/**
		 * 高光值
		 */
		public function get gloss():Number
		{
			return _screenPass.specularMethod ? _screenPass.specularMethod.gloss : 0;
		}

		public function set gloss(value:Number):void
		{
			if (_screenPass.specularMethod)
				_screenPass.specularMethod.gloss = value;
		}

		/**
		 * 阴影映射函数
		 */
		public function get shadowMethod():ShadowMapMethodBase
		{
			return _screenPass.shadowMethod;
		}

		public function set shadowMethod(value:ShadowMapMethodBase):void
		{
			_screenPass.shadowMethod = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function set lightPicker(value:LightPickerBase):void
		{
			super.lightPicker = value;
			_screenPass.lightPicker = value;
		}

		/**
		 * 添加特效函数
		 * @param method		特效函数
		 */
		public function addMethod(method:EffectMethodBase):void
		{
			_screenPass.addMethod(method);
		}
	}
}
