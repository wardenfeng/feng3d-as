package
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class MatrixTest extends Sprite
	{
		public function MatrixTest()
		{
			var matrix3D:Matrix3D = new Matrix3D();
			var rx:Number = 30;

			matrix3D.appendRotation(rx, Vector3D.X_AXIS);
//			matrix3D.appendRotation(rx, Vector3D.Y_AXIS);
//			matrix3D.appendRotation(rx, Vector3D.Z_AXIS);

			traceMatrix3D(matrix3D);
			trace("-----------------------");
			traceMatrix3D(Matrix3DUtils.appendRotationX(rx));

			testAppendRotationX();
		}

		private function testAppendRotationX():void
		{
			var rx:Number = 360 * Math.random();

			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendRotation(rx, Vector3D.X_AXIS);
			var matrix3D1:Matrix3D = Matrix3DUtils.appendRotationX(rx);

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
