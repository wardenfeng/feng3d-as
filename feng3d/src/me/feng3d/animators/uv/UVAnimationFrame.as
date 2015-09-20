package me.feng3d.animators.uv
{

	/**
	 * UV动画帧
	 * @author warden_feng 2015-9-18
	 * @see me.feng3d.animators.spriteSheet.SpriteSheetAnimationFrame
	 */
	public class UVAnimationFrame
	{
		/**
		 * U偏移
		 */
		public var offsetU:Number;

		/**
		 * V偏移
		 */
		public var offsetV:Number;

		/**
		 * U缩放
		 */
		public var scaleU:Number;

		/**
		 * V缩放
		 */
		public var scaleV:Number;

		/**
		 * 旋转角度（度数）
		 */
		public var rotation:Number;

		/**
		 * 创建<code>UVAnimationFrame</code>实例
		 *
		 * @param offsetU			U元素偏移
		 * @param offsetV			V元素偏移
		 * @param scaleU			U元素缩放
		 * @param scaleV			V元素缩放
		 * @param rotation			旋转角度（度数）
		 */
		public function UVAnimationFrame(offsetU:Number = 0, offsetV:Number = 0, scaleU:Number = 1, scaleV:Number = 1, rotation:Number = 0)
		{
			this.offsetU = offsetU;
			this.offsetV = offsetV;
			this.scaleU = scaleU;
			this.scaleV = scaleV;
			this.rotation = rotation;
		}
	}
}
