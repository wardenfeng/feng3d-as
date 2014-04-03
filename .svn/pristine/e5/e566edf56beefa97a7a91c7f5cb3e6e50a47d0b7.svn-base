package feng3d.core.render
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix3D;
	
	import feng3d.Feng3dData;
	import feng3d.ShaderProgram;
	import feng3d.cameras.Camera3D;
	import feng3d.core.Object3D;
	import feng3d.core.base.Geometry;
	import feng3d.entities.Mesh;

	/**
	 *
	 * @author warden_feng 2014-3-27
	 */
	public class Renderer
	{
		public var context3D:Context3D;

		public var camera:Camera3D;

		public function Renderer()
		{

		}

		public function render(_entityCollector:Vector.<Object3D>):void
		{
			for each (var obj3D:Mesh in _entityCollector)
			{
				renderObj(obj3D);
			}
		}

		public function renderObj(obj3D:Mesh):void
		{
			var bitmapTexture:TextureBase = obj3D.bitmapTexture.getTextureForContext3D(context3D);
			var shaderProgram:ShaderProgram = Feng3dData.shaderProgram;
			
			var terrainMesh:Geometry = obj3D.geometry;
			var modelViewProjection:Matrix3D = new Matrix3D();
			var sceneTransform:Matrix3D = obj3D.sceneTransform;
//			var projectionmatrix:Matrix3D = camera.projectionmatrix;
			var projectionmatrix:Matrix3D = camera.viewProjection;

			//顶点数据
			var vertexCount:uint = terrainMesh.rawPositionsBuffer.length / 3;
			var positionsBuffer:VertexBuffer3D = context3D.createVertexBuffer(vertexCount, 3);
			positionsBuffer.uploadFromVector(terrainMesh.rawPositionsBuffer, 0, vertexCount);
			//uv数据
			var uvsCount:uint = terrainMesh.rawUvBuffer.length / 2;
			var uvBuffer:VertexBuffer3D = context3D.createVertexBuffer(uvsCount, 2);
			uvBuffer.uploadFromVector(terrainMesh.rawUvBuffer, 0, uvsCount);
			//顶点索引
			var indexBuffer:IndexBuffer3D = context3D.createIndexBuffer(terrainMesh.rawIndexBuffer.length);
			indexBuffer.uploadFromVector(terrainMesh.rawIndexBuffer, 0, terrainMesh.rawIndexBuffer.length);


			context3D.setTextureAt(0, bitmapTexture);
			// simple textured shader
			context3D.setProgram(shaderProgram.shaderProgram1);
			// position
			context3D.setVertexBufferAt(0, positionsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			// tex coord
			context3D.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			// clear the matrix and append new angles
			modelViewProjection.identity();
			modelViewProjection.append(sceneTransform);
			modelViewProjection.append(projectionmatrix);
			// pass our matrix data to the shader program
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelViewProjection, true);
			context3D.drawTriangles(indexBuffer, 0, terrainMesh.indexBufferCount);
		}
	}
}
