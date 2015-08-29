package me.feng3d.animators.vertex
{
	import flash.geom.Vector3D;

	import me.feng3d.animators.base.node.AnimationClipNodeBase;
	import me.feng3d.core.base.Geometry;

	/**
	 * 顶点动画剪辑节点
	 * @author warden_feng 2014-5-30
	 */
	public class VertexClipNode extends AnimationClipNodeBase
	{
		private var _frames:Vector.<Geometry> = new Vector.<Geometry>();
		private var _translations:Vector.<Vector3D> = new Vector.<Vector3D>();

		/**
		 * 创建一个顶点动画剪辑节点
		 */
		public function VertexClipNode()
		{
			_stateClass = VertexClipState;
		}

		public function get frames():Vector.<Geometry>
		{
			return _frames;
		}

		/**
		 * 添加顶点动画帧
		 * @param geometry 几何体
		 * @param duration 持续时间
		 * @param translation 偏移量
		 */
		public function addFrame(geometry:Geometry, duration:uint, translation:Vector3D = null):void
		{
			_frames.push(geometry);
			_durations.push(duration);
			_translations.push(translation || new Vector3D());

			_numFrames = _durations.length;

			_stitchDirty = true;
		}

		override protected function updateStitch():void
		{
			super.updateStitch();

			var i:uint = _numFrames - 1;
			var p1:Vector3D, p2:Vector3D, delta:Vector3D;
			while (i--)
			{
				_totalDuration += _durations[i];
				p1 = _translations[i];
				p2 = _translations[i + 1];
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
					p1 = _translations[0];
					p2 = _translations[1];
					delta = p2.subtract(p1);
					_totalDelta.x += delta.x;
					_totalDelta.y += delta.y;
					_totalDelta.z += delta.z;
				}
			}
		}

	}
}
