package me.feng3d.containers
{
	import flash.utils.Dictionary;

	import me.feng3d.arcane;
	import me.feng3d.core.base.Object3D;
	import me.feng3d.entities.Entity;

	use namespace arcane;

	/**
	 * 3d场景
	 * @author warden_feng 2014-3-17
	 */
	public class Scene3D extends ObjectContainer3D
	{
		/** 实体字典 */
		private var _entityDic:Dictionary;

		private var _displayEntityDic:Dictionary;

		private var _mouseCollisionEntitys:Vector.<Entity>;

		public function Scene3D()
		{
			_isRoot = true;
			_scene3D = this;

			_entityDic = new Dictionary();
			_displayEntityDic = new Dictionary();
			_mouseCollisionEntitys = new Vector.<Entity>();
		}

		/** 显示实体字典 */
		public function get displayEntityDic():Dictionary
		{
			return _displayEntityDic;
		}

		arcane function addedObject3d(object3D:Object3D):void
		{
			if (object3D is Entity)
			{
				_entityDic[object3D.name] = object3D;
				if (object3D.visible)
				{
					_displayEntityDic[object3D.name] = object3D;
				}
			}
		}

		arcane function removedObject3d(object3D:Object3D):void
		{
			delete _entityDic[object3D.name];
			delete _displayEntityDic[object3D.name];
		}
		
		/**
		 * 收集需要检测鼠标碰撞的实体
		 */
		public function collectMouseCollisionEntitys():void
		{
			_mouseCollisionEntitys.length = 0;
			
			//3d对象堆栈
			var mouseCollisionStack:Vector.<Object3D> = new Vector.<Object3D>();
			mouseCollisionStack.push(this);
			
			var object3D:Object3D;
			var entity:Entity;
			var container3D:ObjectContainer3D;
			//遍历堆栈中需要检测鼠标碰撞的实体
			while (mouseCollisionStack.length > 0)
			{
				object3D = mouseCollisionStack.pop();
				if (!object3D.visible)
					continue;
				entity = object3D as Entity;
				container3D = object3D as ObjectContainer3D;
				//收集需要检测鼠标碰撞的实体到检测列表
				if (entity && entity.mouseEnabled)
				{
					_mouseCollisionEntitys.push(object3D as Entity);
				}
				//收集容器内子对象到堆栈
				if (container3D && container3D.mouseChildren)
				{
					var len:uint = container3D.numChildren;
					for (var i:int = 0; i < len; i++)
					{
						mouseCollisionStack.push(container3D.getChildAt(i));
					}
				}
			}
		}
		
		/**
		 * 需要检测鼠标碰撞的实体
		 */
		public function get mouseCollisionEntitys():Vector.<Entity>
		{
			return _mouseCollisionEntitys;
		}
	}
}
