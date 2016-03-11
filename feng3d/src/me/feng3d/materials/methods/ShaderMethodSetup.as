package me.feng3d.materials.methods
{
	import flash.utils.Dictionary;
	
	import me.feng.component.Component;
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalIdCenter;

	use namespace arcane;

	/**
	 * 渲染函数设置
	 * @author feng 2014-7-1
	 */
	public class ShaderMethodSetup extends Component
	{
		public var context3DBufferOwner:Context3DBufferOwner;

		private var uniqueMethodDic:Dictionary;

		arcane var methods:Vector.<ShadingMethodBase>;

		/**
		 * 创建一个渲染函数设置
		 */
		public function ShaderMethodSetup()
		{
			context3DBufferOwner = new Context3DBufferOwner();
			initBuffers();

			uniqueMethodDic = new Dictionary();
			methods = new Vector.<ShadingMethodBase>();

			addMethod(new BasicNormalMethod());
			addMethod(new BasicAmbientMethod());
			addMethod(new BasicDiffuseMethod());
			addMethod(new BasicSpecularMethod());
		}

		/**
		 * 初始化Context3d缓存
		 */
		protected function initBuffers():void
		{

		}

		/**
		 * Fagal编号中心
		 */
		public function get _():FagalIdCenter
		{
			return FagalIdCenter.instance;
		}

		/**
		 * The number of "effect" methods added to the material.
		 */
		public function get numMethods():int
		{
			return methods.length;
		}

		/**
		 * 漫反射函数
		 */
		public function get diffuseMethod():BasicDiffuseMethod
		{
			return uniqueMethodDic[BasicDiffuseMethod.METHOD_TYPE];
		}

		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			addUniqueMethod(value);
		}

		/**
		 * 镜面反射函数
		 */
		public function get specularMethod():BasicSpecularMethod
		{
			return uniqueMethodDic[BasicSpecularMethod.METHOD_TYPE];
		}

		public function set specularMethod(value:BasicSpecularMethod):void
		{
			addUniqueMethod(value);
		}

		/**
		 * 法线函数
		 */
		public function get normalMethod():BasicNormalMethod
		{
			return uniqueMethodDic[BasicNormalMethod.METHOD_TYPE];
		}

		public function set normalMethod(value:BasicNormalMethod):void
		{
			addUniqueMethod(value);
		}

		/**
		 * 漫反射函数
		 */
		public function get ambientMethod():BasicAmbientMethod
		{
			return uniqueMethodDic[BasicAmbientMethod.METHOD_TYPE];
		}

		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			addUniqueMethod(value);
		}

		/**
		 * 阴影映射函数
		 */
		public function get shadowMethod():ShadowMapMethodBase
		{
			return uniqueMethodDic[ShadowMapMethodBase.METHOD_TYPE];
		}

		public function set shadowMethod(value:ShadowMapMethodBase):void
		{
			addUniqueMethod(value);
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
		 * 添加渲染函数
		 * @param method			渲染函数
		 */
		public function addMethod(method:ShadingMethodBase):void
		{
			if (method.typeUnique)
			{
				addUniqueMethod(method);
			}
			else
			{
				$addMethod(method);
			}
		}

		/**
		 * 移除渲染函数
		 * @param method			渲染函数
		 */
		public function removeMethod(method:ShadingMethodBase):void
		{
			if (method.typeUnique)
			{
				removeUniqueMethod(method)
			}
			else
			{
				$removeMethod(method);
			}
		}

		/**
		 * 添加唯一渲染函数
		 * @param method			渲染函数
		 */
		private function addUniqueMethod(method:ShadingMethodBase):void
		{
			var oldMethod:ShadingMethodBase = uniqueMethodDic[method.methodType];
			if (oldMethod != null)
			{
				method.copyFrom(oldMethod);
				$removeMethod(oldMethod);
			}
			$addMethod(method);
			uniqueMethodDic[method.methodType] = method;

			invalidateShaderProgram();
		}

		/**
		 * 移除唯一渲染函数
		 * @param method			渲染函数
		 */
		private function removeUniqueMethod(method:ShadingMethodBase):void
		{
			$removeMethod(method);
			uniqueMethodDic[method.methodType] = null;
		}

		/**
		 * 添加函数
		 * @param method			渲染函数
		 */
		private function $addMethod(method:ShadingMethodBase):void
		{
			method.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			context3DBufferOwner.addChildBufferOwner(method.context3DBufferOwner);
			methods.push(method);
			invalidateShaderProgram();
		}

		/**
		 * 删除函数
		 * @param method			渲染函数
		 */
		private function $removeMethod(method:ShadingMethodBase):void
		{
			method.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			context3DBufferOwner.removeChildBufferOwner(method.context3DBufferOwner);
			var index:int = methods.indexOf(method);
			methods.splice(index, 1);
			invalidateShaderProgram();
		}

		/**
		 * 设置渲染状态
		 * @param renderable		可渲染对象
		 * @param stage3DProxy		3D舞台代理
		 * @param camera			摄像机
		 */
		public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			for (var i:int = 0; i < methods.length; i++)
			{
				methods[i].setRenderState(renderable, camera);
			}
		}

		/**
		 * 激活
		 * @param shaderParams		渲染参数
		 * @param stage3DProxy		3D舞台代理
		 */
		public function activate(shaderParams:ShaderParams):void
		{
			for (var i:int = 0; i < methods.length; i++)
			{
				methods[i].activate(shaderParams);
			}
		}

		/**
		 * 初始化常量数据
		 */
		public function initConstants():void
		{
			for (var i:int = 0; i < methods.length; i++)
			{
				methods[i].initConstants();
			}
		}
	}
}
