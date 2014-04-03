package feng3d.containers
{
	import feng3d.core.Object3D;

	/**
	 *
	 * @author warden_feng 2014-3-21
	 */
	public class ObjectContainer3D extends Object3D
	{
		/** 容器内对象列表 */
		private var _children:Vector.<Object3D> = new Vector.<Object3D>();

		/** 是否给根容器 */
		public var _isRoot:Boolean = false;

		public function ObjectContainer3D()
		{
			super();
		}

		public function addChild(child:Object3D):Object3D
		{
			child.parent = this;
			_children.push(child);
			return child;
		}

		override public function collectDisplayObject(_entityCollector:Vector.<Object3D>):void
		{
			// TODO Auto Generated method stub
			super.collectDisplayObject(_entityCollector);

			var len:uint = _children.length;
			var object3D:Object3D;
			for (var i:int = 0; i < len; i++)
			{
				object3D = _children[i];

				//根据该容器场景转换矩阵更新子类场景转换矩阵
				object3D.sceneTransform.copyFrom(sceneTransform);
				object3D.sceneTransform.prepend(object3D.transform);

				object3D.collectDisplayObject(_entityCollector);
			}


			while (i < len)
				_children[i++].collectDisplayObject(_entityCollector);
		}
	}
}
