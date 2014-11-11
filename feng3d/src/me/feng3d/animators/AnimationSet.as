package me.feng3d.animators
{
	import flash.utils.Dictionary;

	import me.feng3d.arcane;
	import me.feng3d.animators.nodes.AnimationNode;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.errors.AbstractMethodError;
	import me.feng3d.errors.AnimationSetError;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAssetBase;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 动画集合基类
	 * @author warden_feng 2014-5-20
	 */
	public class AnimationSet extends NamedAssetBase implements IAsset
	{
		private var _usesCPU:Boolean;
		/** 动画节点列表 */
		private var _animations:Vector.<AnimationNode> = new Vector.<AnimationNode>();
		/** 动画名称列表 */
		private var _animationNames:Vector.<String> = new Vector.<String>();
		/** 动画字典 */
		private var _animationDictionary:Dictionary = new Dictionary(true);

		/**
		 * 创建一个动画集合基类
		 */
		public function AnimationSet()
		{
			super();
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
		public function addAnimation(node:AnimationNode):void
		{
			if (_animationDictionary[node.animationName])
				throw new AnimationSetError("root node animationName '" + node.animationName + "' already exists in the set");

			_animationDictionary[node.animationName] = node;

			_animations.push(node);

			_animationNames.push(node.animationName);
		}

		/**
		 * 获取动画节点
		 * @param name 动画名称
		 * @return 动画节点
		 */
		public function getAnimation(animationName:String):AnimationNode
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

		public function resetGPUCompatibility():void
		{
			_usesCPU = false;
		}

		public function cancelGPUCompatibility():void
		{
			_usesCPU = true;
		}

		arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy, pass:MaterialPassBase):void
		{
			throw new AbstractMethodError();
		}

		public function get assetType():String
		{
			return AssetType.ANIMATION_SET;
		}
	}
}
