package me.feng3d.core.base.submesh
{
	import me.feng3d.arcane;
	import me.feng3d.animators.Animator;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.base.ISubGeometry;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.entities.Entity;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.MaterialEvent;
	import me.feng3d.materials.MaterialBase;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 子网格，可渲染对象
	 */
	public class SubMesh implements IRenderable
	{
		protected var _material:MaterialBase;
		protected var _parentMaterial:MaterialBase;
		protected var _parentMesh:Mesh;
		protected var _subGeometry:ISubGeometry;
		arcane var _index:uint;

		private var _materialUsed:MaterialBase;

		private var _animator:Animator;

		/**
		 * 创建一个子网格
		 * @param subGeometry 子几何体
		 * @param parentMesh 父网格
		 * @param material 材质
		 */
		public function SubMesh(subGeometry:ISubGeometry, parentMesh:Mesh, material:MaterialBase = null)
		{
			this.parentMesh = parentMesh;
			this.subGeometry = subGeometry;
			this.material = material;
		}

		/**
		 * 使用中的材质
		 */
		public function get materialUsed():MaterialBase
		{
			return _materialUsed;
		}

		public function set materialUsed(value:MaterialBase):void
		{
			if (_materialUsed)
			{
				_materialUsed.releaseCache(context3dCache);
				_materialUsed.removeEventListener(MaterialEvent.PASS_ADDED, onPassAdded);
				_materialUsed.removeEventListener(MaterialEvent.PASS_REMOVED, onPassRemoved);
			}
			_materialUsed = value;
			if (_materialUsed)
			{
				_materialUsed.collectCache(context3dCache);
				_materialUsed.addEventListener(MaterialEvent.PASS_ADDED, onPassAdded);
				_materialUsed.addEventListener(MaterialEvent.PASS_REMOVED, onPassRemoved);
			}
		}

		private function onPassRemoved(event:MaterialEvent):void
		{
			var pass:MaterialPassBase = event.data;
			pass.releaseCache(context3dCache);
		}

		private function onPassAdded(event:MaterialEvent):void
		{
			var pass:MaterialPassBase = event.data;
			pass.collectCache(context3dCache);
		}

		/**
		 * 父材质
		 */
		arcane function get parentMaterial():MaterialBase
		{
			return _parentMaterial;
		}

		arcane function set parentMaterial(value:MaterialBase):void
		{
			if (_parentMaterial != value)
			{
				_parentMaterial = value;
				updateMaterial();
			}
		}

		/**
		 * 网格材质
		 */
		public function get material():MaterialBase
		{
			return _material;
		}

		public function set material(value:MaterialBase):void
		{
			if (_material != value)
			{
				_material = value;
				updateMaterial();
			}
		}

		/**
		 * 更新材质
		 */
		private function updateMaterial():void
		{
			materialUsed = _material ? _material : _parentMaterial;
		}

		/**
		 * 所属实体
		 */
		public function get sourceEntity():Entity
		{
			return _parentMesh;
		}

		/**
		 * The SubGeometry object which provides the geometry data for this SubMesh.
		 */
		public function get subGeometry():ISubGeometry
		{
			return _subGeometry;
		}

		public function set subGeometry(value:ISubGeometry):void
		{
			if (_subGeometry)
			{
				_subGeometry.releaseCache(context3dCache);
			}
			_subGeometry = value;
			if (_subGeometry)
			{
				_subGeometry.collectCache(context3dCache);
			}
		}

		public function get animator():Animator
		{
			return _animator;
		}

		public function set animator(value:Animator):void
		{
			if (_animator)
			{
				_animator.releaseCache(context3dCache);
				materialUsed.animationSet = null;
			}
			_animator = value;
			if (_animator)
			{
				_animator.collectCache(context3dCache);
				materialUsed.animationSet = _animator.animationSet;
			}
		}

		arcane function set parentMesh(value:Mesh):void
		{
			_parentMesh = value;
			parentMaterial = _parentMesh.material;
		}

		public function dispose():void
		{
			material = null;
		}

		public function render(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			if (!_parentMesh.visible)
				return;

			//初始化渲染参数
			context3dCache.shaderParams.init();

			materialUsed.activatePass(context3dCache.shaderParams, stage3DProxy, camera);
			//准备渲染时所需数据 与 设置渲染参数
			materialUsed.renderPass(this, stage3DProxy, camera);

			//绘制图形
			context3dCache.render(stage3DProxy.context3D);
		}

		private var _context3dCache:Context3DCache;

		public function get context3dCache():Context3DCache
		{
			return _context3dCache ||= new Context3DCache();
		}
	}
}
