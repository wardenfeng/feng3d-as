package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.fagal.fragment.light.SpecularModelType;
	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcane;

	/**
	 * PhongSpecularMethod provides a specular method that provides Phong highlights.
	 */
	public class PhongSpecularMethod extends BasicSpecularMethod
	{
		/**
		 * Creates a new PhongSpecularMethod object.
		 */
		public function PhongSpecularMethod()
		{
			super();
		}

		override arcane function activate(shaderParams:ShaderParams):void
		{
			super.activate(shaderParams);

			shaderParams.specularModelType = SpecularModelType.PHONG;
		}
	}
}

