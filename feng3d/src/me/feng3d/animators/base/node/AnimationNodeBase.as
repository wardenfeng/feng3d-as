package me.feng3d.animators.base.node
{
	import me.feng.component.Component;
	import me.feng3d.arcane;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.fagalRE.FagalIdCenter;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAsset;

	use namespace arcane;

	/**
	 * 动画节点基类
	 * @author feng 2014-5-20
	 */
	public class AnimationNodeBase extends Component implements IAsset
	{
		private var _namedAsset:NamedAsset;
		public var context3DBufferOwner:Context3DBufferOwner;

		protected var _stateClass:Class;

		/**
		 * 状态类
		 */
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
			_namedAsset = new NamedAsset(this,AssetType.ANIMATION_NODE);
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
		
		public function get namedAsset():NamedAsset
		{
			return _namedAsset;
		}
		
		
	}
}
