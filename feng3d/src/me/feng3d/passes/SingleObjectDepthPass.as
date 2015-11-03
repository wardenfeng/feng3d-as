package me.feng3d.passes
{
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.lights.LightBase;
	import me.feng3d.textures.RenderTexture;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * The SingleObjectDepthPass provides a material pass that renders a single object to a depth map from the point
	 * of view from a light.
	 */
	public class SingleObjectDepthPass extends MaterialPassBase
	{
		private var _textures:Dictionary;
		private var _projections:Dictionary;
		private var _textureSize:uint;
		private var _projectionTexturesInvalid:Boolean = true;

		private const _polyOffset:Vector.<Number> = Vector.<Number>([15, 0, 0, 0]);

		/**
		 * 通用数据
		 */
		private const depthCommonsData0:Vector.<Number> = Vector.<Number>([1.0, 255.0, 65025.0, 16581375.0]);

		/**
		 * 通用数据
		 */
		private const depthCommonsData1:Vector.<Number> = Vector.<Number>([1.0 / 255.0, 1.0 / 255.0, 1.0 / 255.0, 0.0]);

		private const objectProjectionMatrix:Matrix3D = new Matrix3D();

		/**
		 * Creates a new SingleObjectDepthPass object.
		 * @param textureSize The size of the depth map texture to render to.
		 * @param polyOffset The amount by which the rendered object will be inflated, to prevent depth map rounding errors.
		 *
		 * todo: provide custom vertex code to assembler
		 */
		public function SingleObjectDepthPass(textureSize:uint = 512, polyOffset:Number = 15)
		{
			super();
			_textureSize = textureSize;
			_polyOffset[0] = polyOffset;

			_textures = new Dictionary();
			_projections = new Dictionary();

//			_enc = Vector.<Number>([1.0, 255.0, 65025.0, 16581375.0, 1.0 / 255.0, 1.0 / 255.0, 1.0 / 255.0, 0.0]);
//			depthCommonsData0 = Vector.<Number>([1.0, 255.0, 65025.0, 16581375.0]);
//			depthCommonsData1 = Vector.<Number>([1.0 / 255.0, 1.0 / 255.0, 1.0 / 255.0, 0.0]);

//			_animatableAttributes = Vector.<String>(["va0", "va1"]);
//			_animationTargetRegisters = Vector.<String>(["vt0", "vt1"]);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			mapContext3DBuffer(_.SODP$polyOffset_vc_vector, updatePolyOffsetBuffer);
			mapContext3DBuffer(_.SODP$objectProjection_vc_matrix, updateObjectProjectionBuffer);

			mapContext3DBuffer(_.SODP$depthCommonsData0_fc_vector, updateDepthCommonsData0Buffer);
			mapContext3DBuffer(_.SODP$depthCommonsData1_fc_vector, updateDepthCommonsData1Buffer);
		}

		private function updatePolyOffsetBuffer(vcVectorBuffer:VCVectorBuffer):void
		{
			vcVectorBuffer.update(_polyOffset);
		}

		protected function updateObjectProjectionBuffer(vcMatrixBuffer:VCMatrixBuffer):void
		{
			vcMatrixBuffer.update(objectProjectionMatrix, true);
		}

		private function updateDepthCommonsData0Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(depthCommonsData0);
		}

		private function updateDepthCommonsData1Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(depthCommonsData1);
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			if (_textures)
			{
				_textures = null;
			}
		}

		/**
		 * Updates the projection textures used to contain the depth renders.
		 */
		private function updateProjectionTextures():void
		{
			_textures = new Dictionary();
			_projections = new Dictionary();
			_projectionTexturesInvalid = false;
		}

		/**
		 * @inheritDoc
		 */
		arcane function getVertexCode():void
		{
			var _:* = FagalRE.instance.space;
			var vt7:Object;
			var vt1:Object;
			var vc4:Object;
			var vt0:Object;
			var vc0:Object;
			var vt2:Object;
			var op:Object;
			var v0:Object;

			// offset
			_.mul(vt7, vt1, vc4.x); //
			_.add(vt7, vt7, vt0); //
			_.mov(vt7.w, vt0.w);
			// project
			_.m44(vt2, vt7, vc0); //
			_.mov(op, vt2);

			// perspective divide
			_.div(v0, vt2, vt2.w);
		}

		/**
		 * @inheritDoc
		 */
		arcane function getFragmentCode(animationCode:String):void
		{
			// encode float -> rgba
			var _:* = FagalRE.instance.space;
			var ft0:Object;
			var fc0:Object;
			var v0:Object;
			var ft1:Object;
			var fc1:Object;
			var oc:Object;

			_.mul(ft0, fc0, v0.z); //
			_.frc(ft0, ft0); //
			_.mul(ft1, ft0.yzww, fc1); //
			_.sub(ft0, ft0, ft1); //
			_.mov(oc, ft0);
		}

		/**
		 * Gets the depth maps rendered for this object from all lights.
		 * @param renderable The renderable for which to retrieve the depth maps.
		 * @param stage3DProxy The Stage3DProxy object currently used for rendering.
		 * @return A list of depth map textures for all supported lights.
		 */
		arcane function getDepthMap(renderable:IRenderable):TextureProxyBase
		{
			_textures ||= new Dictionary();

			// todo: use texture proxy?
			var target:TextureProxyBase = _textures[renderable] ||= new RenderTexture(_textureSize, _textureSize);

			//			stage3DProxy.setRenderTarget(target, true);
			//			context.clear(1.0, 1.0, 1.0);

			return _textures[renderable];
		}

		/**
		 * Retrieves the depth map projection maps for all lights.
		 * @param renderable The renderable for which to retrieve the projection maps.
		 * @return A list of projection maps for all supported lights.
		 */
		arcane function getProjection(renderable:IRenderable):Matrix3D
		{
			var light:LightBase;
			var lights:Vector.<LightBase> = _lightPicker.allPickedLights;

			var matrix:Matrix3D = _projections[renderable] ||= new Matrix3D();

			// local position = enough
			light = lights[0];

			light.getObjectProjectionMatrix(renderable, matrix);
			objectProjectionMatrix.copyFrom(matrix);

			return _projections[renderable];
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(camera:Camera3D, target:TextureProxyBase = null):void
		{
			if (_projectionTexturesInvalid)
				updateProjectionTextures();
			// never scale
			super.activate(camera, target);
		}
	}
}
