package feng3d.cameras
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.geom.Matrix3D;
	
	import feng3d.Feng3dData;
	import feng3d.core.Object3D;

	/**
	 *照相机
	 * @author warden_feng 2014-3-17
	 */
	public class Camera3D extends Object3D
	{
		public var projectionmatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();

		private var _viewProjection:Matrix3D = new Matrix3D();
		
		public function Camera3D()
		{
			// create projection matrix for our 3D scene
			projectionmatrix.identity();
			// 45 degrees FOV, 640/480 aspect ratio, 0.1=near, 100=far
			projectionmatrix.perspectiveFieldOfViewRH(45.0, Feng3dData.viewWidth / Feng3dData.viewHeight, 0.01, 5000.0);
		}
		
		/**
		 * 照相机的投影矩阵
		 * The view projection matrix of the camera.
		 */
		public function get viewProjection():Matrix3D
		{
			_viewProjection.copyFrom(inverseSceneTransform);
			_viewProjection.append(projectionmatrix);
			
			return _viewProjection;
		}
	}
}
