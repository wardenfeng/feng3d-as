package me.feng3d.materials
{
	
	/**
	 * 
	 * @author warden_feng 2014-5-19
	 */
	public class ColorMultiPassMaterial extends MultiPassMaterialBase
	{
		private var _ambientColor:uint = 0xffffff;
		private var _specularColor:uint = 0xffffff;
		private var _specular:Number = 1;
		
		public function ColorMultiPassMaterial(color:uint = 0xcccccc)
		{
			super();
		}

		public function get ambientColor():uint
		{
			return _ambientColor;
		}

		public function set ambientColor(value:uint):void
		{
			_ambientColor = value;
		}

		public function get specularColor():uint
		{
			return _specularColor;
		}

		public function set specularColor(value:uint):void
		{
			_specularColor = value;
		}

		public function get specular():Number
		{
			return _specular;
		}

		public function set specular(value:Number):void
		{
			_specular = value;
		}


	}
}