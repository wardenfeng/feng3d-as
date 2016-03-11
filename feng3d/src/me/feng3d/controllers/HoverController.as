package me.feng3d.controllers
{
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.containers.Container3D;
	import me.feng3d.entities.Entity;
	import me.feng3d.mathlib.MathConsts;
	import me.feng3d.mathlib.Matrix3DUtils;

	use namespace arcane;

	/**
	 * 盘旋控制器
	 * @author feng 2014-10-10
	 */
	public class HoverController extends LookAtController
	{
		arcane var _currentPanAngle:Number = 0;
		arcane var _currentTiltAngle:Number = 90;

		protected var _origin:Vector3D = new Vector3D(0.0, 0.0, 0.0);
		private var _panAngle:Number = 0;
		private var _tiltAngle:Number = 90;
		private var _distance:Number = 1000;
		private var _minPanAngle:Number = -Infinity;
		private var _maxPanAngle:Number = Infinity;

		private var _minTiltAngle:Number = -90;
		private var _maxTiltAngle:Number = 90;
		private var _yFactor:Number = 2;
		private var _wrapPanAngle:Boolean = false;
		private var _pos:Vector3D = new Vector3D();

		/**
		 * 创建盘旋控制器
		 * @param targetObject 控制对象
		 * @param lookAtObject 被注视对象
		 * @param panAngle 摄像机以Y轴旋转的角度
		 * @param tiltAngle 摄像机以X轴旋转的角度
		 * @param distance 与注视对象的距离
		 * @param minTiltAngle 以X轴旋转的最小角度。
		 * @param maxTiltAngle 以X轴旋转的最大角度。
		 * @param minPanAngle 以Y轴旋转的最小角度。
		 * @param maxPanAngle 以Y轴旋转的最大角度。
		 * @param yFactor
		 * @param wrapPanAngle 是否把角度约束在0到360度
		 */
		public function HoverController(targetObject:Entity = null, lookAtObject:Container3D = null, panAngle:Number = 0, tiltAngle:Number = 90, distance:Number = 1000, minTiltAngle:Number = -90, maxTiltAngle:Number = 90, minPanAngle:Number = NaN, maxPanAngle:Number = NaN, yFactor:Number = 2, wrapPanAngle:Boolean = false)
		{
			super(targetObject, lookAtObject);

			this.distance = distance;
			this.panAngle = panAngle;
			this.tiltAngle = tiltAngle;
			this.minPanAngle = minPanAngle || -Infinity;
			this.maxPanAngle = maxPanAngle || Infinity;
			this.minTiltAngle = minTiltAngle;
			this.maxTiltAngle = maxTiltAngle;
			this.yFactor = yFactor;
			this.wrapPanAngle = wrapPanAngle;

			//values passed in contrustor are applied immediately
			_currentPanAngle = _panAngle;
			_currentTiltAngle = _tiltAngle;
		}

		/**
		 * 与注视目标的距离
		 */
		public function get distance():Number
		{
			return _distance;
		}

		public function set distance(val:Number):void
		{
			if (_distance == val)
				return;

			_distance = val;

			notifyUpdate();
		}

		/**
		 * 最小摆动角度
		 */
		public function get minPanAngle():Number
		{
			return _minPanAngle;
		}

		public function set minPanAngle(val:Number):void
		{
			if (_minPanAngle == val)
				return;

			_minPanAngle = val;

			panAngle = Math.max(_minPanAngle, Math.min(_maxPanAngle, _panAngle));
		}

		/**
		 * 最大摆动角度
		 */
		public function get maxPanAngle():Number
		{
			return _maxPanAngle;
		}

		public function set maxPanAngle(val:Number):void
		{
			if (_maxPanAngle == val)
				return;

			_maxPanAngle = val;

			panAngle = Math.max(_minPanAngle, Math.min(_maxPanAngle, _panAngle));
		}

		/**
		 * 倾斜角度
		 */
		public function get tiltAngle():Number
		{
			return _tiltAngle;
		}

		public function set tiltAngle(val:Number):void
		{
			val = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, val));

			if (_tiltAngle == val)
				return;

			_tiltAngle = val;

			notifyUpdate();
		}

		/**
		 * 最小倾斜角度
		 */
		public function get minTiltAngle():Number
		{
			return _minTiltAngle;
		}

		public function set minTiltAngle(val:Number):void
		{
			if (_minTiltAngle == val)
				return;

			_minTiltAngle = val;

			tiltAngle = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, _tiltAngle));
		}

		/**
		 * 最大倾斜角度
		 */
		public function get maxTiltAngle():Number
		{
			return _maxTiltAngle;
		}

		public function set maxTiltAngle(val:Number):void
		{
			if (_maxTiltAngle == val)
				return;

			_maxTiltAngle = val;

			tiltAngle = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, _tiltAngle));
		}

		/**
		 * y因子，用于体现摄像机水平与垂直旋转的差异
		 * @see #distance
		 */
		public function get yFactor():Number
		{
			return _yFactor;
		}

		public function set yFactor(val:Number):void
		{
			if (_yFactor == val)
				return;

			_yFactor = val;

			notifyUpdate();
		}

		/**
		 * 是否把角度约束在0到360度
		 */
		public function get wrapPanAngle():Boolean
		{
			return _wrapPanAngle;
		}

		public function set wrapPanAngle(val:Boolean):void
		{
			if (_wrapPanAngle == val)
				return;

			_wrapPanAngle = val;

			notifyUpdate();
		}

		/**
		 * 摆动角度
		 */
		public function get panAngle():Number
		{
			return _panAngle;
		}

		public function set panAngle(val:Number):void
		{
			val = Math.max(_minPanAngle, Math.min(_maxPanAngle, val));

			if (_panAngle == val)
				return;

			_panAngle = val;

			notifyUpdate();
		}

		/**
		 * 更新当前倾斜与摆动角度
		 * @see    #tiltAngle
		 * @see    #panAngle
		 * @see    #steps
		 */
		public override function update():void
		{
			if (_tiltAngle != _currentTiltAngle || _panAngle != _currentPanAngle)
			{
				if (_wrapPanAngle)
				{
					if (_panAngle < 0)
					{
						_currentPanAngle += _panAngle % 360 + 360 - _panAngle;
						_panAngle = _panAngle % 360 + 360;
					}
					else
					{
						_currentPanAngle += _panAngle % 360 - _panAngle;
						_panAngle = _panAngle % 360;
					}

					while (_panAngle - _currentPanAngle < -180)
						_currentPanAngle -= 360;

					while (_panAngle - _currentPanAngle > 180)
						_currentPanAngle += 360;
				}

				_currentPanAngle = _panAngle;
				_currentTiltAngle = _tiltAngle;

				//snap coords if angle differences are close
				if ((Math.abs(tiltAngle - _currentTiltAngle) < 0.01) && (Math.abs(_panAngle - _currentPanAngle) < 0.01))
				{
					_currentTiltAngle = _tiltAngle;
					_currentPanAngle = _panAngle;
				}
			}

			if (!_targetObject)
				return;

			if (_lookAtPosition)
			{
				_pos.x = _lookAtPosition.x;
				_pos.y = _lookAtPosition.y;
				_pos.z = _lookAtPosition.z;
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
			}
			else
			{
				_pos.x = _origin.x;
				_pos.y = _origin.y;
				_pos.z = _origin.z;
			}

			_targetObject.transform3D.x = _pos.x + _distance * Math.sin(_currentPanAngle * MathConsts.DEGREES_TO_RADIANS) * Math.cos(_currentTiltAngle * MathConsts.DEGREES_TO_RADIANS);
			_targetObject.transform3D.z = _pos.z + _distance * Math.cos(_currentPanAngle * MathConsts.DEGREES_TO_RADIANS) * Math.cos(_currentTiltAngle * MathConsts.DEGREES_TO_RADIANS);
			_targetObject.transform3D.y = _pos.y + _distance * Math.sin(_currentTiltAngle * MathConsts.DEGREES_TO_RADIANS) * _yFactor;
			super.update();
		}
	}
}
