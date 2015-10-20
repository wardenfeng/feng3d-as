package me.feng3d.animators.spriteSheet
{

	/**
	 * sprite动画帧
	 * @author feng 2015-9-18
	 * @see me.feng3d.animators.uv.UVAnimationFrame
	 */
	public class SpriteSheetAnimationFrame
	{
		/**
		 * U元素偏移
		 */
		public var offsetU:Number;

		/**
		 * V元素偏移
		 */
		public var offsetV:Number;

		/**
		 * U元素缩放
		 */
		public var scaleU:Number;

		/**
		 * V元素缩放
		 */
		public var scaleV:Number;

		/**
		 * 映射编号
		 */
		public var mapID:uint;

		/**
		 * 创建<code>SpriteSheetAnimationFrame</code>实例
		 *
		 * @param offsetU			U元素偏移
		 * @param offsetV			V元素偏移
		 * @param scaleU			U元素缩放
		 * @param scaleV			V元素缩放
		 * @param mapID				映射编号
		 */
		public function SpriteSheetAnimationFrame(offsetU:Number = 0, offsetV:Number = 0, scaleU:Number = 1, scaleV:Number = 1, mapID:uint = 0)
		{
			this.offsetU = offsetU;
			this.offsetV = offsetV;
			this.scaleU = scaleU;
			this.scaleV = scaleV;
			this.mapID = mapID;
		}
	}
}
