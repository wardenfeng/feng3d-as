package me.feng3d.materials.lightpickers
{
	import flash.events.Event;

	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.LightBase;
	import me.feng3d.lights.PointLight;

	/**
	 * 灯光采集器
	 * @author warden_feng 2014-9-11
	 */
	public class StaticLightPicker extends LightPickerBase
	{
		private var _lights:Array;

		public function StaticLightPicker(lights:Array)
		{
			this.lights = lights;
		}

		/**
		 * 需要渲染的灯光
		 */
		public function get lights():Array
		{
			return _lights;
		}

		public function set lights(value:Array):void
		{
			var numPointLights:uint = 0;
			var numDirectionalLights:uint = 0;
			var light:LightBase;

			_lights = value;

			_directionalLights = new Vector.<DirectionalLight>();
			_pointLights = new Vector.<PointLight>();

			//灯光分类
			var len:uint = value.length;
			for (var i:uint = 0; i < len; ++i)
			{
				light = value[i];
				if (light is PointLight)
				{
					_pointLights[numPointLights++] = PointLight(light);
				}
				else if (light is DirectionalLight)
				{
					_directionalLights[numDirectionalLights++] = DirectionalLight(light);
				}
			}

			_numDirectionalLights = numDirectionalLights;
			_numPointLights = numPointLights;

			dispatchEvent(new Event(Event.CHANGE));
		}

	}
}
