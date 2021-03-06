package model3d
{
	import me.feng3d.containers.Container3D;
	import me.feng3d.entities.Mesh;
	import me.feng3d.primitives.PlaneGeometry;
	import me.feng3d.utils.MaterialUtils;

	/**
	 * 相片盒子
	 * @author feng 2014-4-14
	 */
	public class PhotoBox extends Container3D
	{
		public static const PHOTO:String = "assets/photo.jpg";
		public static const PHOTO1:String = "assets/photo1.jpg";
		public static const PHOTO2:String = "assets/photo2.jpg";
		public static const PHOTO3:String = "assets/photo3.jpg";

		public static var imgList:Array = [PHOTO, PHOTO1, PHOTO2, PHOTO3];

		public function PhotoBox(rootPath:String, width:Number = 100, num:int = 4)
		{
			var geometry:PlaneGeometry = new PlaneGeometry(width, width, 1, 1, false);

			for (var i:int = 0; i < num; i++)
			{
				var mesh:Mesh = new Mesh();

				mesh.material = MaterialUtils.createTextureMaterial(rootPath + imgList[i % imgList.length]);
				mesh.material.bothSides = true;
				mesh.geometry = geometry;
				mesh.transform3D.rotationY += 360 / num * i;
				mesh.transform3D.x = Math.sin(2 * Math.PI / num * i) * width / 2;
				mesh.transform3D.z = Math.cos(2 * Math.PI / num * i) * width / 2;
				addChild(mesh);
			}
		}
	}
}
