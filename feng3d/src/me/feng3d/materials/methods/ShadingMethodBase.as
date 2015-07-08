package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcane;

	/**
	 * 渲染寄存器基类
	 * @author warden_feng 2014-7-1
	 */
	public class ShadingMethodBase extends Context3DBufferOwner
	{

		public function ShadingMethodBase()
		{
			super();
		}

		/**
		 * 激活渲染函数
		 * @param shaderParams 渲染参数
		 * @param stage3DProxy
		 */
		arcane function activate(shaderParams:ShaderParams):void
		{

		}

		/**
		 * 设置渲染状态
		 * @param renderable 渲染对象
		 * @param camera 摄像机
		 */
		arcane function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{

		}

		/**
		 * Initializes unchanging shader constants using the data from a MethodVO.
		 * @param vo The MethodVO object linking this method with the pass currently being compiled.
		 */
		arcane function initConstants():void
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
