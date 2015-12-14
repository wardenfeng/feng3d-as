package base
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;

	import me.feng3d.core.buffer.Context3DCache;

	/**
	 *
	 * @author feng 2014-10-27
	 */
	public class BaseMesh
	{
		private var _context3dCache:Context3DCache;

		private var _geometry:BaseGeometry;
		private var _material:BaseMaterial;

		public function BaseMesh(geometry:BaseGeometry = null, material:BaseMaterial = null)
		{
			_geometry = geometry || new BaseGeometry();
			context3dCache.addChildBufferOwner(_geometry);

			_material = material || new BaseMaterial();
			context3dCache.addChildBufferOwner(_material);
		}

		public function render(context3D:Context3D, viewMatrix:Matrix3D):void
		{
			_material.shaderParams.initParams();
			context3dCache.shaderParams = _material.shaderParams;

			_material.render(viewMatrix);

			//绘制图形
			context3dCache.render(context3D);
		}

		protected function get context3dCache():Context3DCache
		{
			return _context3dCache ||= new Context3DCache();
		}
	}
}
