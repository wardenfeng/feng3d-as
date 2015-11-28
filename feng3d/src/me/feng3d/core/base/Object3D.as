package me.feng3d.core.base
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.controllers.ControllerBase;
	import me.feng3d.core.base.data.Transform3D;
	import me.feng3d.core.partition.Partition3D;
	import me.feng3d.events.MouseEvent3D;
	import me.feng3d.events.Object3DEvent;
	import me.feng3d.mathlib.Matrix3DUtils;

	use namespace arcane;

	/**
	 * 3D对象<br/><br/>
	 * 主要功能:
	 * <ul>
	 *     <li>能够被addChild添加到3d场景中</li>
	 *     <li>维护场景变换矩阵sceneTransform、inverseSceneTransform</li>
	 *     <li>维护父对象parent</li>
	 * </ul>
	 *
	 * @author feng
	 */
	public class Object3D extends Transform3D
	{
		/** @private */
		arcane var _controller:ControllerBase;

		protected var _parent:ObjectContainer3D;

		protected var _sceneTransform:Matrix3D = new Matrix3D();
		protected var _sceneTransformDirty:Boolean = true;

		private var _inverseSceneTransform:Matrix3D = new Matrix3D();
		private var _inverseSceneTransformDirty:Boolean = true;

		private var _scenePosition:Vector3D = new Vector3D();
		private var _scenePositionDirty:Boolean = true;

		arcane var _explicitPartition:Partition3D; // what the user explicitly set as the partition
		protected var _implicitPartition:Partition3D; // what is inherited from the parents if it doesn't have its own explicitPartition

		private var _visible:Boolean = true;

		private var _sceneTransformChanged:Object3DEvent;

		private var _listenToSceneTransformChanged:Boolean;

		arcane var _scene:Scene3D;

		protected var _zOffset:int = 0;

		/**
		 * 创建3D对象
		 */
		public function Object3D()
		{
			super();
		}

		/**
		 * 场景
		 */
		public function get scene():Scene3D
		{
			return _scene;
		}

		public function set scene(value:Scene3D):void
		{
			if (_scene != value)
			{
				if (_scene)
					_scene.removedObject3d(this);
				_scene = value;
				if (_scene)
					_scene.addedObject3d(this);
			}
		}

		/**
		 * 克隆3D对象
		 */
		public function clone():Object3D
		{
			var clone:Object3D = new Object3D();
			clone.pivotPoint = pivotPoint;
			clone.transform = transform;
			return clone;
		}

		/**
		 * 场景变换逆矩阵，场景空间转模型空间
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
		 * 场景变换矩阵，模型空间转场景空间
		 */
		public function get sceneTransform():Matrix3D
		{
			if (_sceneTransformDirty)
				updateSceneTransform();
			return _sceneTransform;
		}

		/**
		 * 更新场景变换矩阵
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
		 * 使变换矩阵失效，场景变换矩阵也将失效
		 */
		override public function invalidateTransform():void
		{
			super.invalidateTransform();

			notifySceneTransformChange();
		}

		/**
		 * 场景变化失效
		 */
		protected function invalidateSceneTransform():void
		{
			_sceneTransformDirty = true;
			_inverseSceneTransformDirty = true;
			_scenePositionDirty = true;
		}

		/**
		 * 通知场景变换改变
		 */
		private function notifySceneTransformChange():void
		{
			if (_sceneTransformDirty)
				return;

			//处理场景变换事件
			if (_listenToSceneTransformChanged)
			{
				if (!_sceneTransformChanged)
					_sceneTransformChanged = new Object3DEvent(Object3DEvent.SCENETRANSFORM_CHANGED, this);
				dispatchEvent(_sceneTransformChanged);
			}

			invalidateSceneTransform();
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
			if (_parent != null)
				_parent.removeChild(this);

			_parent = value;

			invalidateTransform();
		}

		/**
		 * 获取场景坐标
		 */
		public function get scenePosition():Vector3D
		{
			if (_scenePositionDirty)
			{
				sceneTransform.copyColumnTo(3, _scenePosition);
				_scenePositionDirty = false;
			}

			return _scenePosition;
		}

		/**
		 * 本地坐标转换为世界坐标
		 * @param localVector3D 本地坐标
		 * @return
		 */
		public function positionLocalToGlobal(localPosition:Vector3D):Vector3D
		{
			var globalPosition:Vector3D = sceneTransform.transformVector(localPosition);
			return globalPosition;
		}

		/**
		 * 世界坐标转换为本地坐标
		 * @param globalPosition 世界坐标
		 * @return
		 */
		public function positionGlobalToLocal(globalPosition:Vector3D):Vector3D
		{
			var localPosition:Vector3D = inverseSceneTransform.transformVector(globalPosition);
			return localPosition;
		}

		/**
		 * 本地方向转换为世界方向
		 * @param localDirection 本地方向
		 * @return
		 */
		public function directionLocalToGlobal(localDirection:Vector3D):Vector3D
		{
			var globalDirection:Vector3D = sceneTransform.deltaTransformVector(localDirection);
			Matrix3DUtils.deltaTransformVector(sceneTransform, localDirection, globalDirection);
			return globalDirection;
		}

		/**
		 * 世界方向转换为本地方向
		 * @param globalDirection 世界方向
		 * @return
		 */
		public function directionGlobalToLocal(globalDirection:Vector3D):Vector3D
		{
			var localDirection:Vector3D = inverseSceneTransform.deltaTransformVector(globalDirection);
			Matrix3DUtils.deltaTransformVector(inverseSceneTransform, globalDirection, localDirection);
			return localDirection;
		}

		/**
		 * @inheritDoc
		 */
		override public function dispatchEvent(event:Event):Boolean
		{
			if (event is MouseEvent3D && parent && !parent.ancestorsAllowMouseEnabled)
			{
				if (parent)
				{
					return parent.dispatchEvent(event);
				}
				return false;
			}
			return super.dispatchEvent(event);
		}

		/**
		 * 是否可见
		 */
		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
		}

		/**
		 * 是否在场景上可见
		 */
		public function get sceneVisible():Boolean
		{
			//从这里开始一直找父容器到场景了，且visible全为true则为场景上可见
			return visible && (scene != null) && ((parent is Scene3D) ? true : (parent ? parent.sceneVisible : false));
		}

		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);

			switch (type)
			{
				case Object3DEvent.SCENETRANSFORM_CHANGED:
					_listenToSceneTransformChanged = true;
					break;
//				case Object3DEvent.SCENE_CHANGED:
//					_listenToSceneChanged = true;
//					break;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener);

			if (hasEventListener(type))
				return;

			switch (type)
			{
				case Object3DEvent.SCENETRANSFORM_CHANGED:
					_listenToSceneTransformChanged = false;
					break;
//				case Object3DEvent.SCENE_CHANGED:
//					_listenToSceneChanged = false;
//					break;
			}
		}

		/**
		 * 空间分区
		 */
		public function get partition():Partition3D
		{
			return _explicitPartition;
		}

		public function set partition(value:Partition3D):void
		{
			_explicitPartition = value;

			implicitPartition = value ? value : (_parent ? _parent.implicitPartition : null);
		}

		/**
		 * 隐式空间分区
		 */
		arcane function get implicitPartition():Partition3D
		{
			return _implicitPartition;
		}

		arcane function set implicitPartition(value:Partition3D):void
		{
			if (value == _implicitPartition)
				return;

			_implicitPartition = value;
		}

		/**
		 * Z偏移值
		 */
		public function get zOffset():int
		{
			return _zOffset;
		}

		public function set zOffset(value:int):void
		{
			_zOffset = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function translateLocal(axis:Vector3D, distance:Number):void
		{
			super.translateLocal(axis, distance);

			notifySceneTransformChange();
		}

		/**
		 * Cleans up any resources used by the current object.
		 */
		public function dispose():void
		{
		}
	}
}
