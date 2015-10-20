package me.feng3d.animators.skeleton
{
	import flash.geom.Vector3D;

	import me.feng3d.animators.skeleton.data.SkeletonPose;
	import me.feng3d.animators.base.node.AnimationClipNodeBase;

	/**
	 * 骨骼动画节点（一般用于一个动画的帧列表）
	 * 包含基于时间的动画数据作为单独的骨架构成。
	 * @author feng 2014-5-20
	 */
	public class SkeletonClipNode extends AnimationClipNodeBase
	{
		private var _frames:Vector.<SkeletonPose> = new Vector.<SkeletonPose>();

		/**
		 * 创建骨骼动画节点
		 */
		public function SkeletonClipNode()
		{
			_stateClass = SkeletonClipState;
		}

		/**
		 * 骨骼姿势动画帧列表
		 */
		public function get frames():Vector.<SkeletonPose>
		{
			return _frames;
		}

		/**
		 * 添加帧到动画
		 * @param skeletonPose 骨骼姿势
		 * @param duration 持续时间
		 */
		public function addFrame(skeletonPose:SkeletonPose, duration:uint):void
		{
			_frames.push(skeletonPose);
			_durations.push(duration);
			_totalDuration += duration;

			_numFrames = _durations.length;

			_stitchDirty = true;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateStitch():void
		{
			super.updateStitch();

			var i:uint = _numFrames - 1;
			var p1:Vector3D, p2:Vector3D, delta:Vector3D;
			while (i--)
			{
				_totalDuration += _durations[i];
				p1 = _frames[i].jointPoses[0].translation;
				p2 = _frames[i + 1].jointPoses[0].translation;
				delta = p2.subtract(p1);
				_totalDelta.x += delta.x;
				_totalDelta.y += delta.y;
				_totalDelta.z += delta.z;
			}

			if (_stitchFinalFrame && _looping)
			{
				_totalDuration += _durations[_numFrames - 1];
				if (_numFrames > 1)
				{
					p1 = _frames[0].jointPoses[0].translation;
					p2 = _frames[1].jointPoses[0].translation;
					delta = p2.subtract(p1);
					_totalDelta.x += delta.x;
					_totalDelta.y += delta.y;
					_totalDelta.z += delta.z;
				}
			}
		}
	}
}
