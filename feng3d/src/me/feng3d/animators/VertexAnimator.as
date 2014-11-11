package me.feng3d.animators
{
	import flash.utils.Dictionary;
	
	import me.feng3d.arcane;
	import me.feng3d.animators.states.VertexClipState;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.base.ISubGeometry;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.base.subgeometry.VertexSubGeometry;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;

	use namespace arcane;

	/**
	 * 顶点动画
	 * @author warden_feng 2014-5-13
	 */
	public class VertexAnimator extends Animator
	{
		private var _vertexAnimationSet:VertexAnimationSet;
		private var _poses:Vector.<Geometry> = new Vector.<Geometry>();
		private var _weights:Vector.<Number> = Vector.<Number>([1, 0, 0, 0]);
		private var _activeVertexState:VertexClipState;
		private var _forceCPU:Boolean;

		private var _animationStates:Dictionary = new Dictionary();

		protected var weightsBufferTypeId:String = Context3DBufferTypeID.WEIGHTS_VC_VECTOR
		protected var weightsBuffer:VCVectorBuffer;

		/**
		 * 创建一个顶点动画
		 * @param vertexAnimationSet 顶点动画集合
		 */
		public function VertexAnimator(vertexAnimationSet:VertexAnimationSet, forceCPU:Boolean = false)
		{
			super(vertexAnimationSet);

			_forceCPU = forceCPU;
			if (forceCPU)
			{
				vertexAnimationSet.cancelGPUCompatibility();
			}

			_vertexAnimationSet = vertexAnimationSet;
		}

		public function get weights():Vector.<Number>
		{
			return _weights;
		}

		public function set weights(value:Vector.<Number>):void
		{
			_weights = value;
			weightsBuffer.invalid();
		}

		override protected function initBuffers():void
		{
			weightsBuffer = new VCVectorBuffer(weightsBufferTypeId,updateWeightsBuffer);
		}
		
		private function updateWeightsBuffer():void
		{
			weightsBuffer.update(weights);
		}
		
		override public function collectCache(context3dCache:Context3DCache):void
		{
			context3dCache.addDataBuffer(weightsBuffer);
		}
		
		override public function releaseCache(context3dCache:Context3DCache):void
		{
			context3dCache.removeDataBuffer(weightsBuffer);
		}

		/**
		 * 播放动画
		 * @param name 动作名称
		 * @param offset 时间偏移量
		 */
		/**
		 *
		 * @param name
		 * @param offset
		 * @throws Error
		 */
		public function play(name:String, offset:Number = NaN):void
		{
			if (_activeAnimationName != name)
			{
				_activeAnimationName = name;

				if (!_animationSet.hasAnimation(name))
					throw new Error("Animation root node " + name + " not found!");

				//获取活动的骨骼状态
				_activeNode = _animationSet.getAnimation(name);

				_activeState = getAnimationState(_activeNode);

				if (updatePosition)
				{
					//更新动画状态
					_activeState.update(_absoluteTime);
					_activeState.positionDelta;
				}

				_activeVertexState = _activeState as VertexClipState;
			}

			start();

			//使用时间偏移量处理特殊情况
			if (!isNaN(offset))
				reset(name, offset);
		}

		override public function setRenderState(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			//没有姿势时，使用默认姿势
			if (!_poses.length)
			{
				setNullPose(stage3DProxy, renderable)
				return;
			}

			// this type of animation can only be SubMesh
			var subMesh:SubMesh = SubMesh(renderable);
			var subGeom:ISubGeometry = SubMesh(renderable).subGeometry;

			if (_animationSet.usesCPU)
			{
				var subGeomAnimState:SubGeomAnimationState = _animationStates[subGeom] ||= new SubGeomAnimationState(subGeom);

				//检查动画数据
				if (subGeomAnimState.dirty)
				{
					var subGeom0:SubGeometry = _poses[uint(0)].subGeometries[subMesh._index];
					var subGeom1:SubGeometry = _poses[uint(1)].subGeometries[subMesh._index];
					morphGeometry(subGeomAnimState, subGeom0, subGeom1);
					subGeomAnimState.dirty = false;
				}
				//更新动画数据到几何体
				VertexSubGeometry(subGeom).updateVertexData(subGeomAnimState.animatedVertexData);
			}
			else
			{
				var vertexSubGeom:VertexSubGeometry = VertexSubGeometry(subGeom);
//				//获取默认姿势几何体数据
				subGeom = _poses[0].subGeometries[subMesh._index] || subMesh.subGeometry;
				vertexSubGeom.updateVertexData0(subGeom.vertexData.concat());

				subGeom = _poses[1].subGeometries[subMesh._index] || subMesh.subGeometry;
				vertexSubGeom.updateVertexData1(subGeom.vertexData.concat());
			}
		}

		private function setNullPose(stage3DProxy:Stage3DProxy, renderable:IRenderable):void
		{
			var subMesh:SubMesh = SubMesh(renderable);

			var subGeom:ISubGeometry = SubMesh(renderable).subGeometry;
		}

		override protected function updateDeltaTime(dt:Number):void
		{
			super.updateDeltaTime(dt);

			_poses[uint(0)] = _activeVertexState.currentGeometry;
			_poses[uint(1)] = _activeVertexState.nextGeometry;
			weights[uint(0)] = 1 - (weights[uint(1)] = _activeVertexState.blendWeight);
			weights = weights;

			for (var key:Object in _animationStates)
				SubGeomAnimationState(_animationStates[key]).dirty = true;
		}

		/**
		 * 几何体插值
		 * @param state 动画几何体数据
		 * @param subGeom 几何体0
		 * @param subGeom1 几何体1
		 */
		private function morphGeometry(state:SubGeomAnimationState, subGeom:SubGeometry, subGeom1:SubGeometry):void
		{
			//几何体顶点数据
			var vertexData:Vector.<Number> = subGeom.vertexData;
			var vertexData1:Vector.<Number> = subGeom1.vertexData;
			//动画顶点数据（目标数据）
			var targetData:Vector.<Number> = state.animatedVertexData;

			for (var i:int = 0; i < vertexData.length; i++)
			{
				targetData[i] = vertexData[i] * weights[0] + vertexData1[i] * weights[1];
			}
		}

	}
}
import me.feng3d.core.base.ISubGeometry;

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
	public function SubGeomAnimationState(subGeom:ISubGeometry)
	{
		animatedVertexData = subGeom.vertexData.concat();
	}
}
