package me.feng3d.controllers
{
	import flash.geom.Vector3D;

	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.core.math.Matrix3DUtils;
	import me.feng3d.entities.Entity;
	import me.feng3d.events.Object3DEvent;

	/**
	 * 注视点控制器
	 * @author warden_feng 2014-10-10
	 */
	public class LookAtController extends ControllerBase
	{
		protected var _lookAtPosition:Vector3D;
		protected var _lookAtObject:ObjectContainer3D;

		protected var _upAxis:Vector3D = Vector3D.Y_AXIS;
		private var _pos:Vector3D = new Vector3D();

		/**
		 * 创建注视点控制器
		 * @param targetObject 控制对象
		 * @param lookAtObject 被注视对象
		 */
		public function LookAtController(targetObject:Entity = null, lookAtObject:ObjectContainer3D = null)
		{
			super(targetObject);

			if (lookAtObject)
				this.lookAtObject = lookAtObject;
			else
				this.lookAtPosition = new Vector3D();
		}

		/**
		 * 目标对象的上朝向
		 */
		public function get upAxis():Vector3D
		{
			return _upAxis;
		}

		public function set upAxis(upAxis:Vector3D):void
		{
			_upAxis = upAxis;

			notifyUpdate();
		}

		/**
		 * 被注视目标所在位置
		 */
		public function get lookAtPosition():Vector3D
		{
			return _lookAtPosition;
		}

		public function set lookAtPosition(val:Vector3D):void
		{
			if (_lookAtObject)
			{
				_lookAtObject.removeEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onLookAtObjectChanged);
				_lookAtObject = null;
			}

			_lookAtPosition = val;

			notifyUpdate();
		}

		/**
		 * 被注视目标
		 */
		public function get lookAtObject():ObjectContainer3D
		{
			return _lookAtObject;
		}

		public function set lookAtObject(val:ObjectContainer3D):void
		{
			if (_lookAtPosition)
				_lookAtPosition = null;

			if (_lookAtObject == val)
				return;

			if (_lookAtObject)
				_lookAtObject.removeEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onLookAtObjectChanged);

			_lookAtObject = val;

			if (_lookAtObject)
				_lookAtObject.addEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onLookAtObjectChanged);

			notifyUpdate();
		}

		/**
		 * 处理注视目标变化事件
		 */
		private function onLookAtObjectChanged(event:Object3DEvent):void
		{
			notifyUpdate();
		}

		/**
		 * @inheritDoc
		 */
		override public function update():void
		{
			if (_targetObject)
			{
				if (_lookAtPosition)
				{
					_targetObject.lookAt(_lookAtPosition, _upAxis);
				}
				else if (_lookAtObject)
				{
					if (_targetObject.parent && _lookAtObject.parent)
					{
						if (_targetObject.parent != _lookAtObject.parent)
						{ // different spaces
							_pos.x = _lookAtObject.scenePosition.x;
							_pos.y = _lookAtObject.scenePosition.y;
							_pos.z = _lookAtObject.scenePosition.z;
							//
							Matrix3DUtils.transformVector(_targetObject.parent.inverseSceneTransform, _pos, _pos);
						}
						else
						{ //one parent
							Matrix3DUtils.getTranslation(_lookAtObject.transform, _pos);
						}
					}
					else if (_lookAtObject.scene)
					{
						_pos.x = _lookAtObject.scenePosition.x;
						_pos.y = _lookAtObject.scenePosition.y;
						_pos.z = _lookAtObject.scenePosition.z;
					}
					else
					{
						Matrix3DUtils.getTranslation(_lookAtObject.transform, _pos);
					}
					_targetObject.lookAt(_pos, _upAxis);
				}
			}
		}
	}
}
