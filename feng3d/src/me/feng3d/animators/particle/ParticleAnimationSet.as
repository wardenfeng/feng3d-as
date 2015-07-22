package me.feng3d.animators.particle
{
	import flash.utils.Dictionary;

	import me.feng3d.arcane;
	import me.feng3d.animators.AnimationType;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.animators.base.data.AnimationSubGeometry;
	import me.feng3d.animators.particle.data.ParticleProperties;
	import me.feng3d.animators.particle.data.ParticlePropertiesMode;
	import me.feng3d.animators.particle.node.ParticleNodeBase;
	import me.feng3d.animators.particle.node.ParticleTimeNode;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.ParticleGeometry;
	import me.feng3d.core.base.data.ParticleData;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.entities.Mesh;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 粒子动画set
	 * @author warden_feng 2014-11-13
	 */
	public class ParticleAnimationSet extends AnimationSetBase
	{
		/**
		 * Property used by particle nodes that require color compilation
		 */
		public static const COLOR_PRIORITY:int = 18;

		/** 所有粒子动画都需要的时间节点 */
		private var _timeNode:ParticleTimeNode;

		private var _particleNodes:Vector.<ParticleNodeBase> = new Vector.<ParticleNodeBase>();
		private var _localStaticNodes:Vector.<ParticleNodeBase> = new Vector.<ParticleNodeBase>();

		/** 初始化粒子函数 */
		public var initParticleFunc:Function;

		/** 是否为广告牌 */
		public var hasBillboard:Boolean;

		/** 动画节点列表 */
		private var _effects:Vector.<ParticleNodeBase> = new Vector.<ParticleNodeBase>();
		/** 动画名称列表 */
		private var _effectNames:Vector.<String> = new Vector.<String>();
		/** 动画字典 */
		private var _effectDictionary:Dictionary = new Dictionary(true);

		private var _usesDuration:Boolean = false;
		private var _usesLooping:Boolean = false;
		private var _usesDelay:Boolean = false;

		/**
		 * 创建一个粒子动画集合
		 * @param usesDuration	是否持续
		 * @param usesLooping	是否循环
		 * @param usesDelay		是否延时
		 */
		public function ParticleAnimationSet(usesDuration:Boolean = false, usesLooping:Boolean = false, usesDelay:Boolean = false)
		{
			_usesDuration = usesDuration;
			_usesLooping = usesLooping;
			_usesDelay = usesDelay;

			//自动添加一个粒子的时间节点
			addParticleEffect(_timeNode = new ParticleTimeNode());
		}

		/**
		 * 粒子节点列表
		 */
		public function get particleNodes():Vector.<ParticleNodeBase>
		{
			return _particleNodes;
		}

		/**
		 * 添加粒子特效
		 * @param node
		 */
		public function addParticleEffect(node:ParticleNodeBase):void
		{
			var i:int;
			if (node.mode == ParticlePropertiesMode.LOCAL_STATIC)
			{
				_localStaticNodes.push(node);
			}

			for (i = _particleNodes.length - 1; i >= 0; i--)
			{
				if (_particleNodes[i].priority <= node.priority)
					break;
			}

			_particleNodes.splice(i + 1, 0, node);

			_effectDictionary[node.animationName] = node;

			_effects.push(node);
			addChildBufferOwner(node);

			_effectNames.push(node.animationName);
		}

		arcane override function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
		{
			shaderParams.usesDuration = _usesDuration;
			shaderParams.usesLooping = _usesLooping;
			shaderParams.usesDelay = _usesDelay;

			for (var i:int = 0; i < _effects.length; i++)
			{
				_effects[i].processAnimationSetting(shaderParams);
			}

			shaderParams.animationType = AnimationType.PARTICLE;
		}

		/**
		 * 生成粒子动画数据
		 * @param mesh
		 */
		arcane function generateAnimationSubGeometries(mesh:Mesh):void
		{
			if (initParticleFunc == null)
				throw(new Error("no initParticleFunc set"));

			var geometry:ParticleGeometry = mesh.geometry as ParticleGeometry;

			if (!geometry)
				throw(new Error("Particle animation can only be performed on a ParticleGeometry object"));

			var i:int;
			var particleSubGeometry:AnimationSubGeometry;
			var subGeometry:SubGeometry;
			var localNode:ParticleNodeBase;
			var subMesh:SubMesh;

			//注册顶点数据
			for each (subMesh in mesh.subMeshes)
			{
				particleSubGeometry = new AnimationSubGeometry();
				//遍历静态本地节点
				for each (localNode in _localStaticNodes)
				{
					particleSubGeometry.mapVABuffer(localNode.vaId, localNode.vaLen);
				}
				particleSubGeometry.numVertices = subMesh.subGeometry.numVertices;
				subMesh.animationSubGeometry = particleSubGeometry;
			}

			//粒子数据
			var particles:Vector.<ParticleData> = geometry.particles;
			//粒子数量
			var numParticles:uint = geometry.numParticles;
			//粒子属性
			var particleProperties:ParticleProperties = new ParticleProperties();
			var particle:ParticleData;

			var counterForVertex:int;
			var counterForOneData:int;
			var oneData:Vector.<Number>;
			var numVertices:uint;
			var vertexOffset:uint;

			//设置默认数据
			particleProperties.total = numParticles;
			particleProperties.startTime = 0;
			particleProperties.duration = 1000;
			particleProperties.delay = 0.1;

			i = 0;
			while (i < numParticles)
			{
				particleProperties.index = i;
				particle = particles[i];

				//调用函数初始化粒子属性
				initParticleFunc(particleProperties);

				//创建本地节点粒子属性
				for each (localNode in _localStaticNodes)
					localNode.generatePropertyOfOneParticle(particleProperties);

				for each (subMesh in mesh.subMeshes)
				{
					if (subMesh.subGeometry == particle.subGeometry)
					{
						particleSubGeometry = subMesh.animationSubGeometry;
						break;
					}
				}

				numVertices = particle.numVertices;

				//遍历静态本地节点
				for each (localNode in _localStaticNodes)
				{
					oneData = localNode.oneData;

					/** 粒子所在子几何体的顶点位置 */
					var startVertexIndex:uint = particle.startVertexIndex;
					var vaData:Vector.<Number> = particleSubGeometry.getVAData(localNode.vaId);
					var vaLen:uint = particleSubGeometry.getVALen(localNode.vaId);

					//收集该粒子的每个顶点数据
					for (var j:int = 0; j < numVertices; j++)
					{
						vertexOffset = (startVertexIndex + j) * vaLen;

						for (counterForOneData = 0; counterForOneData < vaLen; counterForOneData++)
							vaData[vertexOffset + counterForOneData] = oneData[counterForOneData];
					}
				}

				//下一个粒子
				i++;
			}
		}

		public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			for (var i:int = 0; i < _particleNodes.length; i++)
			{
				_particleNodes[i].setRenderState(renderable, camera);
			}
		}
	}
}
