package
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class MatrixTest extends Sprite
	{
		public function MatrixTest()
		{
//			testFunc(testAppendRotationX);
//			testFunc(testAppendRotationY);
//			testFunc(testAppendRotationZ);
//			testFunc(testAppendRotationXY);
//			testFunc(testAppendRotationXYZ);
			testFunc(testMakeMatrix3D);

			trace("ok");
		}

		private function testMakeMatrix3D():void
		{
			var x:Number = 10000000 * Math.random();
			var y:Number = 10000000 * Math.random();
			var z:Number = 10000000 * Math.random();
//
			var rx:Number = 360 * Math.random();
			var ry:Number = 360 * Math.random();
			var rz:Number = 360 * Math.random();
			//
			var sx:Number = 100 * Math.random() + 0.001;
			var sy:Number = 100 * Math.random() + 0.001;
			var sz:Number = 100 * Math.random() + 0.001;
//			var sx:Number = 1;
//			var sy:Number = 1;
//			var sz:Number = 1;
			//
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendScale(sx, sy, sz);
			matrix3D.appendRotation(rx, Vector3D.X_AXIS);
			matrix3D.appendRotation(ry, Vector3D.Y_AXIS);
			matrix3D.appendRotation(rz, Vector3D.Z_AXIS);
			matrix3D.appendTranslation(x, y, z);

//			matrix3D.recompose(Vector.<Vector3D>([ //
//				new Vector3D(x, y, z), //
//				new Vector3D(rx / 180 * Math.PI, ry / 180 * Math.PI, rz / 180 * Math.PI), //
//				new Vector3D(sx, sy, sz), //
//				]))
			//
			var matrix3D1:Matrix3D = Matrix3DUtils.makeMatrix3D1(x, y, z, rx, ry, rz, sx, sy, sz);

			assert(Matrix3DUtils.compare(matrix3D, matrix3D1));

		}

		private function testAppendRotationXYZ():void
		{
			var rx:Number = 360 * Math.random();
			var ry:Number = 360 * Math.random();
			var rz:Number = 360 * Math.random();
			//
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendRotation(rx, Vector3D.X_AXIS);
			matrix3D.appendRotation(ry, Vector3D.Y_AXIS);
			matrix3D.appendRotation(rz, Vector3D.Z_AXIS);
			//
			var matrix3D1:Matrix3D = Matrix3DUtils.appendRotationXYZ(rx, ry, rz);

			assert(Matrix3DUtils.compare(matrix3D, matrix3D1));
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
