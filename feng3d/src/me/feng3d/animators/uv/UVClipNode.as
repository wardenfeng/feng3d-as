package me.feng3d.animators.uv
{
	import me.feng3d.animators.base.node.AnimationClipNodeBase;

	/**
	 * A uv animation node containing time-based animation data as individual uv animation frames.
	 */
	/**
	 * UV动画剪辑节点
	 * @author feng 2014-5-20
	 */
	public class UVClipNode extends AnimationClipNodeBase
	{
		private var _frames:Vector.<UVAnimationFrame> = new Vector.<UVAnimationFrame>();

		/**
		 * 帧数据列表
		 */
		public function get frames():Vector.<UVAnimationFrame>
		{
			return _frames;
		}

		/**
		 * 创建<code>UVClipNode</code>实例
		 */
		public function UVClipNode()
		{
			_stateClass = UVClipState;
		}

		/**
		 * 添加帧
		 * @param uvFrame				UV动画帧
		 * @param duration				间隔时间
		 */
		public function addFrame(uvFrame:UVAnimationFrame, duration:uint):void
		{
			_frames.push(uvFrame);
			_durations.push(duration);
			_numFrames = _durations.length;

			_stitchDirty = true;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateStitch():void
		{
			super.updateStitch();
			var i:uint;

			if (_durations.length > 0)
			{

				i = _numFrames - 1;
				while (i--)
					_totalDuration += _durations[i];

				if (_stitchFinalFrame || !_looping)
					_totalDuration += _durations[_numFrames - 1];
			}

		}
	}
}
