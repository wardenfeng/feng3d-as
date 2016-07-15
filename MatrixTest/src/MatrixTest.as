package
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class MatrixTest extends Sprite
	{
		public function MatrixTest()
		{
			testFunc(testAppendRotationX);
			testFunc(testAppendRotationY);
			testFunc(testAppendRotationZ);
			testFunc(testAppendRotationXY);
			trace("ok");
		}

		private function testAppendRotationXY():void
		{
			var rx:Number = 360 * Math.random();
			var ry:Number = 360 * Math.random();
			//
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendRotation(rx, Vector3D.X_AXIS);
			matrix3D.appendRotation(ry, Vector3D.Y_AXIS);
			//
			var matrix3D1:Matrix3D = Matrix3DUtils.appendRotationXY(rx, ry);

			assert(Matrix3DUtils.compare(matrix3D, matrix3D1));
		}

		private function testFunc(testFunction:Function, times:int = 10000):void
		{
			for (var i:int = 0; i < times; i++)
			{
				testFunction();
			}
			trace(testFunction, "ok");
		}

		private function testAppendRotationZ():void
		{
			var degrees:Number = 360 * Math.random();
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendRotation(degrees, Vector3D.Z_AXIS);
			var matrix3D1:Matrix3D = Matrix3DUtils.appendRotationZ(degrees);

			assert(Matrix3DUtils.compare(matrix3D, matrix3D1));
		}

		private function testAppendRotationY():void
		{
			var degrees:Number = 360 * Math.random();
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendRotation(degrees, Vector3D.Y_AXIS);
			var matrix3D1:Matrix3D = Matrix3DUtils.appendRotationY(degrees);
			assert(Matrix3DUtils.compare(matrix3D, matrix3D1));
		}

		private function testAppendRotationX():void
		{
			var degrees:Number = 360 * Math.random();
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendRotation(degrees, Vector3D.X_AXIS);
			var matrix3D1:Matrix3D = Matrix3DUtils.appendRotationX(degrees);

			assert(Matrix3DUtils.compare(matrix3D, matrix3D1));
		}

		private function traceMatrix3D(matrix3D:Matrix3D):void
		{
			trace(StringUtils.toMatrix3DString(matrix3D));
		}

		/**
		 * 断言
		 * @b			判定为真的表达式
		 * @msg			在表达式为假时将输出的错误信息
		 * @author feng 2014-10-29
		 */
		private function assert(b:Boolean, msg:String = "assert"):void
		{
			if (!b)
				throw msg;
		}
	}
}
