package me.feng3d.materials.methods
{
	import me.feng.core.NamedAsset;
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalIdCenter;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 渲染函数基类
	 * @author feng 2014-7-1
	 */
	public class ShadingMethodBase extends NamedAsset
	{
		public var context3DBufferOwner:Context3DBufferOwner;

		protected var _passes:Vector.<MaterialPassBase>;

		/**
		 * 渲染函数类型
		 * <p>当typeUnique为true时，用于唯一性判断</p>
		 * @see #typeUnique
		 */
		arcane var methodType:String;

		/**
		 * 是否唯一
		 * <p>值为true时一个pass只能包含一个该类型函数，否则允许多个</p>
		 * @see #methodType
		 */
		arcane var typeUnique:Boolean = false;

		/**
		 * 创建渲染寄函数基类
		 */
		public function ShadingMethodBase()
		{
			super();

			context3DBufferOwner = new Context3DBufferOwner();
			initBuffers();
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
		 * 激活渲染函数
		 * @param shaderParams 		渲染参数
		 */
		arcane function activate(shaderParams:ShaderParams):void
		{

		}

		/**
		 * 设置渲染状态
		 * @param renderable 		渲染对象
		 * @param camera 			摄像机
		 */
		arcane function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{

		}

		/**
		 * 初始化常量数据
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
		 * @param method		被拷贝的方法
		 */
		public function copyFrom(method:ShadingMethodBase):void
		{
		}

		/**
		 * Any passes required that render to a texture used by this method.
		 */
		public function get passes():Vector.<MaterialPassBase>
		{
			return _passes;
		}

		/**
		 * Cleans up any resources used by the current object.
		 */
		public function dispose():void
		{

		}
	}
}
