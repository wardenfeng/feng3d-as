package feng3d.core
{
	import flash.geom.Matrix3D;

	import feng3d.containers.ObjectContainer3D;
	import feng3d.entities.Mesh;

	/**
	 * 3D对象<br/><br/>
	 * 主要功能:
	 * <ul>
	 *     <li>能够被addChild添加到3d场景中</li>
	 *     <li>维护场景变换矩阵sceneTransform、inverseSceneTransform</li>
	 *     <li>维护父对象parent</li>
	 * </ul>
	 *
	 * @author warden_feng
	 */
	public class Object3D extends Transform3D
	{
		protected var _parent:ObjectContainer3D;

		protected var _sceneTransform:Matrix3D = new Matrix3D();
		protected var _sceneTransformDirty:Boolean = true;

		private var _inverseSceneTransform:Matrix3D = new Matrix3D();
		private var _inverseSceneTransformDirty:Boolean = true;

		private var _name:String;

		/**
		 * Creates an Object3D object.
		 */
		public function Object3D()
		{
			super();
		}

		public function clone():Object3D
		{
			var clone:Object3D = new Object3D();
			clone.pivotPoint = pivotPoint;
			clone.transform = transform;
			// todo: implement for all subtypes
			return clone;
		}

		/**
		 * 从世界转换到模型空间的逆矩阵
		 * The inverse scene transform object that transforms from world to model space.
		 */
		public function get inverseSceneTransform():Matrix3D
		{
			if (_inverseSceneTransformDirty)
			{
				_inverseSceneTransform.copyFrom(sceneTransform);
				_inverseSceneTransform.invert();
				_inverseSceneTransformDirty = false;
			}

			return _inverseSceneTransform;
		}

		/**
		 * 收集显示对象
		 */
		public function collectDisplayObject(_entityCollector:Vector.<Object3D>):void
		{
			//判断是否为显示对象
			if (this is Mesh)
			{
				_entityCollector.push(this);
			}
		}

		/**
		 * 对象场景转换矩阵
		 */
		public function get sceneTransform():Matrix3D
		{
			if (_sceneTransformDirty)
				updateSceneTransform();
			return _sceneTransform;
		}

		/**
		 * 更新场景转换矩阵
		 * Updates the scene transformation matrix.
		 */
		protected function updateSceneTransform():void
		{
			if (_parent && !_parent._isRoot)
			{
				_sceneTransform.copyFrom(_parent.sceneTransform);
				_sceneTransform.prepend(transform);
			}
			else
				_sceneTransform.copyFrom(transform);

			_sceneTransformDirty = false;
		}

		/**
		 * 当状态变换矩阵无效时 把场景变换矩阵标记为脏数据
		 */
		override public function invalidateTransform():void
		{
			_inverseSceneTransformDirty = _sceneTransformDirty = true;
			super.invalidateTransform();
		}

		/**
		 * 父容器
		 */
		public function get parent():ObjectContainer3D
		{
			return _parent;
		}

		public function set parent(value:ObjectContainer3D):void
		{
			_parent = value;
		}

		/**
		 * 对象名称
		 */
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}
	}
}
