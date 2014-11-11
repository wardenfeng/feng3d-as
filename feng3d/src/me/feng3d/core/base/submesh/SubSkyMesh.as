package me.feng3d.core.base.submesh
{
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.ISubGeometry;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.entities.SkyBox;
	import me.feng3d.materials.MaterialBase;
	
	/**
	 * 
	 * @author warden_feng 2014-9-9
	 */
	public class SubSkyMesh extends SubMesh
	{
		protected var _skyBox:SkyBox;
		
		public function SubSkyMesh(subGeometry:ISubGeometry, skyBox:SkyBox, material:MaterialBase=null)
		{
			super(subGeometry, skyBox, material);
			_skyBox = skyBox;
		}
		
		override public function render(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			_skyBox.updateSkyBox(camera);
			super.render(stage3DProxy, camera);
		}
	}
}