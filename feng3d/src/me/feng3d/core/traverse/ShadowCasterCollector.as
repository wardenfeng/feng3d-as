package me.feng3d.core.traverse
{
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.data.RenderableListItem;
	import me.feng3d.entities.Entity;
	import me.feng3d.materials.MaterialBase;

	use namespace arcane;

	/**
	 * 阴影投射者集合
	 * @author warden_feng 2015-5-29
	 */
	public class ShadowCasterCollector extends EntityCollector
	{
		/**
		 * 创建阴影投射者集合
		 */
		public function ShadowCasterCollector()
		{
			super();
		}

		/**
		 * 应用可渲染对象
		 * @param renderable		可渲染对象
		 */
		override public function applyRenderable(renderable:IRenderable):void
		{
			var material:MaterialBase = renderable.material;
			var entity:Entity = renderable.sourceEntity;
			//收集可投射阴影的可渲染对象
			if (renderable.castsShadows && material)
			{
				var item:RenderableListItem = _renderableListItemPool.getItem();
				item.renderable = renderable;
				item.next = _opaqueRenderableHead;
				var entityScenePos:Vector3D = entity.scenePosition;
				var dx:Number = _entryPoint.x - entityScenePos.x;
				var dy:Number = _entryPoint.y - entityScenePos.y;
				var dz:Number = _entryPoint.z - entityScenePos.z;
				item.zIndex = dx * _cameraForward.x + dy * _cameraForward.y + dz * _cameraForward.z;
				item.renderSceneTransform = renderable.sourceEntity.sceneTransform;
				_opaqueRenderableHead = item;
			}
		}
	}
}
