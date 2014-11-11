package me.feng3d.core.base
{
	import flash.geom.Matrix3D;
	
	import me.feng3d.core.proxy.Context3DCache;

	/**
	 * 普通子几何体接口
	 * @author warden_feng
	 */
	public interface ISubGeometry
	{
		/**
		 * 顶点个数
		 */
		function get numVertices():uint;

		/**
		 * 三角形个数
		 */
		function get numTriangles():uint;

		/**
		 * 单个顶点位置数据长度
		 */
		function get vertexStride():uint;

		/**
		 * 单个uv数据长度
		 */
		function get UVStride():uint;

		/**
		 * 顶点数据数组
		 */
		function get vertexData():Vector.<Number>;

		/**
		 * 顶点数据偏移量
		 */
		function get vertexOffset():int;

		/**
		 * uv数据偏移量
		 */
		function get UVOffset():int;

		/**
		 * 索引数据数组
		 */
		function get indexData():Vector.<uint>;

		/**
		 * uv数据数组
		 */
		function get UVData():Vector.<Number>;

		/**
		 * 使用变换矩阵
		 * @param transform 变换矩阵
		 */
		function applyTransformation(transform:Matrix3D):void;

		/**
		 * 缩放
		 */
		function scale(scale:Number):void;

		/**
		 * 销毁
		 */
		function dispose():void;

		/**
		 * U缩放值
		 */
		function get scaleU():Number;

		/**
		 * V缩放值
		 */
		function get scaleV():Number;

		/**
		 * uv缩放
		 * @param scaleU U缩放值
		 * @param scaleV V缩放值
		 */
		function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void;

		/**
		 * 父几何体
		 */
		function get parentGeometry():Geometry;

		function set parentGeometry(value:Geometry):void;

		/**
		 * 顶点位置数据数组
		 */
		function get vertexPositionData():Vector.<Number>;

		/**
		 * 收集context3d渲染缓冲
		 */		
		function collectCache(context3dCache:Context3DCache):void;
		
		/**
		 * 释放context3d渲染缓冲
		 */		
		function releaseCache(context3dCache:Context3DCache):void
		
		/**
		 * 从数据数组初始化
		 * @param vertices 顶点数据
		 * @param uvs uv数据
		 * @param normals 法线数据
		 * @param tangents 切线数据
		 */
		function fromVectors(vertices:Vector.<Number>, uvs:Vector.<Number>):void;

		/**
		 * 复制
		 */
		function clone():ISubGeometry;
	}
}
