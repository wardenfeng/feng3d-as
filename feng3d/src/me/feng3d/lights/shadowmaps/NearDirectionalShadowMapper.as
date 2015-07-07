package me.feng3d.lights.shadowmaps
{
	import me.feng3d.cameras.Camera3D;

	/**
	 *
	 * @author warden_feng 2015-5-28
	 */
	public class NearDirectionalShadowMapper extends DirectionalShadowMapper
	{
		private var _coverageRatio:Number;

		public function NearDirectionalShadowMapper(coverageRatio:Number = .5)
		{
			super();
			this.coverageRatio = coverageRatio;
		}

		/**
		 * A value between 0 and 1 to indicate the ratio of the view frustum that needs to be covered by the shadow map.
		 *
		 * 阴影的覆盖视椎体的比例
		 * <p>0表示视椎体内看不到阴影，0.5表示从近平面到与远平面之间可以看到阴影，1表示视椎体内都可以看到阴影。</p>
		 * <p><b>注：看到阴影的前提是有阴影产生</b></p>
		 */
		public function get coverageRatio():Number
		{
			return _coverageRatio;
		}

		public function set coverageRatio(value:Number):void
		{
			if (value > 1)
				value = 1;
			else if (value < 0)
				value = 0;

			_coverageRatio = value;
		}

		override protected function updateDepthProjection(viewCamera:Camera3D):void
		{
			var corners:Vector.<Number> = viewCamera.lens.frustumCorners;

			for (var i:int = 0; i < 12; ++i)
			{
				var v:Number = corners[i];
				_localFrustum[i] = v;
				_localFrustum[uint(i + 12)] = v + (corners[uint(i + 12)] - v) * _coverageRatio;
			}

			updateProjectionFromFrustumCorners(viewCamera, _localFrustum, _matrix);
			_overallDepthLens.matrix = _matrix;
		}
	}
}
