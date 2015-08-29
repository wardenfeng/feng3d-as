package me.feng3d.animators.base.node
{
	import me.feng3d.arcane;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;

	use namespace arcane;

	/**
	 * 动画节点基类
	 * @author warden_feng 2014-5-20
	 */
	public class AnimationNodeBase extends Context3DBufferOwner implements IAsset
	{
		protected var _stateClass:Class;

		public function get stateClass():Class
		{
			return _stateClass;
		}

		/**
		 * 创建一个动画节点基类
		 */
		public function AnimationNodeBase()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function get assetType():String
		{
			return AssetType.ANIMATION_NODE;
		}
	}
}
