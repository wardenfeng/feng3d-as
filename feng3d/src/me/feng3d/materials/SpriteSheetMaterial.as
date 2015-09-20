package me.feng3d.materials
{
	import me.feng3d.arcane;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * SpriteSheet材质
	 * @author warden_feng 2014-4-15
	 */
	public class SpriteSheetMaterial extends TextureMaterial
	{
		private var _diffuses:Vector.<Texture2DBase>;
		private var _normals:Vector.<Texture2DBase>;
		private var _speculars:Vector.<Texture2DBase>;

		private var _TBDiffuse:Texture2DBase;
		private var _TBNormal:Texture2DBase;
		private var _TBSpecular:Texture2DBase;

		private var _currentMapID:uint;

		/**
		 * 创建SpriteSheetMaterial实例
		 *
		 * @param diffuses			漫反射纹理列表
		 * @param normals			法线纹理列表
		 * @param speculars			高光纹理列表
		 * @param smooth			是否平滑
		 * @param repeat			是否重复
		 * @param mipmap			是否使用mipmap
		 */
		public function SpriteSheetMaterial(diffuses:Vector.<Texture2DBase>, normals:Vector.<Texture2DBase> = null, speculars:Vector.<Texture2DBase> = null, smooth:Boolean = true, repeat:Boolean = false, mipmap:Boolean = true)
		{

			_diffuses = diffuses;
			_normals = normals;
			_speculars = speculars;

			initTextures();

			super(_TBDiffuse, smooth, repeat, mipmap);

			if (_TBNormal)
				this.normalMap = _TBNormal;

			if (_TBSpecular)
				this.specularMap = _TBSpecular;

		}

		private function initTextures():void
		{
			if (!_diffuses || _diffuses.length == 0)
				throw new Error("you must pass at least one bitmapdata into diffuses param!");

			_TBDiffuse = _diffuses[0];

			if (_normals && _normals.length > 0)
			{
				if (_normals.length != _diffuses.length)
					throw new Error("The amount of normals bitmapDatas must be same as the amount of diffuses param!");

				_TBNormal = _normals[0];
			}

			if (_speculars && _speculars.length > 0)
			{
				if (_speculars.length != _diffuses.length)
					throw new Error("The amount of normals bitmapDatas must be same as the amount of diffuses param!");

				_TBSpecular = _speculars[0];
			}

			_currentMapID = 0;

		}

		/**
		 * 切换
		 * @param mapID			映射编号
		 * @return				是否切换成功
		 */
		arcane function swap(mapID:uint = 0):Boolean
		{

			if (_currentMapID != mapID)
			{

				_currentMapID = mapID;

				_TBDiffuse = _diffuses[mapID];
				this.texture = _TBDiffuse;

				if (_TBNormal)
					this.normalMap = _TBNormal = _normals[mapID];

				if (_TBSpecular)
					this.specularMap = _TBSpecular = _speculars[mapID];

				return true;

			}

			return false;

		}

	}
}
