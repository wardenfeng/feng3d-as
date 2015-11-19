package me.feng3d.core.manager
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.core.pick.PickingCollisionVO;
	import me.feng3d.core.pick.RaycastPicker;
	import me.feng3d.entities.Entity;
	import me.feng3d.events.MouseEvent3D;
	import me.feng3d.mathlib.Ray3D;

	/**
	 * 鼠标事件管理
	 * @author feng 2014-4-29
	 */
	public class Mouse3DManager
	{
		/** 射线采集器(采集射线穿过场景中物体的列表) */
		private var _mousePicker:RaycastPicker = new RaycastPicker(false);

		/** 收集的鼠标事件列表 */
		private var mouseEventList:Vector.<String> = new Vector.<String>();

		/** 是否开启鼠标事件检测 */
		private var mouseEventOpen:Boolean = false;

		/** 当前相交数据 */
		private var _collidingObject:PickingCollisionVO;
		/** 上次相交数据 */
		private var _previousCollidingObject:PickingCollisionVO;

		/** 普通鼠标事件与3d鼠标事件对应关系 */
		private static var eventMap:Dictionary;

		public function Mouse3DManager()
		{
			if (eventMap == null)
			{
				eventMap = new Dictionary();
				eventMap[MouseEvent.CLICK] = MouseEvent3D.CLICK;
				eventMap[MouseEvent.DOUBLE_CLICK] = MouseEvent3D.DOUBLE_CLICK;
				eventMap[MouseEvent.MOUSE_DOWN] = MouseEvent3D.MOUSE_DOWN;
				eventMap[MouseEvent.MOUSE_MOVE] = MouseEvent3D.MOUSE_MOVE;
				eventMap[MouseEvent.MOUSE_OUT] = MouseEvent3D.MOUSE_OUT;
				eventMap[MouseEvent.MOUSE_OVER] = MouseEvent3D.MOUSE_OVER;
				eventMap[MouseEvent.MOUSE_UP] = MouseEvent3D.MOUSE_UP;
				eventMap[MouseEvent.MOUSE_WHEEL] = MouseEvent3D.MOUSE_WHEEL;
			}
		}

		/**
		 * 开启鼠标事件
		 */
		public function enableMouseListeners(view:View3D):void
		{
			view.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			view.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private function onMouseOver(event:MouseEvent):void
		{
			var view:Sprite = event.currentTarget as Sprite;
			for (var eventType:String in eventMap)
			{
				view.addEventListener(eventType, onMouseEvent);
			}
			mouseEventList.length = 0;
			mouseEventOpen = true;
		}

		private function onMouseOut(event:MouseEvent):void
		{
			var view:Sprite = event.currentTarget as Sprite;
			for (var eventType:String in eventMap)
			{
				view.removeEventListener(eventType, onMouseEvent);
			}
			mouseEventOpen = false;
		}

		/**
		 * 收集玩家触发的鼠标事件
		 */
		private function onMouseEvent(event:MouseEvent):void
		{
			mouseEventList.push(event.type);
		}

		/**
		 * 处理玩家触发的鼠标事件
		 */
		public function fireMouseEvents(mouseRay3D:Ray3D, mouseCollisionEntitys:Vector.<Entity>):void
		{
			//玩家未触发鼠标事件时，直接返回
			if (!mouseEventOpen)
			{
				return;
			}

			var mouseEvent3DList:Vector.<MouseEvent3D> = new Vector.<MouseEvent3D>();

			//计算得到鼠标射线相交的物体
			_collidingObject = _mousePicker.getViewCollision(mouseRay3D, mouseCollisionEntitys);

			//处理3d对象的Over与Out事件
			var mouseEventType:String;
			var mouseEvent3D:MouseEvent3D;
			if (_collidingObject != _previousCollidingObject)
			{
				if (_previousCollidingObject)
				{
					mouseEvent3D = createMouseEvent3D(MouseEvent.MOUSE_OUT, _previousCollidingObject);
					mouseEvent3DList.push(mouseEvent3D);
				}
				if (_collidingObject)
				{
					mouseEvent3D = createMouseEvent3D(MouseEvent.MOUSE_OVER, _collidingObject);
					mouseEvent3DList.push(mouseEvent3D);
				}
			}

			//遍历收集的鼠标事件
			while (_collidingObject && mouseEventList.length > 0)
			{
				mouseEventType = mouseEventList.pop();
				//处理鼠标事件
				mouseEvent3D = createMouseEvent3D(mouseEventType, _collidingObject);
				mouseEvent3DList.push(mouseEvent3D);
			}

			dispatchAllEvent(mouseEvent3DList);

			mouseEventList.length = 0;
			mouseEvent3DList.length = 0;
			_previousCollidingObject = _collidingObject;
		}

		/**
		 * 抛出所有3D鼠标事件
		 * @param mouseEvent3DList
		 */
		private function dispatchAllEvent(mouseEvent3DList:Vector.<MouseEvent3D>):void
		{
			var mouseEvent3D:MouseEvent3D;
			var dispatcher:ObjectContainer3D;
			while (mouseEvent3DList.length > 0)
			{
				mouseEvent3D = mouseEvent3DList.pop();
				if (mouseEvent3D && mouseEvent3D.object)
				{
					dispatcher = mouseEvent3D.object;
					if (dispatcher)
					{
						dispatcher.dispatchEvent(mouseEvent3D);
					}
				}
			}
		}

		/**
		 * 创建3D鼠标事件
		 * @param sourceEvent 2d鼠标事件
		 * @param collider 碰撞信息
		 * @return 3D鼠标事件
		 */
		private function createMouseEvent3D(sourceEventType:String, collider:PickingCollisionVO = null):MouseEvent3D
		{
			var mouseEvent3DType:String = eventMap[sourceEventType];
			if (mouseEvent3DType == null)
				return null;

			var mouseEvent3D:MouseEvent3D = new MouseEvent3D(mouseEvent3DType);
			mouseEvent3D.object = collider.firstEntity;
			mouseEvent3D.collider = collider;
			return mouseEvent3D;
		}
	}
}
