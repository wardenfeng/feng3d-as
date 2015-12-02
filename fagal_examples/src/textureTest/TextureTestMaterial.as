package textureTest
{
	import base.BaseMaterial;

	import fagal.F_TextureTest;
	import fagal.V_TextureTest;

	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagalRE.FagalShaderResult;
	import me.feng3d.textures.TextureProxyBase;

	/**
	 * 颜色地形材质
	 * @author feng 2015-5-14
	 */
	public class TextureTestMaterial extends BaseMaterial
	{
		private var _texture:TextureProxyBase;

		public function TextureTestMaterial(texture:TextureProxyBase)
		{
			_texture = texture;
			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.texture_fs, updateTextureBuffer);
		}

		private function updateTextureBuffer(textureBuffer:FSBuffer):void
		{
			textureBuffer.update(_texture);
		}

		override protected function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			shaderParams.addSampleFlags(_.texture_fs, _texture);
			var result:FagalShaderResult = FagalRE.runShader(V_TextureTest, F_TextureTest);

			//上传程序
			programBuffer.update(result.vertexCode, result.fragmentCode);
		}
	}
}
