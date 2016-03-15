package me.feng3d.materials.methods
{
	import flash.geom.Matrix3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.params.LightShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.passes.MaterialPassBase;
	import me.feng3d.passes.SingleObjectDepthPass;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * SubsurfaceScatteringDiffuseMethod provides a depth map-based diffuse shading method that mimics the scattering of
	 * light inside translucent surfaces. It allows light to shine through an object and to soften the diffuse shading.
	 * It can be used for candle wax, ice, skin, ...
	 */
	public class SubsurfaceScatteringDiffuseMethod extends CompositeDiffuseMethod
	{
		private var _depthPass:SingleObjectDepthPass;
		private var _propReg:Register;
		private var _scattering:Number;
		private var _translucency:Number = 1;
		private var _lightColorReg:Register;
		private var _scatterColor:uint = 0xffffff;
		private var _decReg:Register;
		private var _scatterR:Number = 1.0;
		private var _scatterG:Number = 1.0;
		private var _scatterB:Number = 1.0;
		private var _targetReg:Register;

		private const vertexToTexData:Vector.<Number> = Vector.<Number>([0.5, -0.5, 0, 1]);
		private const f$ColorData:Vector.<Number> = Vector.<Number>([1.0, 1.0, 1.0, 1.0]);

		private const fragmentData0:Vector.<Number> = Vector.<Number>([1.0, 1.0 / 255, 1.0 / 65025, 1.0 / 16581375]);
		private const fragmentData1:Vector.<Number> = Vector.<Number>([0.2, 1, 0.5, -0.1]);

		private var _isFirstLight:Boolean;
		private var _depthMap:TextureProxyBase;
		private var lightProjection:Matrix3D = new Matrix3D();

		/**
		 * Creates a new SubsurfaceScatteringDiffuseMethod object.
		 * @param depthMapSize The size of the depth map used.
		 * @param depthMapOffset The amount by which the rendered object will be inflated, to prevent depth map rounding errors.
		 */
		public function SubsurfaceScatteringDiffuseMethod(depthMapSize:int = 512, depthMapOffset:Number = 15)
		{
			super(scatterLight);
			_passes = new Vector.<MaterialPassBase>();
			_depthPass = new SingleObjectDepthPass(depthMapSize, depthMapOffset);
			_passes.push(_depthPass);
			_scattering = 0.2;
			_translucency = 1;
		}

		private function get depthMap():TextureProxyBase
		{
			return _depthMap;
		}

		private function set depthMap(value:TextureProxyBase):void
		{
			if (_depthMap != value)
			{
				_depthMap = value;
				context3DBufferOwner.markBufferDirty(_.SSD$depthMap_fs);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();

			context3DBufferOwner.mapContext3DBuffer(_.SSD$ToTex_vc_vector, SSD$ToTexBuffer);
			context3DBufferOwner.mapContext3DBuffer(_.SSD$f$ColorData_vc_vector, f$ColorDataBuffer);
			context3DBufferOwner.mapContext3DBuffer(_.SSD$fragmentData0_vc_vector, fragmentData0Buffer);
			context3DBufferOwner.mapContext3DBuffer(_.SSD$fragmentData1_vc_vector, fragmentData1Buffer);
			context3DBufferOwner.mapContext3DBuffer(_.SSD$depthMap_fs, updateDepthMapBuffer);

			context3DBufferOwner.mapContext3DBuffer(_.SSD$LightProjection_vc_matrix, updateLightProjectionBuffer);
		}

		private function SSD$ToTexBuffer(vcVectorBuffer:VCVectorBuffer):void
		{
			vcVectorBuffer.update(vertexToTexData);
		}

		private function f$ColorDataBuffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(f$ColorData);
		}

		private function fragmentData0Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(fragmentData0);
		}

		private function fragmentData1Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(fragmentData1);
		}

		private function updateDepthMapBuffer(textureBuffer:FSBuffer):void
		{
			textureBuffer.update(depthMap);
		}

		protected function updateLightProjectionBuffer(vcMatrixBuffer:VCMatrixBuffer):void
		{
			vcMatrixBuffer.update(lightProjection, true);
		}

		arcane override function cleanCompilationData():void
		{
			super.cleanCompilationData();

			_propReg = null;
			_lightColorReg = null;
			_decReg = null;
			_targetReg = null;
		}

		/**
		 * The amount by which the light scatters. It can be used to set the translucent surface's thickness. Use low
		 * values for skin.
		 */
		public function get scattering():Number
		{
			return _scattering;
		}

		public function set scattering(value:Number):void
		{
			_scattering = value;
		}

		/**
		 * The translucency of the object.
		 */
		public function get translucency():Number
		{
			return _translucency;
		}

		public function set translucency(value:Number):void
		{
			_translucency = value;
		}

		/**
		 * The colour of the "insides" of the object, ie: the colour the light becomes after leaving the object.
		 */
		public function get scatterColor():uint
		{
			return _scatterColor;
		}

		public function set scatterColor(scatterColor:uint):void
		{
			_scatterColor = scatterColor;
			_scatterR = ((scatterColor >> 16) & 0xff) / 0xff;
			_scatterG = ((scatterColor >> 8) & 0xff) / 0xff;
			_scatterB = (scatterColor & 0xff) / 0xff;
		}

		/**
		 * @inheritDoc
		 */
		arcane function getVertexCode():void
		{
			var vt0:Register;

			var _:* = FagalRE.instance.space;

			var lightProjection:Register;
			var toTexRegister:Register = _.SSD$ToTex_vc_vector;
			var temp:Register = _.getFreeTemp();

			var _lightProjVarying:Register = _.SSD$LightProj_v;

			lightProjection = _.SSD$LightProjection_vc_matrix;

			_.m44(temp, vt0, lightProjection); //
			_.div(temp.xyz, temp.xyz, temp.w); //
			_.mul(temp.xy, temp.xy, toTexRegister.xy); //
			_.add(temp.xy, temp.xy, toTexRegister.xx); //
			_.mov(_lightProjVarying.xyz, temp.xyz); //
			_.mov(_lightProjVarying.w, _.position_va_3.w);
		}

		/**
		 * @inheritDoc
		 */
		arcane function getFragmentPreLightingCode():void
		{
			var _:* = FagalRE.instance.space;

			_decReg = _.SSD$dec_fc_vector;
			_propReg = _.SSD$prop_fc_vector;
		}

		/**
		 * @inheritDoc
		 */
		arcane function getFragmentCodePerLight():void
		{
			var lightColReg:Register;

			_isFirstLight = true;
			_lightColorReg = lightColReg;
		}

		/**
		 * @inheritDoc
		 */
		arcane function getFragmentPostLightingCode():void
		{
			var targetReg:Register;

			var _:* = FagalRE.instance.space;

			var temp:Register = _.getFreeTemp();

			var _colorReg:Register = _.SSD$Color_fc_vector;

			_.mul(temp.xyz, _lightColorReg.xyz, _targetReg.w); //
			_.mul(temp.xyz, temp.xyz, _colorReg.xyz); //
			_.add(targetReg.xyz, targetReg.xyz, temp.xyz);
		}

		/**
		 * @inheritDoc
		 */
		arcane override function activate(shaderParams:ShaderParams):void
		{
			super.activate(shaderParams);

			f$ColorData[0] = _scatterR;
			f$ColorData[1] = _scatterG;
			f$ColorData[2] = _scatterB;

			fragmentData1[0] = _scattering;
			fragmentData1[1] = _translucency;
		}

		/**
		 * @inheritDoc
		 */
		arcane override function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			depthMap = _depthPass.getDepthMap(renderable);

			var projection:Matrix3D = _depthPass.getProjection(renderable);
			lightProjection.copyFrom(projection);
		}

		/**
		 * Generates the code for this method
		 */
		private function scatterLight():void
		{
			var _:* = FagalRE.instance.space;
			var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
			var lightShaderParams:LightShaderParams = shaderParams.getOrCreateComponentByClass(LightShaderParams);

			// only scatter first light
			if (!_isFirstLight)
				return;
			_isFirstLight = false;

			var targetReg:Register;

			var depthReg:Register = _.SSD$depthMap_fs;

			if (lightShaderParams.needsViewDir > 0)
				_targetReg = _.viewDir_ft_4;
			else
			{
				_targetReg = _.getFreeTemp();
			}

			var _lightProjVarying:Register = _.SSD$LightProj_v;
			var _colorReg:Register = _.SSD$Color_fc_vector;

			var temp:Register = _.getFreeTemp();
			"tex " + temp + ", " + _lightProjVarying + ", " + depthReg + " <2d,nearest,clamp>\n";
			// reencode RGBA
			_.dp4(targetReg.z, temp, _decReg);
			// currentDistanceToLight - closestDistanceToLight
			_.sub(targetReg.z, _lightProjVarying.z, targetReg.z);

			_.sub(targetReg.z, _propReg.x, targetReg.z);
			_.mul(targetReg.z, _propReg.y, targetReg.z);
			_.sat(targetReg.z, targetReg.z);

			// targetReg.x contains dot(lightDir, normal)
			// modulate according to incident light angle (scatter = scatter*(-.5*dot(light, normal) + .5)
			_.neg(targetReg.y, targetReg.x);
			_.mul(targetReg.y, targetReg.y, _propReg.z);
			_.add(targetReg.y, targetReg.y, _propReg.z);
			_.mul(_targetReg.w, targetReg.z, targetReg.y);

			// blend diffuse: d' = (1-s)*d + s*1
			_.sub(targetReg.y, _colorReg.w, _targetReg.w);
			_.mul(targetReg.w, targetReg.w, targetReg.y);

		}
	}
}
