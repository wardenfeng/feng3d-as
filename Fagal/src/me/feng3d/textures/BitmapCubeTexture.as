package me.feng3d.textures
{
	import flash.display.BitmapData;
	import flash.display3D.textures.TextureBase;

	import me.feng3d.utils.MipmapGenerator;
	import me.feng3d.utils.TextureUtils;

	/**
	 * 位图立方体纹理代理
	 * @author warden_feng 2014-7-12
	 */
	public class BitmapCubeTexture extends CubeTextureBase
	{
		private var _bitmapDatas:Vector.<BitmapData>;

		public var optimizeForRenderToTexture:Boolean = false;
		public var streamingLevels:int = 0

		/**
		 * 创建位图立方体纹理代理
		 * @param posX			X正方向位图
		 * @param negX			X负方向位图
		 * @param posY			Y正方向位图
		 * @param negY			Y负方向位图
		 * @param posZ			Z正方向位图
		 * @param negZ			Z负方向位图
		 */
		public function BitmapCubeTexture(posX:BitmapData, negX:BitmapData, posY:BitmapData, negY:BitmapData, posZ:BitmapData, negZ:BitmapData)
		{
			super();

			_bitmapDatas = new Vector.<BitmapData>(6, true);
			testSize(_bitmapDatas[0] = posX);
			testSize(_bitmapDatas[1] = negX);
			testSize(_bitmapDatas[2] = posY);
			testSize(_bitmapDatas[3] = negY);
			testSize(_bitmapDatas[4] = posZ);
			testSize(_bitmapDatas[5] = negZ);

			setSize(posX.width, posX.height);
		}

		/**
		 * 位图列表
		 */
		public function get bitmapDatas():Vector.<BitmapData>
		{
			return _bitmapDatas;
		}

		/**
		 * 正X方向位图（右面位图）
		 */
		public function get positiveX():BitmapData
		{
			return _bitmapDatas[0];
		}

		public function set positiveX(value:BitmapData):void
		{
			testSize(value);
			invalidateContent();
			setSize(value.width, value.height);
			_bitmapDatas[0] = value;
		}

		/**
		 * 负X方向位图（左面位图）
		 */
		public function get negativeX():BitmapData
		{
			return _bitmapDatas[1];
		}

		public function set negativeX(value:BitmapData):void
		{
			testSize(value);
			invalidateContent();
			setSize(value.width, value.height);
			_bitmapDatas[1] = value;
		}

		/**
		 * 正Y方向位图（上面位图）
		 */
		public function get positiveY():BitmapData
		{
			return _bitmapDatas[2];
		}

		public function set positiveY(value:BitmapData):void
		{
			testSize(value);
			invalidateContent();
			setSize(value.width, value.height);
			_bitmapDatas[2] = value;
		}

		/**
		 * 负Y方向位图（下面位图）
		 */
		public function get negativeY():BitmapData
		{
			return _bitmapDatas[3];
		}

		public function set negativeY(value:BitmapData):void
		{
			testSize(value);
			invalidateContent();
			setSize(value.width, value.height);
			_bitmapDatas[3] = value;
		}

		/**
		 * 正Z方向位图（前面位图）
		 */
		public function get positiveZ():BitmapData
		{
			return _bitmapDatas[4];
		}

		public function set positiveZ(value:BitmapData):void
		{
			testSize(value);
			invalidateContent();
			setSize(value.width, value.height);
			_bitmapDatas[4] = value;
		}

		/**
		 * 负Z方向位图（后面位图）
		 */
		public function get negativeZ():BitmapData
		{
			return _bitmapDatas[5];
		}

		public function set negativeZ(value:BitmapData):void
		{
			testSize(value);
			invalidateContent();
			setSize(value.width, value.height);
			_bitmapDatas[5] = value;
		}

		/**
		 * 检查位图尺寸
		 * @param value		位图
		 */
		private function testSize(value:BitmapData):void
		{
			if (value.width != value.height)
				throw new Error("BitmapData should have equal width and height!");
			if (!TextureUtils.isBitmapDataValid(value))
				throw new Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048");
		}
	}
}
