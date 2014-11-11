package me.feng3d.materials.methods
{
	import me.feng.events.FEventDispatcher;
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 渲染函数设置
	 * @author warden_feng 2014-7-1
	 */
	public class ShaderMethodSetup extends FEventDispatcher
	{
		arcane var _normalMethod:BasicNormalMethod;
		arcane var _ambientMethod:BasicAmbientMethod;
		arcane var _diffuseMethod:BasicDiffuseMethod;
		arcane var _specularMethod:BasicSpecularMethod;

		protected var pass:MaterialPassBase;

		public function ShaderMethodSetup(pass:MaterialPassBase)
		{
			this.pass = pass;

			normalMethod = new BasicNormalMethod(pass);
			ambientMethod = new BasicAmbientMethod(pass);
			diffuseMethod = new BasicDiffuseMethod(pass);
			specularMethod = new BasicSpecularMethod(pass);
		}

		/**
		 * 漫反射函数
		 */
		public function get diffuseMethod():BasicDiffuseMethod
		{
			return _diffuseMethod;
		}

		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			if (_diffuseMethod)
			{
				_diffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				if (value)
					value.copyFrom(_diffuseMethod);
			}

			_diffuseMethod = value;

			if (_diffuseMethod)
			{
				_diffuseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			}

			invalidateShaderProgram();
		}

		/**
		 * 镜面反射函数
		 */
		public function get specularMethod():BasicSpecularMethod
		{
			return _specularMethod;
		}

		public function set specularMethod(value:BasicSpecularMethod):void
		{
			if (_specularMethod)
			{
				_specularMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				if (value)
					value.copyFrom(_specularMethod);
			}

			_specularMethod = value;

			if (_specularMethod)
			{
				_specularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			}

			invalidateShaderProgram();
		}

		/**
		 * 法线函数
		 */
		public function get normalMethod():BasicNormalMethod
		{
			return _normalMethod;
		}

		public function set normalMethod(value:BasicNormalMethod):void
		{
			if (_normalMethod)
			{
				_normalMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				if (value)
					value.copyFrom(_normalMethod);
			}

			_normalMethod = value;

			if (_normalMethod)
			{
				_normalMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			}

			invalidateShaderProgram();
		}

		/**
		 * 通知渲染程序失效
		 */
		private function invalidateShaderProgram():void
		{
			dispatchEvent(new ShadingMethodEvent(ShadingMethodEvent.SHADER_INVALIDATED));
		}

		/**
		 * 渲染程序失效事件处理函数
		 */
		private function onShaderInvalidated(event:ShadingMethodEvent):void
		{
			invalidateShaderProgram();
		}

		/**
		 * 漫反射函数
		 */
		public function get ambientMethod():BasicAmbientMethod
		{
			return _ambientMethod;
		}

		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			if (_ambientMethod)
			{
				_ambientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				if (value)
					value.copyFrom(_ambientMethod);
			}

			_ambientMethod = value;

			if (_ambientMethod)
			{
				_ambientMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			}

			invalidateShaderProgram();
		}

		public function collectCache(context3dCache:Context3DCache):void
		{
			normalMethod.collectCache(context3dCache);
			ambientMethod.collectCache(context3dCache);
			diffuseMethod.collectCache(context3dCache);
			specularMethod.collectCache(context3dCache);
		}

		public function releaseCache(context3dCache:Context3DCache):void
		{
			normalMethod.releaseCache(context3dCache);
			ambientMethod.releaseCache(context3dCache);
			diffuseMethod.releaseCache(context3dCache);
			specularMethod.releaseCache(context3dCache);
		}

		public function setRenderState(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			normalMethod.setRenderState(renderable, stage3DProxy, camera);
			ambientMethod.setRenderState(renderable, stage3DProxy, camera);
			diffuseMethod.setRenderState(renderable, stage3DProxy, camera);
			specularMethod.setRenderState(renderable, stage3DProxy, camera);
		}

		public function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy):void
		{
			_normalMethod && _normalMethod.activate(shaderParams, stage3DProxy);
			_ambientMethod && _ambientMethod.activate(shaderParams, stage3DProxy);
			_diffuseMethod && _diffuseMethod.activate(shaderParams, stage3DProxy);
			_specularMethod && _specularMethod.activate(shaderParams, stage3DProxy);
		}
	}
}
