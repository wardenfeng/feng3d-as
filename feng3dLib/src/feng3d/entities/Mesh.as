package feng3d.entities
{
	import feng3d.containers.ObjectContainer3D;
	import feng3d.core.base.Geometry;
	import feng3d.textures.BitmapTexture;

	/**
	 * 网格
	 * @author warden_feng 2014-3-24
	 */
	public class Mesh extends ObjectContainer3D
	{
		/** 几何形状 */
		public var geometry:Geometry;

		/** 位图贴图 */
		public var bitmapTexture:BitmapTexture;

		public function Mesh()
		{
			super();
		}
	}
}
