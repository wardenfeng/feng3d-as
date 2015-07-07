package me.feng3d.core.math
{
	import flash.geom.Vector3D;

	/**
	 * 3D射线
	 * @author warden_feng 2013-6-13
	 */
	public class Ray3D extends Line3D
	{
		public function Ray3D(position:Vector3D = null, direction:Vector3D = null)
		{
			super(position, direction);
		}
	}
}
