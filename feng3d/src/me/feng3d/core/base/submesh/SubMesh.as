package me.feng3d.core.base.submesh
{
	import flash.events.Event;

	import me.feng.core.NamedAsset;
	import me.feng3d.arcane;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.animators.base.data.AnimationSubGeometry;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.renderable.RenderableBase;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.entities.Entity;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.MeshEvent;
	import me.feng3d.materials.MaterialBase;

	use namespace arcane;

	/**
	 * 子网格，可渲染对象
	 */
	public class SubMesh extends NamedAsset
	{
		public var renderableBase:RenderableBase;

		public var context3DBufferOwner:Context3DBufferOwner;

		protected var _parentMesh:Mesh;
		protected var _subGeometry:SubGeometry;
		arcane var _index:uint;

		protected var _materialSelf:MaterialBase;
		private var _material:MaterialBase;
		private var _materialDirty:Boolean;

		private var _animator:AnimatorBase;

		private var _animationSubGeometry:AnimationSubGeometry;

		/**
		 * 创建一个子网格
		 * @param subGeometry 子几何体
		 * @param parentMesh 父网格
		 * @param material 材质
		 */
		public function SubMesh(subGeometry:SubGeometry, parentMesh:Mesh, material:MaterialBase = null)
		{
			context3DBufferOwner = new Context3DBufferOwner();
			renderableBase = new RenderableBase(this);

			_parentMesh = parentMesh;
			this.subGeometry = subGeometry;
			this.material = material;

			_parentMesh.addEventListener(MeshEvent.MATERIAL_CHANGE, onMaterialChange);
		}

		/**
		 * 渲染材质
		 */
		public function get material():MaterialBase
		{
			if (_materialDirty)
				updateMaterial();
			return _material;
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
			_materialSelf = value;
			_materialDirty = true;
		}

		/**
		 * 更新材质
		 */
		private function updateMaterial():void
		{
			var value:MaterialBase = _materialSelf ? _materialSelf : _parentMesh.material;
			if (value == _material)
				return;

			if (_material)
			{
				_material.removeOwner(this.renderableBase);
			}
			_material = value;
			if (_material)
			{
				_material.addOwner(this.renderableBase);
			}
		}

		/**
		 * 所属实体
		 */
		public function get sourceEntity():Entity
		{
			return _parentMesh;
		}

		/**
		 * 子网格
		 */
		public function get subGeometry():SubGeometry
		{
			return _subGeometry;
		}

		public function set subGeometry(value:SubGeometry):void
		{
			if (_subGeometry)
			{
				context3DBufferOwner.removeChildBufferOwner(_subGeometry.context3DBufferOwner);
			}
			_subGeometry = value;
			if (_subGeometry)
			{
				context3DBufferOwner.addChildBufferOwner(_subGeometry.context3DBufferOwner);
			}
		}

		/**
		 * 动画顶点数据(例如粒子特效的时间、位置偏移、速度等等)
		 */
		public function get animationSubGeometry():AnimationSubGeometry
		{
			return _animationSubGeometry;
		}

		public function set animationSubGeometry(value:AnimationSubGeometry):void
		{
			if (_animationSubGeometry)
			{
				context3DBufferOwner.removeChildBufferOwner(_animationSubGeometry.context3DBufferOwner);
			}
			_animationSubGeometry = value;
			if (_animationSubGeometry)
			{
				context3DBufferOwner.addChildBufferOwner(_animationSubGeometry.context3DBufferOwner);
			}
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
			{
				context3DBufferOwner.removeChildBufferOwner(_animator.context3DBufferOwner);
				material.animationSet = null;
			}
			_animator = value;
			if (_animator)
			{
				context3DBufferOwner.addChildBufferOwner(_animator.context3DBufferOwner);
				material.animationSet = _animator.animationSet;
			}
		}

		/**
		 * 父网格
		 */
		arcane function get parentMesh():Mesh
		{
			return _parentMesh;
		}

		public function get castsShadows():Boolean
		{
			return _parentMesh.castsShadows;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseEnabled():Boolean
		{
			return _parentMesh.mouseEnabled || _parentMesh.ancestorsAllowMouseEnabled;
		}

		/**
		 * @inheritDoc
		 */
		public function get numTriangles():uint
		{
			return _subGeometry.numTriangles;
		}

		/**
		 * 处理材质变化事件
		 */
		private function onMaterialChange(event:Event):void
		{
			_materialDirty = true;
		}

		/**
		 * 销毁
		 */
		public function dispose():void
		{
			material = null;
		}
	}
}
