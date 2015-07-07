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
	 *
	 * @author warden_feng 2015-5-29
	 */
	public class ShadowCasterCollector extends EntityCollector
	{
		public function ShadowCasterCollector()
		{
			super();
		}

		/**
		 * Adds an IRenderable object to the potentially visible objects.
		 * @param renderable The IRenderable object to add.
		 */
		override public function applyRenderable(renderable:IRenderable):void
		{
			// the test for material is temporary, you SHOULD be hammered with errors if you try to render anything without a material
			var material:MaterialBase = renderable.material;
			var entity:Entity = renderable.sourceEntity;
			if (renderable.castsShadows && material)
			{
				var item:RenderableListItem = _renderableListItemPool.getItem();
				item.renderable = renderable;
				item.next = _opaqueRenderableHead;
				item.cascaded = false;
				var entityScenePos:Vector3D = entity.scenePosition;
				var dx:Number = _entryPoint.x - entityScenePos.x;
				var dy:Number = _entryPoint.y - entityScenePos.y;
				var dz:Number = _entryPoint.z - entityScenePos.z;
				item.zIndex = dx * _cameraForward.x + dy * _cameraForward.y + dz * _cameraForward.z;
				item.renderSceneTransform = renderable.sourceEntity.sceneTransform;
//				item.renderOrderId = material._depthPassId;
				_opaqueRenderableHead = item;
			}
		}
	}
}
