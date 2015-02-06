package me.feng3d.animators.skeleton
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import me.feng3d.arcane;
	import me.feng3d.animators.skeleton.data.JointPose;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.animators.skeleton.data.SkeletonJoint;
	import me.feng3d.animators.skeleton.data.SkeletonPose;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.base.subgeometry.SkinnedSubGeometry;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.core.math.Quaternion;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.MultiClipAnimator;

	use namespace arcane;

	/**
	 * 骨骼动画
	 * @author warden_feng 2014-5-27
	 */
	public class SkeletonAnimator extends MultiClipAnimator implements IAnimator
	{
		private const _globalMatrices:Vector.<Number> = new Vector.<Number>();
		private var _globalPose:SkeletonPose = new SkeletonPose();
		private var _globalPropertiesDirty:Boolean;
		private var _numJoints:uint;
		private var _animationStates:Dictionary = new Dictionary();

		private var _skeleton:Skeleton;
		private var _forceCPU:Boolean;
		private var _jointsPerVertex:uint;

		private var _skeletonAnimationSet:SkeletonAnimationSet;

		/** 骨骼根节点位置 */
		private var _rootPos:Vector3D = new Vector3D();
		/** 显示关节姿势 */
		private var _skeletonPose:SkeletonPose = new SkeletonPose();
		private var _showSkeletonPoseDirty:Boolean = true;
		
		private var _activeSkeletonClipNode:SkeletonClipNode;
		
		/**
		 * 是否强行使用cpu
		 */
		public function get forceCPU():Boolean
		{
			return _forceCPU;
		}

		public function get animationSet():AnimationSetBase
		{
			return _skeletonAnimationSet;
		}

		/**
		 * 创建一个骨骼动画类
		 * @param animationSet 动画集合
		 * @param skeleton 骨骼
		 * @param forceCPU 是否强行使用cpu
		 */
		public function SkeletonAnimator(animationSet:SkeletonAnimationSet, skeleton:Skeleton, forceCPU:Boolean = false)
		{
			_skeletonAnimationSet = animationSet;

			_skeleton = skeleton;
			_forceCPU = forceCPU;
			_jointsPerVertex = _skeletonAnimationSet.jointsPerVertex;

			if (forceCPU)
			{
				_skeletonAnimationSet.cancelGPUCompatibility();
			}

			_numJoints = _skeleton.numJoints;
			_skeletonAnimationSet.numJoints = _skeleton.numJoints;

			_globalMatrices.length = _numJoints * 12;
			_globalMatrices.fixed = true;

			//初始化骨骼转换矩阵
			var j:int;
			for (var i:uint = 0; i < _numJoints; ++i)
			{
				_globalMatrices[j++] = 1;
				_globalMatrices[j++] = 0;
				_globalMatrices[j++] = 0;
				_globalMatrices[j++] = 0;
				_globalMatrices[j++] = 0;
				_globalMatrices[j++] = 1;
				_globalMatrices[j++] = 0;
				_globalMatrices[j++] = 0;
				_globalMatrices[j++] = 0;
				_globalMatrices[j++] = 0;
				_globalMatrices[j++] = 1;
				_globalMatrices[j++] = 0;
			}
		}
		
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeID.GLOBALMATRICES_VC_VECTOR, VCVectorBuffer, updateGlobalmatricesBuffer);
		}
		
		private function updateGlobalmatricesBuffer(globalmatricesBuffer:VCVectorBuffer):void
		{
			globalmatricesBuffer.update(_globalMatrices);
		}

		/**
		 * 播放动画
		 * @param name 动作名称
		 * @param offset 偏移量
		 */
		public function play(animationName:String, offset:Number = NaN):void
		{
			if (_activeAnimationName != animationName)
			{
				_activeAnimationName = animationName;

				if (!_skeletonAnimationSet.hasAnimation(animationName))
					throw new Error("Animation root node " + animationName + " not found!");

				//获取活动的骨骼状态
				_activeSkeletonClipNode = _skeletonAnimationSet.getAnimation(animationName) as SkeletonClipNode;
				
				_numFrames = _activeSkeletonClipNode.frames.length;
				cycle = _activeSkeletonClipNode.totalDuration;
			}

			start();

			//使用时间偏移量处理特殊情况
			if (!isNaN(offset))
				reset(animationName, offset);
		}

		public function setRenderState(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			//检查全局变换矩阵
			if (_globalPropertiesDirty)
				updateGlobalProperties();

			var skinnedGeom:SkinnedSubGeometry = SkinnedSubGeometry(SubMesh(renderable).subGeometry);

			if (_skeletonAnimationSet.usesCPU)
			{
				var subGeomAnimState:SubGeomAnimationState = _animationStates[skinnedGeom] ||= new SubGeomAnimationState(skinnedGeom);

				//检查动画数据
				if (subGeomAnimState.dirty)
				{
					morphGeometry(subGeomAnimState, skinnedGeom);
					subGeomAnimState.dirty = false;
				}
				//更新动画数据到几何体
				skinnedGeom.updateAnimatedData(subGeomAnimState.animatedVertexData);
			}
		}

		override protected function update():void
		{
			super.update();

			_showSkeletonPoseDirty = true;
			
			markBufferDirty(Context3DBufferTypeID.GLOBALMATRICES_VC_VECTOR);

			_globalPropertiesDirty = true;

			for (var key:Object in _animationStates)
				SubGeomAnimationState(_animationStates[key]).dirty = true;
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

		/**
		 * 更新骨骼全局转换矩阵
		 */
		private function updateGlobalProperties():void
		{
			_globalPropertiesDirty = false;

			//获取全局骨骼姿势
			localToGlobalPose(getSkeletonPose(_skeleton), _globalPose, _skeleton);

			//姿势转换矩阵
			//矩阵偏移量
			var mtxOffset:uint;
			var globalPoses:Vector.<JointPose> = _globalPose.jointPoses;
			var raw:Vector.<Number>;
			var ox:Number, oy:Number, oz:Number, ow:Number;
			var xy2:Number, xz2:Number, xw2:Number;
			var yz2:Number, yw2:Number, zw2:Number;
			var n11:Number, n12:Number, n13:Number;
			var n21:Number, n22:Number, n23:Number;
			var n31:Number, n32:Number, n33:Number;
			var m11:Number, m12:Number, m13:Number, m14:Number;
			var m21:Number, m22:Number, m23:Number, m24:Number;
			var m31:Number, m32:Number, m33:Number, m34:Number;
			var joints:Vector.<SkeletonJoint> = _skeleton.joints;
			var pose:JointPose;
			var quat:Quaternion;
			var vec:Vector3D;
			var t:Number;

			//遍历每个关节
			for (var i:uint = 0; i < _numJoints; ++i)
			{
				//读取关节全局姿势数据
				pose = globalPoses[i];
				quat = pose.orientation;
				vec = pose.translation;
				ox = quat.x;
				oy = quat.y;
				oz = quat.z;
				ow = quat.w;

				//计算关节的全局转换矩阵
				xy2 = (t = 2.0 * ox) * oy;
				xz2 = t * oz;
				xw2 = t * ow;
				yz2 = (t = 2.0 * oy) * oz;
				yw2 = t * ow;
				zw2 = 2.0 * oz * ow;

				yz2 = 2.0 * oy * oz;
				yw2 = 2.0 * oy * ow;
				zw2 = 2.0 * oz * ow;
				ox *= ox;
				oy *= oy;
				oz *= oz;
				ow *= ow;

				//保存关节的全局转换矩阵
				n11 = (t = ox - oy) - oz + ow;
				n12 = xy2 - zw2;
				n13 = xz2 + yw2;
				n21 = xy2 + zw2;
				n22 = -t - oz + ow;
				n23 = yz2 - xw2;
				n31 = xz2 - yw2;
				n32 = yz2 + xw2;
				n33 = -ox - oy + oz + ow;

				//初始状态 下关节的 逆矩阵
				raw = joints[i].inverseBindPose;
				m11 = raw[0];
				m12 = raw[4];
				m13 = raw[8];
				m14 = raw[12];
				m21 = raw[1];
				m22 = raw[5];
				m23 = raw[9];
				m24 = raw[13];
				m31 = raw[2];
				m32 = raw[6];
				m33 = raw[10];
				m34 = raw[14];

				//计算关节全局转换矩阵(通过初始状态 关节逆矩阵与全局转换矩阵 计算 当前状态的关节矩阵)
				_globalMatrices[uint(mtxOffset)] = n11 * m11 + n12 * m21 + n13 * m31;
				_globalMatrices[uint(mtxOffset + 1)] = n11 * m12 + n12 * m22 + n13 * m32;
				_globalMatrices[uint(mtxOffset + 2)] = n11 * m13 + n12 * m23 + n13 * m33;
				_globalMatrices[uint(mtxOffset + 3)] = n11 * m14 + n12 * m24 + n13 * m34 + vec.x;
				_globalMatrices[uint(mtxOffset + 4)] = n21 * m11 + n22 * m21 + n23 * m31;
				_globalMatrices[uint(mtxOffset + 5)] = n21 * m12 + n22 * m22 + n23 * m32;
				_globalMatrices[uint(mtxOffset + 6)] = n21 * m13 + n22 * m23 + n23 * m33;
				_globalMatrices[uint(mtxOffset + 7)] = n21 * m14 + n22 * m24 + n23 * m34 + vec.y;
				_globalMatrices[uint(mtxOffset + 8)] = n31 * m11 + n32 * m21 + n33 * m31;
				_globalMatrices[uint(mtxOffset + 9)] = n31 * m12 + n32 * m22 + n33 * m32;
				_globalMatrices[uint(mtxOffset + 10)] = n31 * m13 + n32 * m23 + n33 * m33;
				_globalMatrices[uint(mtxOffset + 11)] = n31 * m14 + n32 * m24 + n33 * m34 + vec.z;

				//跳到下个矩阵位置
				mtxOffset = uint(mtxOffset + 12);
			}
		}

		/**
		 * 几何体变形
		 * @param state 动画几何体数据
		 * @param subGeom 蒙皮几何体
		 */
		private function morphGeometry(state:SubGeomAnimationState, subGeom:SkinnedSubGeometry):void
		{
			//几何体顶点数据
			var vertexData:Vector.<Number> = subGeom.getVAData(Context3DBufferTypeID.POSITION_VA_3);
			//动画顶点数据（目标数据）
			var targetData:Vector.<Number> = state.animatedVertexData;
			var jointIndices:Vector.<Number> = subGeom.jointIndexData;
			var jointWeights:Vector.<Number> = subGeom.jointWeightsData;
			var index:uint;
			var j:uint, k:uint;
			var vx:Number, vy:Number, vz:Number;
			var len:int = vertexData.length;
			var weight:Number;
			var vertX:Number, vertY:Number, vertZ:Number;
			var m11:Number, m12:Number, m13:Number, m14:Number;
			var m21:Number, m22:Number, m23:Number, m24:Number;
			var m31:Number, m32:Number, m33:Number, m34:Number;

			//计算每个顶点的坐标，法线、切线
			while (index < len)
			{
				//提取原始顶点坐标、法线、切线数据
				vertX = vertexData[index];
				vertY = vertexData[uint(index + 1)];
				vertZ = vertexData[uint(index + 2)];
				vx = 0;
				vy = 0;
				vz = 0;
				k = 0;
				//遍历与该顶点相关的关节权重
				while (k < _jointsPerVertex)
				{
					weight = jointWeights[j];
					if (weight > 0)
					{
						//读取该关节的全局转换矩阵
						var mtxOffset:uint = uint(jointIndices[j++]) << 2;
						m11 = _globalMatrices[mtxOffset];
						m12 = _globalMatrices[uint(mtxOffset + 1)];
						m13 = _globalMatrices[uint(mtxOffset + 2)];
						m14 = _globalMatrices[uint(mtxOffset + 3)];
						m21 = _globalMatrices[uint(mtxOffset + 4)];
						m22 = _globalMatrices[uint(mtxOffset + 5)];
						m23 = _globalMatrices[uint(mtxOffset + 6)];
						m24 = _globalMatrices[uint(mtxOffset + 7)];
						m31 = _globalMatrices[uint(mtxOffset + 8)];
						m32 = _globalMatrices[uint(mtxOffset + 9)];
						m33 = _globalMatrices[uint(mtxOffset + 10)];
						m34 = _globalMatrices[uint(mtxOffset + 11)];
						//根据关节的全局转换矩阵与对应权重计算出对该坐标的影响值
						vx += weight * (m11 * vertX + m12 * vertY + m13 * vertZ + m14);
						vy += weight * (m21 * vertX + m22 * vertY + m23 * vertZ + m24);
						vz += weight * (m31 * vertX + m32 * vertY + m33 * vertZ + m34);
						++k;
					}
					else
					{
						j += uint(_jointsPerVertex - k);
						k = _jointsPerVertex;
					}
				}

				//保存最终计算得出的坐标、法线、切线数据
				targetData[index] = vx;
				targetData[uint(index + 1)] = vy;
				targetData[uint(index + 2)] = vz;

				//跳到下个顶点的起始位置
				index = uint(index + subGeom.getVALen(Context3DBufferTypeID.POSITION_VA_3));
			}
		}

		/**
		 * 本地转换到全局姿势
		 * @param sourcePose 原姿势
		 * @param targetPose 目标姿势
		 * @param skeleton 骨骼
		 */
		protected function localToGlobalPose(sourcePose:SkeletonPose, targetPose:SkeletonPose, skeleton:Skeleton):void
		{
			var globalPoses:Vector.<JointPose> = targetPose.jointPoses;
			var globalJointPose:JointPose;
			var joints:Vector.<SkeletonJoint> = skeleton.joints;
			var len:uint = sourcePose.numJointPoses;
			var jointPoses:Vector.<JointPose> = sourcePose.jointPoses;
			var parentIndex:int;
			var joint:SkeletonJoint;
			var parentPose:JointPose;
			var pose:JointPose;
			var or:Quaternion;
			var tr:Vector3D;
			var gTra:Vector3D;
			var gOri:Quaternion;

			var x1:Number, y1:Number, z1:Number, w1:Number;
			var x2:Number, y2:Number, z2:Number, w2:Number;
			var x3:Number, y3:Number, z3:Number;

			//初始化全局骨骼姿势长度
			if (globalPoses.length != len)
				globalPoses.length = len;

			for (var i:uint = 0; i < len; ++i)
			{
				//初始化单个全局骨骼姿势
				globalJointPose = globalPoses[i] ||= new JointPose();
				joint = joints[i];
				parentIndex = joint.parentIndex;
				pose = jointPoses[i];

				//世界方向偏移
				gOri = globalJointPose.orientation;
				//全局位置偏移
				gTra = globalJointPose.translation;

				//计算全局骨骼的 方向偏移与位置偏移
				if (parentIndex < 0)
				{
					//处理跟骨骼(直接赋值)
					tr = pose.translation;
					or = pose.orientation;
					gOri.x = or.x;
					gOri.y = or.y;
					gOri.z = or.z;
					gOri.w = or.w;
					gTra.x = tr.x;
					gTra.y = tr.y;
					gTra.z = tr.z;
				}
				else
				{
					//处理其他骨骼

					//找到父骨骼全局姿势
					parentPose = globalPoses[parentIndex];

					or = parentPose.orientation;
					tr = pose.translation;
					//提取父姿势的世界方向数据
					x2 = or.x;
					y2 = or.y;
					z2 = or.z;
					w2 = or.w;
					//提取当前姿势相对父姿势的位置数据
					x3 = tr.x;
					y3 = tr.y;
					z3 = tr.z;

					//计算当前姿势相对父姿势在全局中的位置偏移方向(有点没搞懂，我只能这么说如果一定要我来计算的话，我一定能做出来)
					w1 = -x2 * x3 - y2 * y3 - z2 * z3;
					x1 = w2 * x3 + y2 * z3 - z2 * y3;
					y1 = w2 * y3 - x2 * z3 + z2 * x3;
					z1 = w2 * z3 + x2 * y3 - y2 * x3;

					//计算当前骨骼全局姿势的位置数据（父姿势的世界坐标加上当前姿势相对父姿势转换为全局的坐标变化量）
					tr = parentPose.translation;
					gTra.x = -w1 * x2 + x1 * w2 - y1 * z2 + z1 * y2 + tr.x;
					gTra.y = -w1 * y2 + x1 * z2 + y1 * w2 - z1 * x2 + tr.y;
					gTra.z = -w1 * z2 - x1 * y2 + y1 * x2 + z1 * w2 + tr.z;

					//提取父姿势的世界方向数据
					x1 = or.x;
					y1 = or.y;
					z1 = or.z;
					w1 = or.w;
					//提取当前姿势相对父姿势的方向数据
					or = pose.orientation;
					x2 = or.x;
					y2 = or.y;
					z2 = or.z;
					w2 = or.w;

					//根据父姿势的世界方向数据与当前姿势的方向数据计算当前姿势的世界方向数据
					gOri.w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2;
					gOri.x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2;
					gOri.y = w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2;
					gOri.z = w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2;
				}
			}
		}
		
		/**
		 * 更新骨骼姿势
		 * @param skeleton 骨骼
		 */		
		private function updateSkeletonPose(skeleton:Skeleton):void
		{
			_showSkeletonPoseDirty = false;
			
			if (!_activeSkeletonClipNode.totalDuration)
				return;
			
			if (_framesDirty)
				updateFrames();
			
			var currentPose:Vector.<JointPose> = _activeSkeletonClipNode.frames[currentFrame].jointPoses;
			var nextPose:Vector.<JointPose> = _activeSkeletonClipNode.frames[nextFrame].jointPoses;
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
		
//		protected function updatePositionDelta():void
//		{
//			_positionDeltaDirty = false;
//			
//			if (_framesDirty)
//				updateFrames();
//			
//			var p1:Vector3D, p2:Vector3D, p3:Vector3D;
//			var totalDelta:Vector3D = _skeletonClipNode.totalDelta;
//			
//			//跳过最后，重置位置
//			if ((_timeDir > 0 && _nextFrame < _oldFrame) || (_timeDir < 0 && _nextFrame > _oldFrame)) {
//				_rootPos.x -= totalDelta.x*_timeDir;
//				_rootPos.y -= totalDelta.y*_timeDir;
//				_rootPos.z -= totalDelta.z*_timeDir;
//			}
//			
//			/** 保存骨骼根节点原位置 */
//			var oldRootPos:Vector3D = _rootPos.clone();
//			
//			//计算骨骼根节点位置
//			if (_skeletonClipNode.stitchFinalFrame && _nextFrame == _skeletonClipNode.lastFrame) {
//				p1 = _frames[0].jointPoses[0].translation;
//				p2 = _frames[1].jointPoses[0].translation;
//				p3 = _currentPose.jointPoses[0].translation;
//				
//				_rootPos.x = p3.x + p1.x + _blendWeight*(p2.x - p1.x);
//				_rootPos.y = p3.y + p1.y + _blendWeight*(p2.y - p1.y);
//				_rootPos.z = p3.z + p1.z + _blendWeight*(p2.z - p1.z);
//			} else {
//				p1 = _currentPose.jointPoses[0].translation;
//				p2 = _frames[_nextFrame].jointPoses[0].translation; //cover the instances where we wrap the pose but still want the final frame translation values
//				_rootPos.x = p1.x + _blendWeight*(p2.x - p1.x);
//				_rootPos.y = p1.y + _blendWeight*(p2.y - p1.y);
//				_rootPos.z = p1.z + _blendWeight*(p2.z - p1.z);
//			}
//			
//			//计算骨骼根节点偏移量
//			_rootDelta.x = _rootPos.x - oldRootPos.x;
//			_rootDelta.y = _rootPos.y - oldRootPos.y;
//			_rootDelta.z = _rootPos.z - oldRootPos.z;
//			
//			//保存旧帧编号
//			_oldFrame = _nextFrame;
//		}
		
	}
}
import me.feng3d.core.base.subgeometry.SubGeometry;
import me.feng3d.core.buffer.Context3DBufferTypeID;

/**
 * 动画状态几何体数据
 */
class SubGeomAnimationState
{
	/**
	 * 动画顶点数据
	 */
	public var animatedVertexData:Vector.<Number>;
	public var dirty:Boolean = true;

	/**
	 * 创建一个动画当前状态的数据类(用来保存动画顶点数据)
	 */
	public function SubGeomAnimationState(subGeom:SubGeometry)
	{
		animatedVertexData = subGeom.getVAData(Context3DBufferTypeID.POSITION_VA_3).concat();
	}
}
