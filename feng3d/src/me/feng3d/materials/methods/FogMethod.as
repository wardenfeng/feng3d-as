package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcane;

	/**
	 *
	 * FogMethod provides a method to add distance-based fog to a material.
	 * @author warden_feng 2015-8-27
	 */
	public class FogMethod extends EffectMethodBase
	{
		private var _minDistance:Number = 0;
		private var _maxDistance:Number = 1000;
		private var _fogColor:uint;

		/**
		 * 雾颜色常量数据
		 */
		private const fogColorData:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);

		/**
		 * 雾通用常量数据
		 */
		private const fogCommonData:Vector.<Number> = Vector.<Number>([0, 0, 0, 0]);

		/**
		 * The distance from which the fog starts appearing.
		 */
		public function get minDistance():Number
		{
			return _minDistance;
		}

		public function set minDistance(value:Number):void
		{
			_minDistance = value;
		}

		/**
		 * The distance at which the fog is densest.
		 */
		public function get maxDistance():Number
		{
			return _maxDistance;
		}

		public function set maxDistance(value:Number):void
		{
			_maxDistance = value;
		}

		/**
		 * The colour of the fog.
		 */
		public function get fogColor():uint
		{
			return _fogColor;
		}

		public function set fogColor(value:uint):void
		{
			_fogColor = value;
			fogColorData[0] = ((value >> 16) & 0xff) / 0xff;
			fogColorData[1] = ((value >> 8) & 0xff) / 0xff;
			fogColorData[2] = (value & 0xff) / 0xff;
		}

		/**
		 * Creates a new FogMethod object.
		 * @param minDistance The distance from which the fog starts appearing.
		 * @param maxDistance The distance at which the fog is densest.
		 * @param fogColor The colour of the fog.
		 */
		public function FogMethod(minDistance:Number, maxDistance:Number, fogColor:uint = 0x808080)
		{
			super();
			this.minDistance = minDistance;
			this.maxDistance = maxDistance;
			this.fogColor = fogColor;
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.fogColor_fc_vector, updateFogColorBuffer);
			mapContext3DBuffer(_.fogCommonData_fc_vector, updateFogCommonDataBuffer);
		}

		/**
		 * 更新雾颜色常量数据
		 */
		private function updateFogColorBuffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(fogColorData);
		}

		/**
		 * 更新雾通用常量数据
		 */
		private function updateFogCommonDataBuffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(fogCommonData);
		}

		/**
		 * @inheritDoc
		 */
		arcane override function activate(shaderParams:ShaderParams):void
		{
			fogCommonData[0] = _minDistance;
			fogCommonData[1] = 1 / (_maxDistance - _minDistance);

			shaderParams.useFog++;
			shaderParams.needsProjection++;
		}

	}
}
