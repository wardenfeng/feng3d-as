package me.feng3d.animators.base
{
	import flash.utils.Dictionary;

	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.animators.base.node.AnimationNodeBase;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.errors.AnimationSetError;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 动画集合基类
	 * @author warden_feng 2014-5-20
	 */
	public class AnimationSetBase extends Context3DBufferOwner implements IAsset
	{
		private var _usesCPU:Boolean;
		/** 动画节点列表 */
		private var _animations:Vector.<AnimationNodeBase> = new Vector.<AnimationNodeBase>();
		/** 动画名称列表 */
		private var _animationNames:Vector.<String> = new Vector.<String>();
		/** 动画字典 */
		private var _animationDictionary:Dictionary = new Dictionary(true);

		/**
		 * 创建一个动画集合基类
		 */
		public function AnimationSetBase()
		{
			super();
			AbstractClassError.check(this);
		}

		/**
		 * 是否使用CPU
		 */
		public function get usesCPU():Boolean
		{
			return _usesCPU;
		}

		/**
		 * 添加动画
		 * @param node 动画节点
		 */
		public function addAnimation(node:AnimationNodeBase):void
		{
			if (_animationDictionary[node.name])
				throw new AnimationSetError("root node animationName '" + node.name + "' already exists in the set");

			_animationDictionary[node.name] = node;

			_animations.push(node);

			_animationNames.push(node.name);
		}

		/**
		 * 获取动画节点
		 * @param name 动画名称
		 * @return 动画节点
		 */
		public function getAnimation(animationName:String):AnimationNodeBase
		{
			return _animationDictionary[animationName];
		}

		/**
		 * 是否有某动画
		 * @param name 动画名称
		 */
		public function hasAnimation(animationName:String):Boolean
		{
			return _animationDictionary[animationName] != null;
		}

		/**
		 * 重置使用GPU
		 */
		public function resetGPUCompatibility():void
		{
			_usesCPU = false;
		}

		/**
		 * 取消使用GPU
		 */
		public function cancelGPUCompatibility():void
		{
			_usesCPU = true;
		}

		/**
		 * 激活
		 * @param shaderParams	渲染参数
		 * @param stage3DProxy	3d舞台代理
		 * @param pass			渲染通道
		 * @throws	me.feng.error.AbstractMethodError
		 */
		public function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * @inheritDoc
		 */
		public function get assetType():String
		{
			return AssetType.ANIMATION_SET;
		}
	}
}
