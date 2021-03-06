package me.feng3d.controllers
{
	import flash.geom.Vector3D;

	import me.feng3d.containers.Container3D;
	import me.feng3d.entities.Entity;
	import me.feng3d.events.Transform3DEvent;
	import me.feng3d.mathlib.Matrix3DUtils;

	/**
	 * 注视点控制器
	 * @author feng 2014-10-10
	 */
	public class LookAtController extends ControllerBase
	{
		protected var _lookAtPosition:Vector3D;
		protected var _lookAtObject:Container3D;

		protected var _upAxis:Vector3D = Vector3D.Y_AXIS;
		private var _pos:Vector3D = new Vector3D();

		/**
		 * 创建注视点控制器
		 * @param targetObject 控制对象
		 * @param lookAtObject 被注视对象
		 */
		public function LookAtController(targetObject:Entity = null, lookAtObject:Container3D = null)
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
				_lookAtObject.removeEventListener(Transform3DEvent.SCENETRANSFORM_CHANGED, onLookAtObjectChanged);
				_lookAtObject = null;
			}

			_lookAtPosition = val;

			notifyUpdate();
		}

		/**
		 * 被注视目标
		 */
		public function get lookAtObject():Container3D
		{
			return _lookAtObject;
		}

		public function set lookAtObject(val:Container3D):void
		{
			if (_lookAtPosition)
				_lookAtPosition = null;

			if (_lookAtObject == val)
				return;

			if (_lookAtObject)
				_lookAtObject.removeEventListener(Transform3DEvent.SCENETRANSFORM_CHANGED, onLookAtObjectChanged);

			_lookAtObject = val;

			if (_lookAtObject)
				_lookAtObject.addEventListener(Transform3DEvent.SCENETRANSFORM_CHANGED, onLookAtObjectChanged);

			notifyUpdate();
		}

		/**
		 * 处理注视目标变化事件
		 */
		private function onLookAtObjectChanged(event:Transform3DEvent):void
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
					_targetObject.transform3D.lookAt(_lookAtPosition, _upAxis);
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
							Matrix3DUtils.getTranslation(_lookAtObject.transform3D.transform, _pos);
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
						Matrix3DUtils.getTranslation(_lookAtObject.transform3D.transform, _pos);
					}
					_targetObject.transform3D.lookAt(_pos, _upAxis);
				}
			}
		}
	}
}
