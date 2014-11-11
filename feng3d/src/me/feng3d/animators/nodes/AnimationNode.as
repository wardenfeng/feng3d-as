package me.feng3d.animators.nodes
{
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAssetBase;
	
	
	/**
	 * 动画节点基类
	 * @author warden_feng 2014-5-20
	 */
	public class AnimationNode extends NamedAssetBase implements IAsset
	{
		protected var _stateClass:Class;
		
		private var _animationName:String;
		
		/**
		 * 动画节点名称
		 */
		public function get animationName():String
		{
			return _animationName;
		}

		public function set animationName(value:String):void
		{
			_animationName = value;
		}

		public function get stateClass():Class
		{
			return _stateClass;
		}
		
		
		public function AnimationNode()
		{
			super();
		}
		
		public function get assetType():String
		{
			return AssetType.ANIMATION_NODE;
		}
	}
}