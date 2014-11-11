package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.library.assets.NamedAssetBase;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 渲染寄存器基类
	 * @author warden_feng 2014-7-1
	 */
	public class ShadingMethodBase extends NamedAssetBase
	{
		protected var pass:MaterialPassBase;

		public function ShadingMethodBase(pass:MaterialPassBase)
		{
			super();
			this.pass = pass;

			initBuffers();
		}

		/**
		 * 初始化context3d数据缓冲
		 */
		protected function initBuffers():void
		{

		}

		/**
		 * 收集context3d数据缓冲
		 * @param context3dCache context3d缓存
		 */
		public function collectCache(context3dCache:Context3DCache):void
		{

		}

		/**
		 * 释放context3d数据缓冲
		 * @param context3dCache context3d缓存
		 */
		public function releaseCache(context3dCache:Context3DCache):void
		{

		}

		/**
		 * 激活渲染函数
		 * @param shaderParams 渲染参数
		 * @param stage3DProxy
		 */
		arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy):void
		{

		}

		/**
		 * 设置渲染状态
		 * @param vo 函数数据
		 * @param renderable 渲染对象
		 * @param stage3DProxy stage3d代理
		 * @param camera 照相机
		 */
		arcane function setRenderState(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{

		}

		/**
		 * 清除编译数据
		 */
		arcane function cleanCompilationData():void
		{
		}

		/**
		 * 使渲染程序失效
		 */
		protected function invalidateShaderProgram():void
		{
			dispatchEvent(new ShadingMethodEvent(ShadingMethodEvent.SHADER_INVALIDATED));
		}

		/**
		 * 拷贝渲染方法
		 * @param method 被拷贝的方法
		 */
		public function copyFrom(method:ShadingMethodBase):void
		{
		}
	}
}
