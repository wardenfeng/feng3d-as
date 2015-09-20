package me.feng3d.animators.spriteSheet
{
	import me.feng3d.animators.base.node.AnimationClipNodeBase;

	/**
	 * sprite动画剪辑节点
	 * @author warden_feng 2015-9-18
	 */
	public class SpriteSheetClipNode extends AnimationClipNodeBase
	{
		private var _frames:Vector.<SpriteSheetAnimationFrame> = new Vector.<SpriteSheetAnimationFrame>();

		/**
		 * 创建<code>SpriteSheetClipNode</code>实例.
		 */
		public function SpriteSheetClipNode()
		{
			_stateClass = SpriteSheetAnimationState;
		}

		/**
		 * 帧列表
		 */
		public function get frames():Vector.<SpriteSheetAnimationFrame>
		{
			return _frames;
		}

		/**
		 * 添加帧到动画节点
		 * @param spriteSheetAnimationFrame				sprite动画帧
		 * @param duration								间隔时间
		 */
		public function addFrame(spriteSheetAnimationFrame:SpriteSheetAnimationFrame, duration:uint):void
		{
			_frames.push(spriteSheetAnimationFrame);
			_durations.push(duration);
			_numFrames = _durations.length;

			_stitchDirty = false;
		}
	}
}
