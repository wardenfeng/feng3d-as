package me.feng3d.cameras.lenses
{
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng.events.FEventDispatcher;
	import me.feng3d.arcane;
	import me.feng3d.events.LensEvent;
	import me.feng3d.mathlib.Matrix3DUtils;

	/**
	 * 摄像机镜头
	 * @author feng 2014-10-14
	 */
	public class LensBase extends FEventDispatcher
	{
		protected var _matrix:Matrix3D;
		protected var _scissorRect:Rectangle = new Rectangle();
		protected var _viewPort:Rectangle = new Rectangle();
		protected var _near:Number = 20;
		protected var _far:Number = 3000;
		protected var _aspectRatio:Number = 1;

		protected var _matrixInvalid:Boolean = true;
		protected var _frustumCorners:Vector.<Number> = new Vector.<Number>(8 * 3, true);

		private var _unprojection:Matrix3D;
		private var _unprojectionInvalid:Boolean = true;

		/**
		 * 创建一个摄像机镜头
		 */
		public function LensBase()
		{
			_matrix = new Matrix3D();

			AbstractClassError.check(this);
		}

		/**
		 * Retrieves the corner points of the lens frustum.
		 */
		public function get frustumCorners():Vector.<Number>
		{
			return _frustumCorners;
		}

		public function set frustumCorners(frustumCorners:Vector.<Number>):void
		{
			_frustumCorners = frustumCorners;
		}

		/**
		 * 投影矩阵
		 */
		public function get matrix():Matrix3D
		{
			if (_matrixInvalid)
			{
				updateMatrix();
				_matrixInvalid = false;
			}
			return _matrix;
		}

		public function set matrix(value:Matrix3D):void
		{
			_matrix = value;
			invalidateMatrix();
		}

		/**
		 * 最近距离
		 */
		public function get near():Number
		{
			return _near;
		}

		public function set near(value:Number):void
		{
			if (value == _near)
				return;
			_near = value;
			invalidateMatrix();
		}

		/**
		 * 最远距离
		 */
		public function get far():Number
		{
			return _far;
		}

		public function set far(value:Number):void
		{
			if (value == _far)
				return;
			_far = value;
			invalidateMatrix();
		}

		/**
		 * 视窗缩放比例(width/height)，在渲染器中设置
		 */
		arcane function get aspectRatio():Number
		{
			return _aspectRatio;
		}

		arcane function set aspectRatio(value:Number):void
		{
			if (_aspectRatio == value || (value * 0) != 0)
				return;
			_aspectRatio = value;
			invalidateMatrix();
		}

		/**
		 * 场景坐标投影到屏幕坐标
		 * @param point3d 场景坐标
		 * @param v 屏幕坐标（输出）
		 * @return 屏幕坐标
		 */
		public function project(point3d:Vector3D, v:Vector3D = null):Vector3D
		{
			if (!v)
				v = new Vector3D();
			Matrix3DUtils.transformVector(matrix, point3d, v);
			v.x = v.x / v.w;
			v.y = -v.y / v.w;

			//z is unaffected by transform
			v.z = point3d.z;

			return v;
		}

		/**
		 * 投影逆矩阵
		 */
		public function get unprojectionMatrix():Matrix3D
		{
			if (_unprojectionInvalid)
			{
				_unprojection ||= new Matrix3D();
				_unprojection.copyFrom(matrix);
				_unprojection.invert();
				_unprojectionInvalid = false;
			}

			return _unprojection;
		}

		/**
		 * 屏幕坐标投影到摄像机空间坐标
		 * @param nX 屏幕坐标X -1（左） -> 1（右）
		 * @param nY 屏幕坐标Y -1（上） -> 1（下）
		 * @param sZ 到屏幕的距离
		 * @param v 场景坐标（输出）
		 * @return 场景坐标
		 */
		public function unproject(nX:Number, nY:Number, sZ:Number, v:Vector3D = null):Vector3D
		{
			throw new AbstractMethodError();
		}

		/**
		 * 投影矩阵失效
		 */
		protected function invalidateMatrix():void
		{
			_matrixInvalid = true;
			_unprojectionInvalid = true;
			// notify the camera that the lens matrix is changing. this will mark the 
			// viewProjectionMatrix in the camera as invalid, and force the matrix to
			// be re-queried from the lens, and therefore rebuilt.
			dispatchEvent(new LensEvent(LensEvent.MATRIX_CHANGED, this));
		}

		/**
		 * 更新投影矩阵
		 */
		protected function updateMatrix():void
		{
			throw new AbstractMethodError();
		}
	}
}
