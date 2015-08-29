package me.feng3d.animators.skeleton
{
	import flash.geom.Vector3D;

	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.states.AnimationClipState;
	import me.feng3d.animators.skeleton.data.JointPose;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.animators.skeleton.data.SkeletonPose;

	/**
	 *
	 */
	public class SkeletonClipState extends AnimationClipState implements ISkeletonAnimationState
	{
		private var _rootPos:Vector3D = new Vector3D();
		private var _frames:Vector.<SkeletonPose>;
		private var _skeletonClipNode:SkeletonClipNode;
		private var _skeletonPose:SkeletonPose = new SkeletonPose();
		private var _skeletonPoseDirty:Boolean = true;
		private var _currentPose:SkeletonPose;
		private var _nextPose:SkeletonPose;

		/**
		 * Returns the current skeleton pose frame of animation in the clip based on the internal playhead position.
		 */
		public function get currentPose():SkeletonPose
		{
			if (_framesDirty)
				updateFrames();

			return _currentPose;
		}

		/**
		 * Returns the next skeleton pose frame of animation in the clip based on the internal playhead position.
		 */
		public function get nextPose():SkeletonPose
		{
			if (_framesDirty)
				updateFrames();

			return _nextPose;
		}

		function SkeletonClipState(animator:IAnimator, skeletonClipNode:SkeletonClipNode)
		{
			super(animator, skeletonClipNode);

			_skeletonClipNode = skeletonClipNode;
			_frames = _skeletonClipNode.frames;
		}

		/**
		 * Returns the current skeleton pose of the animation in the clip based on the internal playhead position.
		 */
		public function getSkeletonPose(skeleton:Skeleton):SkeletonPose
		{
			if (_skeletonPoseDirty)
				updateSkeletonPose(skeleton);

			return _skeletonPose;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateTime(time:int):void
		{
			_skeletonPoseDirty = true;

			super.updateTime(time);
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateFrames():void
		{
			super.updateFrames();

			_currentPose = _frames[_currentFrame];

			if (_skeletonClipNode.looping && _nextFrame >= _skeletonClipNode.lastFrame)
			{
				_nextPose = _frames[0];
				SkeletonAnimator(_animator).dispatchCycleEvent();
			}
			else
				_nextPose = _frames[_nextFrame];
		}

		/**
		 * 更新骨骼姿势
		 * @param skeleton 骨骼
		 */
		private function updateSkeletonPose(skeleton:Skeleton):void
		{
			_skeletonPoseDirty = false;

			if (!_skeletonClipNode.totalDuration)
				return;

			if (_framesDirty)
				updateFrames();

			var currentPose:Vector.<JointPose> = _currentPose.jointPoses;
			var nextPose:Vector.<JointPose> = _nextPose.jointPoses;
			var numJoints:uint = skeleton.numJoints;
			var p1:Vector3D, p2:Vector3D;
			var pose1:JointPose, pose2:JointPose;
			var showPoses:Vector.<JointPose> = _skeletonPose.jointPoses;
			var showPose:JointPose;
			var tr:Vector3D;

			//调整当前显示关节姿势数量
			if (showPoses.length != numJoints)
				showPoses.length = numJoints;

			if ((numJoints != currentPose.length) || (numJoints != nextPose.length))
				throw new Error("joint counts don't match!");

			for (var i:uint = 0; i < numJoints; ++i)
			{
				showPose = showPoses[i] ||= new JointPose();
				pose1 = currentPose[i];
				pose2 = nextPose[i];
				p1 = pose1.translation;
				p2 = pose2.translation;

				//根据前后两个关节姿势计算出当前显示关节姿势
				showPose.orientation.lerp(pose1.orientation, pose2.orientation, _blendWeight);

				//计算显示的关节位置
				if (i > 0)
				{
					tr = showPose.translation;
					tr.x = p1.x + _blendWeight * (p2.x - p1.x);
					tr.y = p1.y + _blendWeight * (p2.y - p1.y);
					tr.z = p1.z + _blendWeight * (p2.z - p1.z);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function updatePositionDelta():void
		{
			_positionDeltaDirty = false;

			if (_framesDirty)
				updateFrames();

			var p1:Vector3D, p2:Vector3D, p3:Vector3D;
			var totalDelta:Vector3D = _skeletonClipNode.totalDelta;

			//跳过最后，重置位置
			if ((_timeDir > 0 && _nextFrame < _oldFrame) || (_timeDir < 0 && _nextFrame > _oldFrame))
			{
				_rootPos.x -= totalDelta.x * _timeDir;
				_rootPos.y -= totalDelta.y * _timeDir;
				_rootPos.z -= totalDelta.z * _timeDir;
			}

			/** 保存骨骼根节点原位置 */
			var dx:Number = _rootPos.x;
			var dy:Number = _rootPos.y;
			var dz:Number = _rootPos.z;

			//计算骨骼根节点位置
			if (_skeletonClipNode.stitchFinalFrame && _nextFrame == _skeletonClipNode.lastFrame)
			{
				p1 = _frames[0].jointPoses[0].translation;
				p2 = _frames[1].jointPoses[0].translation;
				p3 = _currentPose.jointPoses[0].translation;

				_rootPos.x = p3.x + p1.x + _blendWeight * (p2.x - p1.x);
				_rootPos.y = p3.y + p1.y + _blendWeight * (p2.y - p1.y);
				_rootPos.z = p3.z + p1.z + _blendWeight * (p2.z - p1.z);
			}
			else
			{
				p1 = _currentPose.jointPoses[0].translation;
				p2 = _frames[_nextFrame].jointPoses[0].translation; //cover the instances where we wrap the pose but still want the final frame translation values
				_rootPos.x = p1.x + _blendWeight * (p2.x - p1.x);
				_rootPos.y = p1.y + _blendWeight * (p2.y - p1.y);
				_rootPos.z = p1.z + _blendWeight * (p2.z - p1.z);
			}

			//计算骨骼根节点偏移量
			_rootDelta.x = _rootPos.x - dx;
			_rootDelta.y = _rootPos.y - dy;
			_rootDelta.z = _rootPos.z - dz;

			//保存旧帧编号
			_oldFrame = _nextFrame;
		}
	}
}
