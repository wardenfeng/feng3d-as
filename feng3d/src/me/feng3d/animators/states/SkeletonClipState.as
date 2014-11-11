package me.feng3d.animators.states
{
	import flash.geom.Vector3D;
	
	import me.feng3d.animators.Animator;
	import me.feng3d.animators.SkeletonAnimator;
	import me.feng3d.animators.data.JointPose;
	import me.feng3d.animators.data.Skeleton;
	import me.feng3d.animators.data.SkeletonPose;
	import me.feng3d.animators.nodes.SkeletonClipNode;
	
	/**
	 * 骨骼剪辑状态
	 * @author warden_feng 2014-5-29
	 */
	public class SkeletonClipState extends AnimationClipState
	{
		/** 骨骼根节点位置 */
		private var _rootPos:Vector3D = new Vector3D();
		private var _frames:Vector.<SkeletonPose>;
		private var _skeletonClipNode:SkeletonClipNode;
		/** 显示关节姿势 */
		private var _skeletonPose:SkeletonPose = new SkeletonPose();
		private var _showSkeletonPoseDirty:Boolean = true;
		private var _currentPose:SkeletonPose;
		private var _nextPose:SkeletonPose;
		
		/**
		 * 创建一个骨骼剪辑状态
		 * @param animator 动画
		 * @param skeletonClipNode 骨骼剪辑节点
		 */		
		public function SkeletonClipState(animator:Animator, skeletonClipNode:SkeletonClipNode)
		{
			super(animator, skeletonClipNode);
			
			_skeletonClipNode = skeletonClipNode;
			_frames = _skeletonClipNode.frames;
		}
		
		/**
		 * 获取骨骼姿势
		 * @param skeleton 骨骼
		 * @return 骨骼姿势
		 */		
		public function getSkeletonPose(skeleton:Skeleton):SkeletonPose
		{
			if (_showSkeletonPoseDirty)
				updateSkeletonPose(skeleton);
			
			return _skeletonPose;
		}
		
		override protected function updateTime(time:int):void
		{
			_showSkeletonPoseDirty = true;
			
			super.updateTime(time);
		}
		
		override protected function updateFrames():void
		{
			super.updateFrames();
			
			//更新当前阵姿势与下一帧姿势
			_currentPose = _frames[_currentFrame];
			
			if (_skeletonClipNode.looping && _nextFrame >= _skeletonClipNode.lastFrame) {
				_nextPose = _frames[0];
				SkeletonAnimator(_animator).dispatchCycleEvent();
			} else
				_nextPose = _frames[_nextFrame];
		}
		
		/**
		 * 更新骨骼姿势
		 * @param skeleton 骨骼
		 */		
		private function updateSkeletonPose(skeleton:Skeleton):void
		{
			_showSkeletonPoseDirty = false;
			
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
			
			for (var i:uint = 0; i < numJoints; ++i) {
				showPose = showPoses[i] ||= new JointPose();
				pose1 = currentPose[i];
				pose2 = nextPose[i];
				p1 = pose1.translation;
				p2 = pose2.translation;
				
				//根据前后两个关节姿势计算出当前显示关节姿势
				showPose.orientation.lerp(pose1.orientation, pose2.orientation, _blendWeight);
				
				//计算显示的关节位置
				if (i > 0) {
					tr = showPose.translation;
					tr.x = p1.x + _blendWeight*(p2.x - p1.x);
					tr.y = p1.y + _blendWeight*(p2.y - p1.y);
					tr.z = p1.z + _blendWeight*(p2.z - p1.z);
				}
			}
		}
		
		override protected function updatePositionDelta():void
		{
			_positionDeltaDirty = false;
			
			if (_framesDirty)
				updateFrames();
			
			var p1:Vector3D, p2:Vector3D, p3:Vector3D;
			var totalDelta:Vector3D = _skeletonClipNode.totalDelta;
			
			//跳过最后，重置位置
			if ((_timeDir > 0 && _nextFrame < _oldFrame) || (_timeDir < 0 && _nextFrame > _oldFrame)) {
				_rootPos.x -= totalDelta.x*_timeDir;
				_rootPos.y -= totalDelta.y*_timeDir;
				_rootPos.z -= totalDelta.z*_timeDir;
			}
			
			/** 保存骨骼根节点原位置 */
			var oldRootPos:Vector3D = _rootPos.clone();
			
			//计算骨骼根节点位置
			if (_skeletonClipNode.stitchFinalFrame && _nextFrame == _skeletonClipNode.lastFrame) {
				p1 = _frames[0].jointPoses[0].translation;
				p2 = _frames[1].jointPoses[0].translation;
				p3 = _currentPose.jointPoses[0].translation;
				
				_rootPos.x = p3.x + p1.x + _blendWeight*(p2.x - p1.x);
				_rootPos.y = p3.y + p1.y + _blendWeight*(p2.y - p1.y);
				_rootPos.z = p3.z + p1.z + _blendWeight*(p2.z - p1.z);
			} else {
				p1 = _currentPose.jointPoses[0].translation;
				p2 = _frames[_nextFrame].jointPoses[0].translation; //cover the instances where we wrap the pose but still want the final frame translation values
				_rootPos.x = p1.x + _blendWeight*(p2.x - p1.x);
				_rootPos.y = p1.y + _blendWeight*(p2.y - p1.y);
				_rootPos.z = p1.z + _blendWeight*(p2.z - p1.z);
			}
			
			//计算骨骼根节点偏移量
			_rootDelta.x = _rootPos.x - oldRootPos.x;
			_rootDelta.y = _rootPos.y - oldRootPos.y;
			_rootDelta.z = _rootPos.z - oldRootPos.z;
			
			//保存旧帧编号
			_oldFrame = _nextFrame;
		}
		
	}
}