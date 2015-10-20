package me.feng3d.lights
{
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.core.partition.node.EntityNode;
	import me.feng3d.core.partition.node.PointLightNode;

	use namespace arcane;

	/**
	 * 点灯光
	 * @author feng 2014-10-9
	 */
	public class PointLight extends LightBase
	{
		arcane var _radius:Number = 90000;
		arcane var _fallOff:Number = 100000;
		arcane var _fallOffFactor:Number;

		public function PointLight()
		{
			super();
			_fallOffFactor = 1 / (_fallOff * _fallOff - _radius * _radius);
		}

		/**
		 * 灯光可照射的最小距离
		 */
		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
			if (_radius < 0)
				_radius = 0;
			else if (_radius > _fallOff)
			{
				_fallOff = _radius;
				invalidateBounds();
			}

			_fallOffFactor = 1 / (_fallOff * _fallOff - _radius * _radius);
		}

		/**
		 * 灯光可照射的最大距离
		 */
		public function get fallOff():Number
		{
			return _fallOff;
		}

		public function set fallOff(value:Number):void
		{
			_fallOff = value;
			if (_fallOff < 0)
				_fallOff = 0;
			if (_fallOff < _radius)
				_radius = _fallOff;
			_fallOffFactor = 1 / (_fallOff * _fallOff - _radius * _radius);
			invalidateBounds();
		}

		/**
		 * @inheritDoc
		 */
		override protected function createEntityPartitionNode():EntityNode
		{
			return new PointLightNode(this);
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateBounds():void
		{
			//			super.updateBounds();
			//			_bounds.fromExtremes(-_fallOff, -_fallOff, -_fallOff, _fallOff, _fallOff, _fallOff);
			_bounds.fromSphere(new Vector3D(), _fallOff);
			_boundsInvalid = false;
		}

	}
}
