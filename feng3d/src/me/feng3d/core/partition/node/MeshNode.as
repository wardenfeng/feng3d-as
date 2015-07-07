package me.feng3d.core.partition.node
{
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.traverse.PartitionTraverser;
	import me.feng3d.entities.Mesh;


	/**
	 * 网格分区节点
	 * @author warden_feng 2015-3-8
	 */
	public class MeshNode extends EntityNode
	{
		private var _mesh:Mesh;

		/**
		 * 创建一个网格分区节点
		 * @param mesh		网格
		 */
		public function MeshNode(mesh:Mesh)
		{
			super(mesh);
			_mesh = mesh;
		}

		/**
		 * @inheritDoc
		 */
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if (traverser.enterNode(this))
			{
				super.acceptTraverser(traverser);
				var subs:Vector.<SubMesh> = _mesh.subMeshes;
				var i:uint;
				var len:uint = subs.length;
				while (i < len)
					traverser.applyRenderable(subs[i++]);
			}
		}
	}
}
