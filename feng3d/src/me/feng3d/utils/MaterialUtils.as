package me.feng3d.utils
{
	import flash.display.Bitmap;

	import me.feng.core.GlobalDispatcher;
	import me.feng.events.load.LoadModuleEvent;
	import me.feng.events.load.LoadModuleEventData;
	import me.feng.load.Load;
	import me.feng.load.LoadUrlEvent;
	import me.feng3d.materials.TextureMaterial;

	/**
	 * 纹理材质工厂
	 * @author feng 2014-7-7
	 */
	public class MaterialUtils
	{
		private static var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		/**
		 * 创建纹理材质
		 * @param url		贴图路径
		 * @return			纹理材质
		 */
		public static function createTextureMaterial(url:String):TextureMaterial
		{
			Load.init();

			var textureMaterial:TextureMaterial = new TextureMaterial(DefaultMaterialManager.getDefaultTexture());

			var loadObj:LoadModuleEventData = new LoadModuleEventData();
			loadObj.urls = [url];
			loadObj.addEventListener(LoadUrlEvent.LOAD_SINGLE_COMPLETE, onLoadSingleComplete);

			loadObj.data = {textureMaterial: textureMaterial}
			dispatcher.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_RESOURCE, loadObj));

			return textureMaterial;
		}

		protected static function onLoadSingleComplete(event:LoadUrlEvent):void
		{
			var loadData:LoadModuleEventData = event.target as LoadModuleEventData;
			var textureMaterial:TextureMaterial = loadData.data.textureMaterial;
			var bitmap:Bitmap = event.loadTaskItem.loadingItem.content;
			textureMaterial.texture = Cast.bitmapTexture(bitmap);
		}
	}
}


