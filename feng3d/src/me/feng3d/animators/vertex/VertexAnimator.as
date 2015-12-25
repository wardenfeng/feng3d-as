package me.feng3d.animators.vertex
{
	import me.feng3d.arcane;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.animators.base.transitions.IAnimationTransition;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.components.subgeometry.VertexSubGeometry;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.entities.Mesh;

	use namespace arcane;

	/**
	 * 顶点动画
	 * @author feng 2014-5-13
	 */
	public class VertexAnimator extends AnimatorBase
	{
		private const _weights:Vector.<Number> = Vector.<Number>([1, 0, 0, 0]);

		private var _vertexAnimationSet:VertexAnimationSet;
		private var _poses:Vector.<Geometry> = new Vector.<Geometry>();
		private var _numPoses:uint;

		private var _activeVertexState:IVertexAnimationState;

		/**
		 * 创建一个顶点动画
		 * @param vertexAnimationSet 顶点动画集合
		 */
		public function VertexAnimator(vertexAnimationSet:VertexAnimationSet)
		{
			super(vertexAnimationSet);

			_vertexAnimationSet = vertexAnimationSet;
			_numPoses = vertexAnimationSet.numPoses;
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			context3DBufferOwner.mapContext3DBuffer(_.weights_vc_vector, updateWeightsBuffer);
		}

		private function updateWeightsBuffer(weightsBuffer:VCVectorBuffer):void
		{
			weightsBuffer.update(_weights);
		}

		/**
		 * 播放动画
		 * @param name 动作名称
		 * @param offset 时间偏移量
		 */
		public function play(name:String, transition:IAnimationTransition = null, offset:Number = NaN):void
		{
			if (_activeAnimationName != name)
			{
				_activeAnimationName = name;

				if (!_vertexAnimationSet.hasAnimation(name))
					throw new Error("Animation root node " + name + " not found!");

				//获取活动的骨骼状态
				_activeNode = _vertexAnimationSet.getAnimation(name) as VertexClipNode;

				_activeState = getAnimationState(_activeNode);

				if (updatePosition)
				{
					//update straight away to reset position deltas
					_activeState.update(_absoluteTime);
					_activeState.positionDelta;
				}

				_activeVertexState = _activeState as IVertexAnimationState;
			}

			start();

			//使用时间偏移量处理特殊情况
			if (!isNaN(offset))
				reset(name, offset);
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateDeltaTime(dt:Number):void
		{
			super.updateDeltaTime(dt);

			_poses[uint(0)] = _activeVertexState.currentGeometry;
			_poses[uint(1)] = _activeVertexState.nextGeometry;
			_weights[uint(0)] = 1 - (_weights[uint(1)] = _activeVertexState.blendWeight);
		}

		/**
		 * @inheritDoc
		 */
		override public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			//没有姿势时，使用默认姿势
			if (!_poses.length)
			{
				setNullPose(renderable)
				return;
			}

			// this type of animation can only be SubMesh
			var subMesh:SubMesh = SubMesh(renderable);
			var subGeom:SubGeometry = subMesh.subGeometry;

			var vertexSubGeom:VertexSubGeometry = subGeom.getOrCreateComponentByClass(VertexSubGeometry);
//				//获取默认姿势几何体数据
			subGeom = _poses[0].subGeometries[subMesh._index] || subMesh.subGeometry;
			vertexSubGeom.updateVertexData0(subGeom.vertexPositionData.concat());

			subGeom = _poses[1].subGeometries[subMesh._index] || subMesh.subGeometry;
			vertexSubGeom.updateVertexData1(subGeom.vertexPositionData.concat());
		}

		/**
		 * 设置空姿势
		 * @param renderable		渲染对象
		 */
		private function setNullPose(renderable:IRenderable):void
		{
			var subMesh:SubMesh = SubMesh(renderable);

			var subGeom:SubGeometry = SubMesh(renderable).subGeometry;
		}

		override public function addOwner(mesh:Mesh):void
		{
			var geometry:Geometry = mesh.geometry;

			var i:int;
			var subGeometry:SubGeometry;
			for (i = 0; i < geometry.subGeometries.length; i++)
			{
				subGeometry = geometry.subGeometries[i] as SubGeometry;
				subGeometry.getOrCreateComponentByClass(VertexSubGeometry);
			}

			super.addOwner(mesh);
		}
	}
}
