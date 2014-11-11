package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSArrayBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.fagal.TextureFlag;
	import me.feng3d.fagal.fragment.F_TerrainDiffusePostLighting;
	import me.feng3d.fagal.fragment.light.F_DiffusePostLighting;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 地形渲染函数
	 * @author warden_feng 2014-7-16
	 */
	public class TerrainDiffuseMethod extends BasicDiffuseMethod
	{
		private var _blendingTexture:Texture2DBase;
		private var _splats:Array;
		private var _numSplattingLayers:uint;
		private var _tileData:Vector.<Number>;

		protected var nBlendingTextureBuffer:FSBuffer;
		protected var terrainTextureBufferArr:FSArrayBuffer;

		protected var tileDataBuffer:FCVectorBuffer;

		public function TerrainDiffuseMethod(splatTextures:Array, blendingTexture:Texture2DBase, tileData:Array)
		{
			super(pass);

			splats = splatTextures;
			this.tileData = Vector.<Number>(tileData);
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
			terrainTextureBufferArr.invalid();
		}

		public function get tileData():Vector.<Number>
		{
			return _tileData;
		}

		public function set tileData(value:Vector.<Number>):void
		{
			_tileData = value;
			tileDataBuffer.invalid();
		}

		public function get blendingTexture():Texture2DBase
		{
			return _blendingTexture;
		}

		public function set blendingTexture(value:Texture2DBase):void
		{
			_blendingTexture = value;
			nBlendingTextureBuffer.invalid();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			nBlendingTextureBuffer = new FSBuffer(Context3DBufferTypeID.BLENDINGTEXTURE_FS, updateBlendingTextureBuffer);
			terrainTextureBufferArr = new FSArrayBuffer(Context3DBufferTypeID.TERRAINTEXTURES_FS, updateTerrainTextureBuffer);
			tileDataBuffer = new FCVectorBuffer(Context3DBufferTypeID.TILE_FC_VECTOR, updateTileDataBuffer);
		}

		private function updateTerrainTextureBuffer():void
		{
			terrainTextureBufferArr.update(splats);
		}

		private function updateTileDataBuffer():void
		{
			tileDataBuffer.update(tileData);
		}

		private function updateBlendingTextureBuffer():void
		{
			nBlendingTextureBuffer.update(blendingTexture);
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);
			context3dCache.addDataBuffer(nBlendingTextureBuffer);
			context3dCache.addDataBuffer(terrainTextureBufferArr);
			context3dCache.addDataBuffer(tileDataBuffer);
		}

		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);

			context3dCache.removeDataBuffer(nBlendingTextureBuffer);
			context3dCache.removeDataBuffer(terrainTextureBufferArr);
			context3dCache.removeDataBuffer(tileDataBuffer);
		}

		override arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy):void
		{
			super.activate(shaderParams, stage3DProxy);

			shaderParams.splatNum = _numSplattingLayers;

			shaderParams.addSampleFlags(Context3DBufferTypeID.TEXTURE_FS, texture, TextureFlag.MODE_WRAP);
			shaderParams.addSampleFlags(Context3DBufferTypeID.TERRAINTEXTURES_FS, splats[0], TextureFlag.MODE_WRAP);
			shaderParams.addSampleFlags(Context3DBufferTypeID.BLENDINGTEXTURE_FS, blendingTexture);
			
			shaderParams.diffuseMethod = F_TerrainDiffusePostLighting;
		}
	}
}
