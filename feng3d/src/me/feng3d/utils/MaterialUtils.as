package me.feng3d.utils
{
	import flash.display.Bitmap;

	import me.feng.core.GlobalDispatcher;
	import me.feng.load.Load;
	import me.feng.load.LoadEvent;
	import me.feng.load.LoadEventData;
	import me.feng.load.data.LoadTaskItem;
	import me.feng3d.materials.TextureMaterial;

	/**
	 * 纹理材质工厂
	 * @author warden_feng 2014-7-7
	 */
	public class MaterialUtils
	{
		//资源根路径
		public static var rootPath:String = "http://images.feng3d.me/feng3dDemo/assets/";

		private static var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		/**
		 * 创建纹理材质
		 * @param url		贴图路径
		 * @return			纹理材质
		 */
		public static function createTextureMaterial(url:String):TextureMaterial
		{
			Load.init();

			var textureMaterial:TextureMaterial = new TextureMaterial();

			var loadObj:LoadEventData = new LoadEventData();
			loadObj.urls = [rootPath + url];
			loadObj.singleComplete = singleGeometryComplete;
			loadObj.data = {textureMaterial: textureMaterial}
			dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, loadObj));

			return textureMaterial;
		}

		/** 单个图片加载完毕 */
		private static function singleGeometryComplete(loadData:LoadEventData, loadItemData:LoadTaskItem):void
		{
			var textureMaterial:TextureMaterial = loadData.data.textureMaterial;
			var bitmap:Bitmap = loadItemData.loadingItem.content;
			textureMaterial.texture = Cast.bitmapTexture(bitmap);
		}
	}
}
