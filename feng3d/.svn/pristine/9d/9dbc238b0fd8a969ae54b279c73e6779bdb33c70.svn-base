package me.feng3d.core.base.data
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import me.feng3d.core.math.MathConsts;
	import me.feng3d.core.math.Matrix3DUtils;

	/**
	 * 3D元素状态变换<br/><br/>
	 *
	 * 主要功能:
	 * <ul>
	 *     <li>处理3d元素的平移、旋转、缩放等操作</li>
	 * </ul>
	 *
	 * @author warden_feng 2014-3-31
	 */
	public class Transform3D extends Element3D
	{
		private var _lookTarget:Vector3D;

		public function Transform3D()
		{
			super();
		}

		/**
		 * 前方单位向量
		 * <ul>
		 * 		<li>自身的Z轴方向</li>
		 * </ul>
		 */
		public function get forwardVector():Vector3D
		{
			return Matrix3DUtils.getForward(transform);
		}

		/**
		 * 右方单位向量
		 * <ul>
		 * 		<li>自身的X轴方向</li>
		 * </ul>
		 */
		public function get rightVector():Vector3D
		{
			return Matrix3DUtils.getRight(transform);
		}

		/**
		 * 上方单位向量
		 * <ul>
		 * 		<li>自身的Y轴方向</li>
		 * </ul>
		 */
		public function get upVector():Vector3D
		{
			return Matrix3DUtils.getUp(transform);
		}

		/**
		 * 后方单位向量
		 * <ul>
		 * 		<li>自身的Z轴负方向</li>
		 * </ul>
		 */
		public function get backVector():Vector3D
		{
			var director:Vector3D = Matrix3DUtils.getForward(transform);
			director.negate();

			return director;
		}

		/**
		 * 左方单位向量
		 * <ul>
		 * 		<li>自身的X轴负方向</li>
		 * </ul>
		 */
		public function get leftVector():Vector3D
		{
			var director:Vector3D = Matrix3DUtils.getRight(transform);
			director.negate();

			return director;
		}

		/**
		 * 下方单位向量
		 * <ul>
		 * 		<li>自身的Y轴负方向</li>
		 * </ul>
		 */
		public function get downVector():Vector3D
		{
			var director:Vector3D = Matrix3DUtils.getUp(transform);
			director.negate();

			return director;
		}

		/**
		 * 等比缩放
		 * @param value 缩放比例
		 */
		public function scale(value:Number):void
		{
			_scaleX *= value;
			_scaleY *= value;
			_scaleZ *= value;

			invalidateScale();
		}

		/**
		 * 向前（Z轴方向）位移
		 * @param distance 位移距离
		 */
		public function moveForward(distance:Number):void
		{
			translateLocal(Vector3D.Z_AXIS, distance);
		}

		/**
		 * 向后（Z轴负方向）位移
		 * @param distance 位移距离
		 */
		public function moveBackward(distance:Number):void
		{
			translateLocal(Vector3D.Z_AXIS, -distance);
		}

		/**
		 * 向左（X轴负方向）位移
		 * @param distance 位移距离
		 */
		public function moveLeft(distance:Number):void
		{
			translateLocal(Vector3D.X_AXIS, -distance);
		}

		/**
		 * 向右（X轴方向）位移
		 * @param distance 位移距离
		 */
		public function moveRight(distance:Number):void
		{
			translateLocal(Vector3D.X_AXIS, distance);
		}

		/**
		 * 向上（Y轴方向）位移
		 * @param distance 位移距离
		 */
		public function moveUp(distance:Number):void
		{
			translateLocal(Vector3D.Y_AXIS, distance);
		}

		/**
		 * 向下（Y轴负方向）位移
		 * @param distance 位移距离
		 */
		public function moveDown(distance:Number):void
		{
			translateLocal(Vector3D.Y_AXIS, -distance);
		}

		/**
		 * 直接移到空间的某个位置
		 * @param newX x坐标
		 * @param newY y坐标
		 * @param newZ z坐标
		 */
		public function moveTo(newX:Number, newY:Number, newZ:Number):void
		{
			if (_x == newX && _y == newY && _z == newZ)
				return;
			_x = newX;
			_y = newY;
			_z = newZ;

			invalidatePosition();
		}

		/**
		 * 移动中心点（旋转点）
		 * @param dx X轴方向位移
		 * @param dy Y轴方向位移
		 * @param dz Z轴方向位移
		 */
		public function movePivot(dx:Number, dy:Number, dz:Number):void
		{
			if (!_pivotPoint)
				_pivotPoint = new Vector3D();
			_pivotPoint.x += dx;
			_pivotPoint.y += dy;
			_pivotPoint.z += dz;

			invalidatePivot();
		}

		/**
		 * 在自定义轴上位移
		 * @param axis 自定义轴
		 * @param distance 位移距离
		 */
		public function translate(axis:Vector3D, distance:Number):void
		{
			var x:Number = axis.x, y:Number = axis.y, z:Number = axis.z;
			var len:Number = distance / Math.sqrt(x * x + y * y + z * z);

			_x += x * len;
			_y += y * len;
			_z += z * len;

			invalidatePosition();
		}

		/**
		 * 在自定义轴上位移<br/>
		 * 
		 * 注意：
		 * <ul>
		 * 		<li>没太理解 与 translate的区别</li>
		 * </ul>
		 * @param axis 自定义轴
		 * @param distance 位移距离
		 */
		public function translateLocal(axis:Vector3D, distance:Number):void
		{
			var x:Number = axis.x, y:Number = axis.y, z:Number = axis.z;
			var len:Number = distance / Math.sqrt(x * x + y * y + z * z);

			transform.prependTranslation(x * len, y * len, z * len);

			_transform.copyColumnTo(3, _pos);

			_x = _pos.x;
			_y = _pos.y;
			_z = _pos.z;

			invalidatePosition();
		}

		/**
		 * 绕X轴旋转
		 * @param angle 旋转角度
		 */
		public function pitch(angle:Number):void
		{
			rotate(Vector3D.X_AXIS, angle);
		}

		/**
		 * 绕Y轴旋转
		 * @param angle 旋转角度
		 */
		public function yaw(angle:Number):void
		{
			rotate(Vector3D.Y_AXIS, angle);
		}

		/**
		 * 绕Z轴旋转
		 * @param angle 旋转角度
		 */
		public function roll(angle:Number):void
		{
			rotate(Vector3D.Z_AXIS, angle);
		}

		/**
		 * 直接修改欧拉角
		 * @param ax X轴旋转角度
		 * @param ay Y轴旋转角度
		 * @param az Z轴旋转角度
		 */
		public function rotateTo(ax:Number, ay:Number, az:Number):void
		{
			_rotationX = ax * MathConsts.DEGREES_TO_RADIANS;
			_rotationY = ay * MathConsts.DEGREES_TO_RADIANS;
			_rotationZ = az * MathConsts.DEGREES_TO_RADIANS;

			invalidateRotation();
		}

		/**
		 * 绕所给轴旋转
		 * @param axis 任意轴
		 * @param angle 旋转角度
		 */
		public function rotate(axis:Vector3D, angle:Number):void
		{
			var m:Matrix3D = new Matrix3D();
			m.prependRotation(angle, axis);

			var vec:Vector3D = m.decompose()[1];

			_rotationX += vec.x;
			_rotationY += vec.y;
			_rotationZ += vec.z;

			invalidateRotation();
		}

		private static var tempAxeX:Vector3D;
		private static var tempAxeY:Vector3D;
		private static var tempAxeZ:Vector3D;
		
		/**
		 * 观察目标
		 * <ul>
		 * 		<li>旋转至朝向给出的点</li>
		 * </ul>
		 * @param target 目标点
		 * @param upAxis An optional vector used to define the desired up orientation of the 3d object after rotation has occurred
		 */
		public function lookAt(target:Vector3D, upAxis:Vector3D = null):void
		{
			if (!tempAxeX)
				tempAxeX = new Vector3D();
			if (!tempAxeY)
				tempAxeY = new Vector3D();
			if (!tempAxeZ)
				tempAxeZ = new Vector3D();
			var xAxis:Vector3D = tempAxeX;
			var yAxis:Vector3D = tempAxeY;
			var zAxis:Vector3D = tempAxeZ;

			var raw:Vector.<Number>;

			upAxis ||= Vector3D.Y_AXIS;

			if (_transformDirty)
			{
				updateTransform();
			}
			
			//照相机位置不能与目标同一个位置上
			if(new Vector3D(_x,_y,_z).subtract(target).length == 0)
			{
				_z = target.z + 0.1;
			}

			zAxis.x = target.x - _x;
			zAxis.y = target.y - _y;
			zAxis.z = target.z - _z;
			zAxis.normalize();

			xAxis.x = upAxis.y * zAxis.z - upAxis.z * zAxis.y;
			xAxis.y = upAxis.z * zAxis.x - upAxis.x * zAxis.z;
			xAxis.z = upAxis.x * zAxis.y - upAxis.y * zAxis.x;
			xAxis.normalize();

			if (xAxis.length < .05)
			{
				xAxis.x = upAxis.y;
				xAxis.y = upAxis.x;
				xAxis.z = 0;
				xAxis.normalize();
			}

			yAxis.x = zAxis.y * xAxis.z - zAxis.z * xAxis.y;
			yAxis.y = zAxis.z * xAxis.x - zAxis.x * xAxis.z;
			yAxis.z = zAxis.x * xAxis.y - zAxis.y * xAxis.x;

			raw = Matrix3DUtils.RAW_DATA_CONTAINER;

			raw[uint(0)] = _scaleX * xAxis.x;
			raw[uint(1)] = _scaleX * xAxis.y;
			raw[uint(2)] = _scaleX * xAxis.z;
			raw[uint(3)] = 0;

			raw[uint(4)] = _scaleY * yAxis.x;
			raw[uint(5)] = _scaleY * yAxis.y;
			raw[uint(6)] = _scaleY * yAxis.z;
			raw[uint(7)] = 0;

			raw[uint(8)] = _scaleZ * zAxis.x;
			raw[uint(9)] = _scaleZ * zAxis.y;
			raw[uint(10)] = _scaleZ * zAxis.z;
			raw[uint(11)] = 0;

			raw[uint(12)] = _x;
			raw[uint(13)] = _y;
			raw[uint(14)] = _z;
			raw[uint(15)] = 1;

			_transform.copyRawDataFrom(raw);

			transform = transform;

			if (zAxis.z < 0)
			{
				rotationY = (180 - rotationY);
				rotationX -= 180;
				rotationZ -= 180;
			}
			
			_lookTarget = target;
		}

		/**
		 * 被观察的对象
		 */		
		public function get lookTarget():Vector3D
		{
			return _lookTarget;
		}

	}
}
