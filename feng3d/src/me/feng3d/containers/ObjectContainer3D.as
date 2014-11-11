package me.feng3d.containers
{
	import me.feng3d.arcane;
	import me.feng3d.core.base.InteractiveObject3D;
	import me.feng3d.core.base.Object3D;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;

	use namespace arcane;

	/**
	 * 3d对象容器
	 * @author warden_feng 2014-3-21
	 */
	public class ObjectContainer3D extends InteractiveObject3D implements IAsset
	{
		/** 容器内对象列表 */
		protected var _children:Vector.<Object3D> = new Vector.<Object3D>();

		private var _mouseChildren:Boolean = true;

		/** 是否给根容器 */
		public var _isRoot:Boolean = false;

		public function ObjectContainer3D()
		{
			super();
		}

		/**
		 * 添加子对象
		 * @param child
		 * @return
		 */
		public function addChild(child:Object3D):Object3D
		{
			_children.push(child);
			child.parent = this;
			child.setScene3D(scene3D);
			return child;
		}

		/**
		 * 移出指定位置的子对象
		 * @param childIndex
		 * @return
		 */
		public function removeChildAt(childIndex:int):Object3D
		{
			var child:Object3D = getChildAt(childIndex);
			removeChildInternal(childIndex, child);
			return child;
		}

		/**
		 * 移除子对象
		 * @param child
		 */
		public function removeChild(child:Object3D):void
		{
			var childIndex:int = _children.indexOf(child);
			if (childIndex != -1)
			{
				removeChildInternal(childIndex, child);
			}
		}

		private function removeChildInternal(childIndex:uint, child:Object3D):void
		{
			// index is important because getChildAt needs to be regular.
			_children.splice(childIndex, 1);

			// this needs to be nullified before the callbacks!
			child.parent = null;
			child.setScene3D(null);
		}

		override arcane function setScene3D(scene:Scene3D):void
		{
			super.setScene3D(scene);

			var len:uint = _children.length;
			for (var i:int = 0; i < len; i++)
			{
				_children[i].setScene3D(scene);
			}
		}

		override public function invalidateTransform():void
		{
			var len:uint = _children.length;
			for (var i:int = 0; i < len; i++)
			{
				_children[i].invalidateTransform();
			}
			super.invalidateTransform();
		}

		/**
		 * 子对象个数
		 */
		public function get numChildren():uint
		{
			return _children.length;
		}

		/**
		 * 获取子对象
		 * @param index
		 * @return
		 */
		public function getChildAt(index:uint):Object3D
		{
			return _children[index];
		}

		/**
		 * 是否包含该对象
		 * @param child
		 * @return
		 */
		public function contains(child:Object3D):Boolean
		{
			return _children.indexOf(child) >= 0;
		}

		/**
		 * 确定对象的子级是否支持鼠标或用户输入设备。
		 */
		public function get mouseChildren():Boolean
		{
			return _mouseChildren;
		}

		public function set mouseChildren(value:Boolean):void
		{
			_mouseChildren = value;
		}

		/**
		 * 祖先是否允许鼠标事件
		 */
		public function get ancestorsAllowMouseEnabled():Boolean
		{
			return mouseChildren && (parent ? parent.ancestorsAllowMouseEnabled : true);
		}

		override protected function notifySceneTransformChange():void
		{
			super.notifySceneTransformChange();

			var i:uint;
			var len:uint = _children.length;

			//act recursively on child objects
			while (i < len)
				_children[i++].notifySceneTransformChange();
		}

		public function get assetType():String
		{
			return AssetType.CONTAINER;
		}
	}
}
