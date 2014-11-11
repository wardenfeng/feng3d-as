package me.feng3d.entities
{
	import flash.geom.Vector3D;
	
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.ISubGeometry;
	import me.feng3d.core.base.subgeometry.SkyBoxSubGeometry;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.base.submesh.SubSkyMesh;
	import me.feng3d.materials.SkyBoxMaterial;
	import me.feng3d.textures.CubeTextureBase;

	use namespace arcane;

	/**
	 * 天空盒类用于渲染的天空场景。
	 * 总是被认为是静态的,在无穷远处,并且总是集中在相机的位置和大小符合在相机的平截头体,
	 * 确保天空盒总是尽可能大而不被裁剪。
	 * @author warden_feng 2014-7-11
	 */
	public class SkyBox extends Mesh
	{
		private var subGeometry:SkyBoxSubGeometry;

		public function SkyBox(cubeMap:CubeTextureBase)
		{
			super();

			material = new SkyBoxMaterial(cubeMap);

			subGeometry = new SkyBoxSubGeometry();
			geometry.addSubGeometry(subGeometry);
			
			buildGeometry();
		}

		/**
		 * 创建天空盒 顶点与索引数据
		 */
		private function buildGeometry():void
		{
			//八个顶点，32个number
			var vertexData:Vector.<Number> = new <Number>[ //
				-1, 1, -1, 1, 1, -1, //
				1, 1, 1, -1, 1, 1, //
				-1, -1, -1, 1, -1, -1, //
				1, -1, 1, -1, -1, 1 //
				];
			subGeometry.updateVertexData(vertexData);

			//6个面，12个三角形，36个顶点索引
			var indexData:Vector.<uint> = new <uint>[ //
				0, 1, 2, 2, 3, 0, //
				6, 5, 4, 4, 7, 6, //
				2, 6, 7, 7, 3, 2, //
				4, 5, 1, 1, 0, 4, //
				4, 0, 3, 3, 7, 4, //
				2, 1, 5, 5, 6, 2 //
				];
			
			subGeometry.updateIndexData(indexData);
		}

		public function updateSkyBox(camera:Camera3D):void
		{
			// 已知：
			// 1、边长为2的立方体				-----------------1（引用编号）
			// 2、照相机在中心					-----------------2
			// 3、照相机最远观察距离zfar			-----------------3
			// 4、无论从哪个角度看天空盒都必须完整	-----------------4
			// 求：
			// 1、天空盒相对1中的立方体的缩放比例scale
			// 推导：
			// 1、1&2 --> 天空盒边长 2*scale		-----------------6
			// 2、6 --> 天空盒对角线长度  2 * sqrt(3) * scale	-----------------7
			// 3、2&3&4&7 --> 方程 2*zfar >= 2 * sqrt(3) * scale	-----------------8
			// 4、8 --> scale <= zfar / sqrt(3)
			var pos:Vector3D = camera.scenePosition;
			x = pos.x;
			y = pos.y;
			z = pos.z;

			scaleX = scaleY = scaleZ = camera.lens.far / Math.sqrt(3);
		}
		
		override protected function addSubMesh(subGeometry:ISubGeometry):void
		{
			var subMesh:SubMesh = new SubSkyMesh(subGeometry, this, null);
			var len:uint = _subMeshes.length;
			subMesh._index = len;
			_subMeshes[len] = subMesh;
			invalidateBounds();
		}
	}
}
