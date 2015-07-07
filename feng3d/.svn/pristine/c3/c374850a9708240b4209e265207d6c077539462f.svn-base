package me.feng3d.utils
{
	import flash.utils.Dictionary;

	import me.feng3d.arcane;
	import me.feng3d.core.base.subgeometry.SkinnedSubGeometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.debug.assert;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;

	use namespace arcane;

	/**
	 *
	 * @author warden_feng 2014-5-19
	 */
	public class GeomUtil
	{
		/** stage3d单次渲染支持的最大顶点数 */
		public static const MAX_VERTEX:int = 65535;

		/**
		 * 根据数据数组创建子网格
		 * @param verts
		 * @param indices
		 * @param uvs
		 * @param normals
		 * @param tangents
		 * @param weights
		 * @param jointIndices
		 * @param triangleOffset
		 * @return
		 */
		public static function fromVectors(verts:Vector.<Number>, indices:Vector.<uint>, uvs:Vector.<Number>, weights:Vector.<Number>, jointIndices:Vector.<Number>, triangleOffset:int = 0):Vector.<SubGeometry>
		{
			const LIMIT_VERTS:uint = 3 * 0xffff;
			const LIMIT_INDICES:uint = 15 * 0xffff;

			var subs:Vector.<SubGeometry> = new Vector.<SubGeometry>();

			if (uvs && !uvs.length)
				uvs = null;

			if (weights && !weights.length)
				weights = null;

			if (jointIndices && !jointIndices.length)
				jointIndices = null;

			if ((indices.length >= LIMIT_INDICES) || (verts.length >= LIMIT_VERTS))
			{
				var i:uint, len:uint, outIndex:uint, j:uint;
				var splitVerts:Vector.<Number> = new Vector.<Number>();
				var splitIndices:Vector.<uint> = new Vector.<uint>();
				var splitUvs:Vector.<Number> = (uvs != null) ? new Vector.<Number>() : null;
				var splitWeights:Vector.<Number> = (weights != null) ? new Vector.<Number>() : null;
				var splitJointIndices:Vector.<Number> = (jointIndices != null) ? new Vector.<Number>() : null;

				var mappings:Vector.<int> = new Vector.<int>(verts.length / 3, true);
				i = mappings.length;
				while (i-- > 0)
					mappings[i] = -1;

				var originalIndex:uint;
				var splitIndex:uint;
				var o0:uint, o1:uint, o2:uint, s0:uint, s1:uint, s2:uint, su:uint, ou:uint, sv:uint, ov:uint;
				// Loop over all triangles
				outIndex = 0;
				len = indices.length;

				for (i = 0; i < len; i += 3)
				{
					splitIndex = splitVerts.length + 6;

					if (((outIndex + 2) >= LIMIT_INDICES) || (splitIndex >= LIMIT_VERTS))
					{
						subs.push(constructSubGeometry(splitVerts, splitIndices, splitUvs, splitWeights, splitJointIndices, triangleOffset));
						splitVerts = new Vector.<Number>();
						splitIndices = new Vector.<uint>();
						splitUvs = (uvs != null) ? new Vector.<Number>() : null;
						splitWeights = (weights != null) ? new Vector.<Number>() : null;
						splitJointIndices = (jointIndices != null) ? new Vector.<Number>() : null;
						splitIndex = 0;
						j = mappings.length;
						while (j-- > 0)
							mappings[j] = -1;

						outIndex = 0;
					}

					// Loop over all vertices in triangle
					for (j = 0; j < 3; j++)
					{

						originalIndex = indices[i + j];

						if (mappings[originalIndex] >= 0)
							splitIndex = mappings[originalIndex];

						else
						{

							o0 = originalIndex * 3 + 0;
							o1 = originalIndex * 3 + 1;
							o2 = originalIndex * 3 + 2;

							// This vertex does not yet exist in the split list and
							// needs to be copied from the long list.
							splitIndex = splitVerts.length / 3;

							s0 = splitIndex * 3 + 0;
							s1 = splitIndex * 3 + 1;
							s2 = splitIndex * 3 + 2;

							splitVerts[s0] = verts[o0];
							splitVerts[s1] = verts[o1];
							splitVerts[s2] = verts[o2];

							if (uvs)
							{
								su = splitIndex * 2 + 0;
								sv = splitIndex * 2 + 1;
								ou = originalIndex * 2 + 0;
								ov = originalIndex * 2 + 1;

								splitUvs[su] = uvs[ou];
								splitUvs[sv] = uvs[ov];
							}

							if (weights)
							{
								splitWeights[s0] = weights[o0];
								splitWeights[s1] = weights[o1];
								splitWeights[s2] = weights[o2];
							}

							if (jointIndices)
							{
								splitJointIndices[s0] = jointIndices[o0];
								splitJointIndices[s1] = jointIndices[o1];
								splitJointIndices[s2] = jointIndices[o2];
							}

							mappings[originalIndex] = splitIndex;
						}

						// Store new index, which may have come from the mapping look-up,
						// or from copying a new set of vertex data from the original vector
						splitIndices[outIndex + j] = splitIndex;
					}

					outIndex += 3;
				}

				if (splitVerts.length > 0)
				{
					// More was added in the last iteration of the loop.
					subs.push(constructSubGeometry(splitVerts, splitIndices, splitUvs, splitWeights, splitJointIndices, triangleOffset));
				}

			}
			else
				subs.push(constructSubGeometry(verts, indices, uvs, weights, jointIndices, triangleOffset));

			return subs;
		}

		public static function constructSubGeometry(verts:Vector.<Number>, indices:Vector.<uint>, uvs:Vector.<Number>, weights:Vector.<Number>, jointIndices:Vector.<Number>, triangleOffset:int):SubGeometry
		{
			var sub:SubGeometry;

			if (weights && jointIndices)
			{
				// If there were weights and joint indices defined, this
				// is a skinned mesh and needs to be built from skinned
				// sub-geometries.
				sub = new SkinnedSubGeometry(weights.length / (verts.length / 3));
				SkinnedSubGeometry(sub).updateJointWeightsData(weights);
				SkinnedSubGeometry(sub).updateJointIndexData(jointIndices);

			}
			else
				sub = new SubGeometry();

			sub.numVertices = verts.length / 3;
			sub.updateIndexData(indices);
			sub.fromVectors(verts, uvs);
			return sub;
		}

		/**
		 * 拷贝子网格数据
		 * @param source 源子网格
		 * @param target 目标子网格
		 */
		public static function copyDataSubGeom(source:SubGeometry, target:SubGeometry):void
		{
			target.numVertices = source.numVertices;
			target.updateVertexPositionData(source.getVAData(Context3DBufferTypeIDCommon.POSITION_VA_3).concat());
			target.setVAData(Context3DBufferTypeIDCommon.UV_VA_2, source.getVAData(Context3DBufferTypeIDCommon.UV_VA_2).concat());
			target.updateIndexData(source.indices.concat());
		}

		/**
		 * source添加到target中
		 * @param source 源自几何体
		 * @param target 目标子几何体
		 * @return true：添加成功；false：添加失败，应该是顶点个数超出最大值65535
		 */
		public static function addSubGeometry(source:SubGeometry, target:SubGeometry):Boolean
		{
			if (source.numVertices + target.numVertices > MAX_VERTEX)
				return false;

			//顶点属性编号列表
			var vaIdList:Vector.<String> = source.vaIdList;
			var vaId:String;

			/** 顶点数据字典 */
			var sourceVertexDataDic:Dictionary = new Dictionary();
			var targetVertexDataDic:Dictionary = new Dictionary();
			for each (vaId in vaIdList)
			{
				sourceVertexDataDic[vaId] = source.getVAData(vaId);
				assert(sourceVertexDataDic[vaId].length == source.getVALen(vaId) * source.numVertices);

				targetVertexDataDic[vaId] = target.getVAData(vaId);
				assert(targetVertexDataDic[vaId].length == target.getVALen(vaId) * target.numVertices);
			}

			//添加索引数据
			var indices:Vector.<uint> = VectorUtils.add1(source.indices, target.indices, target.numVertices);
			target.updateIndexData(indices);

			//更改顶点数量
			target.numVertices = source.numVertices + target.numVertices;

			var vertexData:Vector.<Number>;
			//添加顶点数据
			for each (vaId in vaIdList)
			{
				//
				vertexData = VectorUtils.add(sourceVertexDataDic[vaId], targetVertexDataDic[vaId]);
				target.setVAData(vaId, vertexData);
			}

			return true;
		}

	}
}
