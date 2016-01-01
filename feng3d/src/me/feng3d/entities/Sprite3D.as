package me.feng3d.entities
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.pick.IPickingCollider;
	import me.feng3d.events.Transform3DEvent;
	import me.feng3d.materials.MaterialBase;
	import me.feng3d.mathlib.Matrix3DUtils;
	import me.feng3d.mathlib.Ray3D;

	use namespace arcane;

	/**
	 * Sprite3D is a 3D billboard, a renderable rectangular area that is always aligned with the projection plane.
	 * As a result, no perspective transformation occurs on a Sprite3D object.
	 *
	 * todo: mvp generation or vertex shader code can be optimized
	 */
	public class Sprite3D extends Mesh
	{
		// TODO: Replace with CompactSubGeometry
		private static var _sprite3DGeometry:SubGeometry;
		//private static var _pickingSubMesh:SubGeometry;

		private var _spriteMatrix:Matrix3D;

		private var _pickingSubMesh:SubMesh;
		private var _pickingTransform:Matrix3D;
		private var _camera:Camera3D;

		private var _width:Number;
		private var _height:Number;
		private var _shadowCaster:Boolean = false;

		public function Sprite3D(material:MaterialBase, width:Number, height:Number)
		{
			super();
			transform3D.addEventListener(Transform3DEvent.TRANSFORM_UPDATED, onTransformUpdated);

			this.material = material;
			_width = width;
			_height = height;
			_spriteMatrix = new Matrix3D();
			if (!_sprite3DGeometry)
			{
				_sprite3DGeometry = new SubGeometry();
				_sprite3DGeometry.numVertices = 4;
				_sprite3DGeometry.updateVertexPositionData(Vector.<Number>([-.5, .5, .0, .5, .5, .0, .5, -.5, .0, -.5, -.5, .0]));
				_sprite3DGeometry.updateUVData(Vector.<Number>([.0, .0, 1.0, .0, 1.0, 1.0, .0, 1.0]));
				_sprite3DGeometry.updateIndexData(Vector.<uint>([0, 1, 2, 0, 2, 3]));
				_sprite3DGeometry.updateVertexTangentData(Vector.<Number>([1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0]));
				_sprite3DGeometry.updateVertexNormalData(Vector.<Number>([.0, .0, -1.0, .0, .0, -1.0, .0, .0, -1.0, .0, .0, -1.0]));
			}
			geometry.addSubGeometry(_sprite3DGeometry);
		}

		override public function set pickingCollider(value:IPickingCollider):void
		{
			super.pickingCollider = value;
			if (value)
			{ // bounds collider is the only null value
				_pickingSubMesh = new SubMesh(_sprite3DGeometry, null);
				_pickingTransform = new Matrix3D();
			}
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			if (_width == value)
				return;
			_width = value;
			invalidateTransform();
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			if (_height == value)
				return;
			_height = value;
			invalidateTransform();
		}

		override public function get castsShadows():Boolean
		{
			return _shadowCaster;
		}

		override protected function updateBounds():void
		{
			_bounds.fromExtremes(-.5 * transform3D.scaleX, -.5 * transform3D.scaleY, -.5 * transform3D.scaleZ, .5 * transform3D.scaleX, .5 * transform3D.scaleY, .5 * transform3D.scaleZ);
			_boundsInvalid = false;
		}

		protected function onTransformUpdated(event:Transform3DEvent):void
		{
			transform3D.transform.prependScale(_width, _height, Math.max(_width, _height));
		}

		override arcane function collidesBefore(shortestCollisionDistance:Number, findClosest:Boolean):Boolean
		{
			findClosest = findClosest;
			var viewTransform:Matrix3D = _camera.inverseSceneTransform.clone();
			viewTransform.transpose();
			var rawViewTransform:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
			viewTransform.copyRawDataTo(rawViewTransform);
			rawViewTransform[3] = 0;
			rawViewTransform[7] = 0;
			rawViewTransform[11] = 0;
			rawViewTransform[12] = 0;
			rawViewTransform[13] = 0;
			rawViewTransform[14] = 0;

			_pickingTransform.copyRawDataFrom(rawViewTransform);
			_pickingTransform.prependScale(_width, _height, Math.max(_width, _height));
			_pickingTransform.appendTranslation(scenePosition.x, scenePosition.y, scenePosition.z);
			_pickingTransform.invert();

			var localRayPosition:Vector3D = _pickingTransform.transformVector(_pickingCollisionVO.ray3D.position);
			var localRayDirection:Vector3D = _pickingTransform.deltaTransformVector(_pickingCollisionVO.ray3D.direction);

			var ray3D:Ray3D = new Ray3D(localRayPosition, localRayDirection);
			_pickingCollider.setLocalRay(ray3D);

			_pickingCollisionVO.renderable = null;
			if (_pickingCollider.testSubMeshCollision(_pickingSubMesh, _pickingCollisionVO, shortestCollisionDistance))
				_pickingCollisionVO.renderable = _pickingSubMesh.renderableBase;

			return _pickingCollisionVO.renderable != null;
		}

		override public function getRenderSceneTransform(camera:Camera3D):Matrix3D
		{
			var comps:Vector.<Vector3D> = Matrix3DUtils.decompose(camera.sceneTransform);
			var scale:Vector3D = comps[2];
			comps[0].x = scenePosition.x;
			comps[0].y = scenePosition.y;
			comps[0].z = scenePosition.z;
			scale.x = _width * transform3D.scaleX;
			scale.y = _height * transform3D.scaleY;
			_spriteMatrix.recompose(comps);
			return _spriteMatrix;
		}
	}
}
