package me.feng3d.core.buffer.context3d.item
{
	import flash.display3D.Context3D;
	import flash.display3D.VertexBuffer3D;

	/**
	 * 顶点缓冲项
	 * @author warden_feng 2014-8-26
	 */
	public class VertexBufferItem
	{
		/** 是否无效 */
		public var invalid:Boolean = true;

		/** 顶点缓冲 */
		private var vertexBuffer3D:VertexBuffer3D;

		/** 3d环境 */
		private var context3D:Context3D;

		/**
		 * 创建顶点缓冲项
		 * @param context3D
		 * @param numVertices			要在缓冲区中存储的顶点数量。单个缓冲区中的最大顶点数为 65535。
		 * @param data32PerVertex		与每个顶点关联的 32 位（4 字节）数据值的数量。每个顶点的 32 位数据元素数量最多为 64 个（或 256 个字节）。请注意，顶点着色器程序在任何给定时间只能访问 8 个属性寄存器。使用 SetVertextBufferAt() 在顶点缓冲区内选择属性。
		 */
		public function VertexBufferItem(context3D:Context3D, numVertices:int, data32PerVertex:int)
		{
			this.context3D = context3D;
			vertexBuffer3D = context3D.createVertexBuffer(numVertices, data32PerVertex);
			invalid = true;
		}

		/**
		 * 从矢量数组上载一组顶点的数据到渲染上下文。
		 * @param data					位值的矢量。单个顶点由许多按顺序存储在矢量中的值组成。顶点中的值数量在创建缓冲区时使用 Context3D createVertexBuffer3D() 方法的 data32PerVertex 参数指定。矢量的长度必须为每个顶点的值数量乘以顶点数量。
		 * @param startVertex			要加载的第一个顶点的索引。startVertex 的非零值可用于加载顶点数据的子区域。
		 * @param numVertices			data 表示的顶点数量。
		 */
		public function uploadFromVector(data:Vector.<Number>, startVertex:int, numVertices:int):void
		{
			vertexBuffer3D.uploadFromVector(data, startVertex, numVertices);
			invalid = false;
		}

		/**
		 * 指定与单个着色器程序输入相对应的顶点数据组件。
		 * <p>使用 setVertexBufferAt 方法来标识 VertexBuffer3D 缓冲区中每个顶点定义的哪些数据组件属于顶点程序的哪些输入。顶点程序的开发人员会确定每个顶点需要的数据量。该数据从 1 个或多个 VertexBuffer3D 流映射到顶点着色器程序的属性寄存器中。</p>
		 * <p>顶点着色器所使用数据的最小单位为 32 位数据。距顶点流的偏移量以 32 位的倍数指定。</p>
		 * 举例来说，编程人员可以使用以下数据定义每个顶点：
		 * <pre>
		 * position:	x    float32
		 * 		y    float32
		 * 		z    float32
		 * color:	r    unsigned byte
		 *		g    unsigned byte
		 *		b    unsigned byte
		 *		a    unsigned byte
		 * </pre>
		 * 假定在 VertexBuffer3D 对象中定义了名为 buffer 的对象，则可使用以下代码将其分配给顶点着色器：
		 * <pre>
		 * setVertexBufferAt( 0, buffer, 0, Context3DVertexBufferFormat.FLOAT_3 );   // attribute #0 will contain the position information
		 * setVertexBufferAt( 1, buffer, 3, Context3DVertexBufferFormat.BYTES_4 );    // attribute #1 will contain the color information
		 * </pre>
		 * 
		 * @param index				顶点着色器中的属性寄存器的索引（0 到 7）。
		 * @param bufferOffset		单个顶点的起始数据偏移量，从此处开始读取此属性。在上例中，位置数据的偏移量为 0，因为它是第一个属性；颜色的偏移量为 3，因为颜色属性跟在 3 个 32 位位置值之后。以 32 位为单位指定偏移量。
		 * @param format			来自<code>Context3DVertexBufferFormat</code>类的值，指定此属性的数据类型。
		 */
		public function setVertexBufferAt(index:int, bufferOffset:int, format:String):void
		{
			context3D.setVertexBufferAt(index, vertexBuffer3D, bufferOffset, format);
		}
	}
}
