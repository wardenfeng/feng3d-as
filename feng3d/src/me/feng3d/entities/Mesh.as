package me.feng3d.entities
{
	import me.feng3d.arcane;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.IMaterialOwner;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.partition.node.EntityNode;
	import me.feng3d.core.partition.node.MeshNode;
	import me.feng3d.events.GeometryEvent;
	import me.feng3d.events.MeshEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.materials.MaterialBase;
	import me.feng3d.utils.DefaultMaterialManager;

	use namespace arcane;

	/**
	 * 材质发生变化时抛出
	 */
	[Event(name = "materialChange", type = "me.feng3d.events.MeshEvent")]

	/**
	 * 网格
	 * @author feng 2014-4-9
	 */
	public class Mesh extends Entity implements IMaterialOwner
	{
		protected var _subMeshes:Vector.<SubMesh>;

		protected var _geometry:Geometry;

		protected var _materialSelf:MaterialBase;

		protected var _animator:AnimatorBase;

		private var _castsShadows:Boolean = true;

		/**
		 * 新建网格
		 * @param geometry 几何体
		 * @param material 材质
		 */
		public function Mesh(geometry:Geometry = null, material:MaterialBase = null)
		{
			super();
			_subMeshes = new Vector.<SubMesh>();

			this.geometry = geometry || new Geometry();

			this.material = material || DefaultMaterialManager.getDefaultMaterial();
		}

		/** 几何形状 */
		public function get geometry():Geometry
		{
			return _geometry;
		}

		public function set geometry(value:Geometry):void
		{
			var i:uint;

			if (_geometry)
			{
				_geometry.removeEventListener(GeometryEvent.SHAPE_CHANGE, onGeometryBoundsInvalid);
				_geometry.removeEventListener(GeometryEvent.SUB_GEOMETRY_ADDED, onSubGeometryAdded);
				_geometry.removeEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED, onSubGeometryRemoved);

				for (i = 0; i < _subMeshes.length; ++i)
					_subMeshes[i].dispose();
				_subMeshes.length = 0;
			}

			_geometry = value;

			if (_geometry)
			{
				_geometry.addEventListener(GeometryEvent.SHAPE_CHANGE, onGeometryBoundsInvalid);
				_geometry.addEventListener(GeometryEvent.SUB_GEOMETRY_ADDED, onSubGeometryAdded);
				_geometry.addEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED, onSubGeometryRemoved);

				var subGeoms:Vector.<SubGeometry> = _geometry.subGeometries;

				for (i = 0; i < subGeoms.length; ++i)
					addSubMesh(subGeoms[i]);
			}

			invalidateBounds();
		}

		/**
		 * 渲染材质
		 */
		public function get material():MaterialBase
		{
			return _materialSelf;
		}

		/**
		 * 自身材质
		 */
		public function get materialSelf():MaterialBase
		{
			return _materialSelf;
		}

		public function set material(value:MaterialBase):void
		{
			if (value == _materialSelf)
				return;
			if (_materialSelf)
				_materialSelf.removeOwner(this);
			_materialSelf = value;
			if (_materialSelf)
				_materialSelf.addOwner(this);

			dispatchEvent(new MeshEvent(MeshEvent.MATERIAL_CHANGE));
		}

		/**
		 * 源实体
		 */
		public function get sourceEntity():Entity
		{
			return this;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateBounds():void
		{
			_bounds.fromGeometry(geometry);
			_boundsInvalid = false;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function collidesBefore(shortestCollisionDistance:Number, findClosest:Boolean):Boolean
		{
			_pickingCollider.setLocalRay(_pickingCollisionVO.localRay);
			_pickingCollisionVO.renderable = null;

			var len:int = _subMeshes.length;
			for (var i:int = 0; i < len; ++i)
			{
				var subMesh:SubMesh = _subMeshes[i];
				//var ignoreFacesLookingAway:Boolean = _material ? !_material.bothSides : true;
				if (_pickingCollider.testSubMeshCollision(subMesh, _pickingCollisionVO, shortestCollisionDistance))
				{
					shortestCollisionDistance = _pickingCollisionVO.rayEntryDistance;
					_pickingCollisionVO.renderable = subMesh;
					if (!findClosest)
						return true;
				}
			}

			return _pickingCollisionVO.renderable != null;
		}

		/**
		 * @inheritDoc
		 */
		public function get animator():AnimatorBase
		{
			return _animator;
		}

		public function set animator(value:AnimatorBase):void
		{
			if (_animator)
				_animator.removeOwner(this);

			_animator = value;

			var i:int;

			for (i = 0; i < subMeshes.length; i++)
			{
				var subMesh:SubMesh = subMeshes[i];
				subMesh.animator = _animator;
			}

			if (_animator)
				_animator.addOwner(this);
		}

		/**
		 * 子网格列表
		 */
		public function get subMeshes():Vector.<SubMesh>
		{
			return _subMeshes;
		}

		/**
		 * 添加子网格包装子几何体
		 * @param subGeometry		被添加的子几何体
		 */
		protected function addSubMesh(subGeometry:SubGeometry):void
		{
			var subMesh:SubMesh = new SubMesh(subGeometry, this, null);
			var len:uint = _subMeshes.length;
			subMesh._index = len;
			_subMeshes[len] = subMesh;
			invalidateBounds();
		}

		/**
		 * 处理几何体边界变化事件
		 */
		private function onGeometryBoundsInvalid(event:GeometryEvent):void
		{
			invalidateBounds();
		}

		/**
		 * 处理子几何体添加事件
		 */
		private function onSubGeometryAdded(event:GeometryEvent):void
		{
			addSubMesh(event.subGeometry);
			invalidateBounds();
		}

		/**
		 * 处理子几何体移除事件
		 */
		private function onSubGeometryRemoved(event:GeometryEvent):void
		{
			var subMesh:SubMesh;
			var subGeom:SubGeometry = event.subGeometry;
			var len:int = _subMeshes.length;
			var i:uint;

			for (i = 0; i < len; ++i)
			{
				subMesh = _subMeshes[i];
				if (subMesh.subGeometry == subGeom)
				{
					subMesh.dispose();
					_subMeshes.splice(i, 1);
					break;
				}
			}

			--len;
			for (; i < len; ++i)
				_subMeshes[i]._index = i;

			invalidateBounds();
		}

		/**
		 * 是否捕获阴影
		 */
		public function get castsShadows():Boolean
		{
			return _castsShadows;
		}

		public function set castsShadows(value:Boolean):void
		{
			_castsShadows = value;
		}

		/**
		 * @inheritDoc
		 */
		public override function get assetType():String
		{
			return AssetType.MESH;
		}

		/**
		 * @inheritDoc
		 */
		override protected function createEntityPartitionNode():EntityNode
		{
			return new MeshNode(this);
		}
	}
}
