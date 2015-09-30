package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.fagal.fragment.method.F_FresnelSpecular;
	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcane;

	/**
	 * FresnelSpecularMethod provides a specular shading method that causes stronger highlights on grazing view angles.
	 */
	public class FresnelSpecularMethod extends PhongSpecularMethod
	{
		private var _incidentLight:Boolean;
		private var _fresnelPower:Number = 5;
		private var _normalReflectance:Number = .028; // default value for skin

		private var data:Vector.<Number> = Vector.<Number>([0, 0, 1, 0]);

		/**
		 * Creates a new FresnelSpecularMethod object.
		 * @param basedOnSurface Defines whether the fresnel effect should be based on the view angle on the surface (if true), or on the angle between the light and the view.
		 * @param baseSpecularMethod The specular method to which the fresnel equation. Defaults to BasicSpecularMethod.
		 */
		public function FresnelSpecularMethod(basedOnSurface:Boolean = true)
		{
			// may want to offer diff speculars
			super();
			_incidentLight = !basedOnSurface;
		}

		/**
		 * Defines whether the fresnel effect should be based on the view angle on the surface (if true), or on the angle between the light and the view.
		 */
		public function get basedOnSurface():Boolean
		{
			return !_incidentLight;
		}

		public function set basedOnSurface(value:Boolean):void
		{
			if (_incidentLight != value)
				return;

			_incidentLight = !value;

			invalidateShaderProgram();
		}

		/**
		 * The power used in the Fresnel equation. Higher values make the fresnel effect more pronounced. Defaults to 5.
		 */
		public function get fresnelPower():Number
		{
			return _fresnelPower;
		}

		public function set fresnelPower(value:Number):void
		{
			_fresnelPower = value;
		}

		/**
		 * The minimum amount of reflectance, ie the reflectance when the view direction is normal to the surface or light direction.
		 */
		public function get normalReflectance():Number
		{
			return _normalReflectance;
		}

		public function set normalReflectance(value:Number):void
		{
			_normalReflectance = value;
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.fresnelSpecularData_fc_vector, updateSpecularDataBuffer);
		}

		private function updateSpecularDataBuffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(data);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(shaderParams:ShaderParams):void
		{
			super.activate(shaderParams);

			data[0] = _normalReflectance;
			data[1] = _fresnelPower;

			shaderParams.incidentLight = _incidentLight;

			shaderParams.modulateMethod = F_FresnelSpecular;
		}
	}
}
