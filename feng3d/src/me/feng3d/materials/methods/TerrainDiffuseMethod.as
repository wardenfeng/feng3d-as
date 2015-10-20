package me.feng3d.materials.methods
{
	import flash.display3D.Context3DWrapMode;

	import me.feng3d.arcane;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSArrayBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	
	import me.feng3d.fagal.fragment.F_TerrainDiffusePostLighting;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 地形渲染函数
	 * @author feng 2014-7-16
	 */
	public class TerrainDiffuseMethod extends BasicDiffuseMethod
	{
		private const tileData:Vector.<Number> = new Vector.<Number>(4);
		private var _blendingTexture:Texture2DBase;
		private var _splats:Array;
		private var _numSplattingLayers:uint;

		public function TerrainDiffuseMethod(splatTextures:Array, blendingTexture:Texture2DBase, tileData:Vector.<Number>)
		{
			super();

			splats = splatTextures;

			for (var i:int = 0; i < this.tileData.length && i < tileData.length; i++)
			{
				this.tileData[i] = tileData[i];
			}

			this.blendingTexture = blendingTexture;
			_numSplattingLayers = splats.length;
			if (_numSplattingLayers > 4)
				throw new Error("More than 4 splatting layers is not supported!");
		}

		public function get splats():Array
		{
			return _splats;
		}

		public function set splats(value:Array):void
		{
			_splats = value;
			markBufferDirty(_.terrainTextures_fs_array);
		}

		public function get blendingTexture():Texture2DBase
		{
			return _blendingTexture;
		}

		public function set blendingTexture(value:Texture2DBase):void
		{
			_blendingTexture = value;
			markBufferDirty(_.blendingtexture_fs);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.blendingtexture_fs, updateBlendingTextureBuffer);
			mapContext3DBuffer(_.terrainTextures_fs_array, updateTerrainTextureBuffer);
			mapContext3DBuffer(_.tile_fc_vector, updateTileDataBuffer);
		}

		private function updateTerrainTextureBuffer(terrainTextureBufferArr:FSArrayBuffer):void
		{
			terrainTextureBufferArr.update(splats);
		}

		private function updateTileDataBuffer(tileDataBuffer:FCVectorBuffer):void
		{
			tileDataBuffer.update(tileData);
		}

		private function updateBlendingTextureBuffer(nBlendingTextureBuffer:FSBuffer):void
		{
			nBlendingTextureBuffer.update(blendingTexture);
		}

		override arcane function activate(shaderParams:ShaderParams):void
		{
			super.activate(shaderParams);

			//通用渲染参数
			shaderParams.splatNum = _numSplattingLayers;

			shaderParams.addSampleFlags(_.texture_fs, texture, Context3DWrapMode.REPEAT);
			shaderParams.addSampleFlags(_.terrainTextures_fs_array, splats[0], Context3DWrapMode.REPEAT);
			shaderParams.addSampleFlags(_.blendingtexture_fs, blendingTexture);

			shaderParams.diffuseMethod = F_TerrainDiffusePostLighting;
		}
	}
}
