package me.feng3d.materials
{
	import flash.display.BlendMode;

	/**
	 * 颜色材质
	 * @author warden_feng 2014-4-15
	 */
	public class ColorMaterial extends SinglePassMaterialBase
	{
		private var _diffuseAlpha:Number = 1;

		public function ColorMaterial(color:uint = 0xcccccc, alpha:Number = 1)
		{
			super();
			this.color = color;
			this.alpha = alpha;
		}

		/**
		 * 透明度
		 */
		public function get alpha():Number
		{
			return _screenPass.diffuseMethod.diffuseAlpha;
		}

		public function set alpha(value:Number):void
		{
			if (value > 1)
				value = 1;
			else if (value < 0)
				value = 0;
			_screenPass.diffuseMethod.diffuseAlpha = _diffuseAlpha = value;
			_screenPass.preserveAlpha = requiresBlending;
			_screenPass.setBlendMode(blendMode == BlendMode.NORMAL && requiresBlending ? BlendMode.LAYER : blendMode);
		}

		/**
		 * 颜色
		 */
		public function get color():uint
		{
			return _screenPass.diffuseMethod.diffuseColor;
		}

		public function set color(value:uint):void
		{
			_screenPass.diffuseMethod.diffuseColor = value;
		}
		
		override public function get requiresBlending():Boolean
		{
			return super.requiresBlending || _diffuseAlpha < 1;
		}
	}
}
