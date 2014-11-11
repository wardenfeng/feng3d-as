package me.feng3d.core.render
{


	import flash.display3D.Context3D;
	import flash.utils.Dictionary;
	
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.entities.Entity;
	import me.feng3d.entities.Mesh;

	/**
	 * 渲染者
	 * @author warden_feng 2014-3-27
	 */
	public class Renderer
	{
		public var stage3DProxy:Stage3DProxy;

		public var camera:Camera3D;

		protected var _backgroundR:Number = 0;
		protected var _backgroundG:Number = 0;
		protected var _backgroundB:Number = 0;
		protected var _backgroundAlpha:Number = 1;

		public function Renderer()
		{
		}

		/**
		 * 渲染
		 */
		public function render(displayEntitys:Vector.<Entity>):void
		{
			var context3D:Context3D = stage3DProxy.context3D;
			context3D.clear(_backgroundR, _backgroundG, _backgroundB, _backgroundAlpha, 1, 0);

			for (var i:int = 0; i < displayEntitys.length; i++) 
			{
				var entity:Entity = displayEntitys[i];
				
				if (entity is Mesh || entity is IRenderable)
				{
					entity.render(stage3DProxy, camera);
				}
			}
		}
		
		public function render1(displayEntityDic:Dictionary):void
		{
			var context3D:Context3D = stage3DProxy.context3D;
			context3D.clear(_backgroundR, _backgroundG, _backgroundB, _backgroundAlpha, 1, 0);
			
			for each (var entity:Entity in displayEntityDic) 
			{
				if (entity is Mesh || entity is IRenderable)
				{
					entity.render(stage3DProxy, camera);
				}
			}
		}

		/**
		 * 背景颜色红色部分
		 */
		arcane function get backgroundR():Number
		{
			return _backgroundR;
		}

		arcane function set backgroundR(value:Number):void
		{
			_backgroundR = value;
		}

		/**
		 * 背景颜色绿色部分
		 */
		arcane function get backgroundG():Number
		{
			return _backgroundG;
		}

		arcane function set backgroundG(value:Number):void
		{
			_backgroundG = value;
		}

		/**
		 * 背景颜色蓝色部分
		 */
		arcane function get backgroundB():Number
		{
			return _backgroundB;
		}

		arcane function set backgroundB(value:Number):void
		{
			_backgroundB = value;
		}
		
	}
}
