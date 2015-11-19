package me.feng3d.fagal
{

	/**
	 * 纹理类型
	 * @author feng 2014-10-23
	 */
	public class TextureType
	{
		/**  Images in this texture all are 2-dimensional. They have width and height, but no depth. */
		static public const TYPE_2D:String = "2d";

		/**  Images in this texture all are 3-dimensional. They have width, height, and depth. */
		static public const TYPE_3D:String = "3d";

		/**  There are exactly 6 distinct sets of 2D images, all of the same size. They act as 6 faces of a cube. */
		static public const TYPE_CUBE:String = "cube";

	}
}
