package me.feng3d.cameras
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng3d.bounds.BoundingVolumeBase;
	import me.feng3d.bounds.NullBounds;
	import me.feng3d.cameras.lenses.LensBase;
	import me.feng3d.cameras.lenses.PerspectiveLens;
	import me.feng3d.core.math.Matrix3DUtils;
	import me.feng3d.core.math.Plane3D;
	import me.feng3d.core.partition.node.CameraNode;
	import me.feng3d.core.partition.node.EntityNode;
	import me.feng3d.entities.Entity;
	import me.feng3d.events.CameraEvent;
	import me.feng3d.events.LensEvent;
	import me.feng3d.library.assets.AssetType;

	/**
	 * 摄像机
	 * @author feng 2014-3-17
	 */
	public class Camera3D extends Entity
	{
		private var _viewProjection:Matrix3D = new Matrix3D();
		private var _viewProjectionDirty:Boolean = true;
		private var _lens:LensBase;
		private var _frustumPlanes:Vector.<Plane3D>;
		private var _frustumPlanesDirty:Boolean = true;

		/**
		 * 创建一个摄像机
		 * @param lens 摄像机镜头
		 */
		public function Camera3D(lens:LensBase = null)
		{
			_lens = lens || new PerspectiveLens();
			_lens.addEventListener(LensEvent.MATRIX_CHANGED, onLensMatrixChanged);

			//setup default frustum planes
			_frustumPlanes = new Vector.<Plane3D>(6, true);

			for (var i:int = 0; i < 6; ++i)
				_frustumPlanes[i] = new Plane3D();

			z = -1000;
		}

		/**
		 * @inheritDoc
		 */
		public override function get assetType():String
		{
			return AssetType.CAMERA;
		}

		/**
		 * 处理镜头变化事件
		 */
		private function onLensMatrixChanged(event:LensEvent):void
		{
			_viewProjectionDirty = true;
			_frustumPlanesDirty = true;

			dispatchEvent(event);
		}

		/**
		 * @inheritDoc
		 */
		override protected function invalidateSceneTransform():void
		{
			super.invalidateSceneTransform();

			_viewProjectionDirty = true;
			_frustumPlanesDirty = true;
		}

		/**
		 * @inheritDoc
		 */
		override protected function createEntityPartitionNode():EntityNode
		{
			return new CameraNode(this);
		}

		/**
		 * 镜头
		 */
		public function get lens():LensBase
		{
			return _lens;
		}

		public function set lens(value:LensBase):void
		{
			if (_lens == value)
				return;

			if (!value)
				throw new Error("Lens cannot be null!");

			_lens.removeEventListener(LensEvent.MATRIX_CHANGED, onLensMatrixChanged);

			_lens = value;

			_lens.addEventListener(LensEvent.MATRIX_CHANGED, onLensMatrixChanged);

			dispatchEvent(new CameraEvent(CameraEvent.LENS_CHANGED, this));
		}

		/**
		 * 场景投影矩阵，世界空间转投影空间
		 */
		public function get viewProjection():Matrix3D
		{
			if (_viewProjectionDirty)
			{
				//场景空间转摄像机空间
				_viewProjection.copyFrom(inverseSceneTransform);
				//+摄像机空间转投影空间 = 场景空间转投影空间
				_viewProjection.append(_lens.matrix);
				_viewProjectionDirty = false;
			}

			return _viewProjection;
		}

		/**
		 * 视锥体面
		 */
		public function get frustumPlanes():Vector.<Plane3D>
		{
			if (_frustumPlanesDirty)
				updateFrustum();

			return _frustumPlanes;
		}

		/**
		 * 更新视锥体6个面，平面均朝向视锥体内部
		 * @see http://www.linuxgraphics.cn/graphics/opengl_view_frustum_culling.html
		 */
		private function updateFrustum():void
		{
			var a:Number, b:Number, c:Number;
			//var d : Number;
			var c11:Number, c12:Number, c13:Number, c14:Number;
			var c21:Number, c22:Number, c23:Number, c24:Number;
			var c31:Number, c32:Number, c33:Number, c34:Number;
			var c41:Number, c42:Number, c43:Number, c44:Number;
			var p:Plane3D;
			var raw:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
			//长度倒数
			var invLen:Number;
			viewProjection.copyRawDataTo(raw);

			c11 = raw[uint(0)];
			c12 = raw[uint(4)];
			c13 = raw[uint(8)];
			c14 = raw[uint(12)];
			c21 = raw[uint(1)];
			c22 = raw[uint(5)];
			c23 = raw[uint(9)];
			c24 = raw[uint(13)];
			c31 = raw[uint(2)];
			c32 = raw[uint(6)];
			c33 = raw[uint(10)];
			c34 = raw[uint(14)];
			c41 = raw[uint(3)];
			c42 = raw[uint(7)];
			c43 = raw[uint(11)];
			c44 = raw[uint(15)];

			// left plane
			p = _frustumPlanes[0];
			a = c41 + c11;
			b = c42 + c12;
			c = c43 + c13;
			invLen = 1 / Math.sqrt(a * a + b * b + c * c);
			p.a = a * invLen;
			p.b = b * invLen;
			p.c = c * invLen;
			p.d = -(c44 + c14) * invLen;

			// right plane
			p = _frustumPlanes[1];
			a = c41 - c11;
			b = c42 - c12;
			c = c43 - c13;
			invLen = 1 / Math.sqrt(a * a + b * b + c * c);
			p.a = a * invLen;
			p.b = b * invLen;
			p.c = c * invLen;
			p.d = (c14 - c44) * invLen;

			// bottom
			p = _frustumPlanes[2];
			a = c41 + c21;
			b = c42 + c22;
			c = c43 + c23;
			invLen = 1 / Math.sqrt(a * a + b * b + c * c);
			p.a = a * invLen;
			p.b = b * invLen;
			p.c = c * invLen;
			p.d = -(c44 + c24) * invLen;

			// top
			p = _frustumPlanes[3];
			a = c41 - c21;
			b = c42 - c22;
			c = c43 - c23;
			invLen = 1 / Math.sqrt(a * a + b * b + c * c);
			p.a = a * invLen;
			p.b = b * invLen;
			p.c = c * invLen;
			p.d = (c24 - c44) * invLen;

			// near
			p = _frustumPlanes[4];
			a = c31;
			b = c32;
			c = c33;
			invLen = 1 / Math.sqrt(a * a + b * b + c * c);
			p.a = a * invLen;
			p.b = b * invLen;
			p.c = c * invLen;
			p.d = -c34 * invLen;

			// far
			p = _frustumPlanes[5];
			a = c41 - c31;
			b = c42 - c32;
			c = c43 - c33;
			invLen = 1 / Math.sqrt(a * a + b * b + c * c);
			p.a = a * invLen;
			p.b = b * invLen;
			p.c = c * invLen;
			p.d = (c34 - c44) * invLen;

			_frustumPlanesDirty = false;
		}

		/**
		 * 屏幕坐标投影到场景坐标
		 * @param nX 屏幕坐标X -1（左） -> 1（右）
		 * @param nY 屏幕坐标Y -1（上） -> 1（下）
		 * @param sZ 到屏幕的距离
		 * @param v 场景坐标（输出）
		 * @return 场景坐标
		 */
		public function unproject(nX:Number, nY:Number, sZ:Number, v:Vector3D = null):Vector3D
		{
			return Matrix3DUtils.transformVector(sceneTransform, lens.unproject(nX, nY, sZ, v), v)
		}

		/**
		 * 场景坐标投影到屏幕坐标
		 * @param point3d 场景坐标
		 * @param v 屏幕坐标（输出）
		 * @return 屏幕坐标
		 */
		public function project(point3d:Vector3D, v:Vector3D = null):Vector3D
		{
			return lens.project(Matrix3DUtils.transformVector(inverseSceneTransform, point3d, v), v);
		}

		/**
		 * @inheritDoc
		 */
		override protected function getDefaultBoundingVolume():BoundingVolumeBase
		{
			return new NullBounds();
		}
	}
}
