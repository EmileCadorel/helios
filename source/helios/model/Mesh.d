module helios.model.Mesh;
import helios.system._;
import helios.model._;
import gfm.math, gfm.opengl, gfm.assimp;
import derelict.assimp3.assimp, std.conv, std.stdio, std.path;
import std.container;

class Mesh {
    
    private GLBuffer _modelVBO;
    private VertexSpecification!Vertex _modelVS;
    private GLVAO _vao;
    private static Assimp _assimp_ = null;
    private Texture _tex;
    private Array!(Vertex []) _faces;
    
    static this () {
	_assimp_ = new Assimp (null);
    }
    
    this (string src, Application context, VertexSpecification!Vertex binder) {
	this._vao = new GLVAO (context.openglContext);
	this._modelVS = binder;
	this.init (src, context);
    }

    this (Vertex [] model, Application context, VertexSpecification!Vertex binder) {
	this._vao = new GLVAO (context.openglContext);
	this._modelVS = binder;
	this._modelVBO = new GLBuffer (context.openglContext, GL_ARRAY_BUFFER, GL_STATIC_DRAW);
	this._modelVBO.setData (model);
	this._vao.bind ();
	this._modelVBO.bind ();
	this._modelVS.use ();
	this._vao.unbind ();
    }
    
    public void draw () {
	this._vao.bind ();
	glDrawArrays (GL_TRIANGLES, 0, cast(int)(this._modelVBO.size() / this._modelVS.vertexSize ()));
	this._vao.unbind ();
    }

    Array!(Vertex []) faces () {
	return this._faces;
    }    
    
    private void init (string src, Application context) {
	auto path = dirName (src);
	writeln(path);
	auto file = new AssimpScene (_assimp_, src, aiProcess_Triangulate);
	auto scene = file.scene ();
	auto mesh = scene.mMeshes [0];
	Vertex[] model;
	foreach (fidx ; 0 .. mesh.mNumFaces) {
	    auto face = mesh.mFaces [fidx];
	    this._faces.insertBack (Vertex[].init);
	    foreach (vidx ; 0 .. face.mNumIndices) {
		auto idx = face.mIndices [vidx];
		auto vertex = vec3f (mesh.mVertices [idx].x, mesh.mVertices[idx].y, mesh.mVertices [idx].z);
		vec3f normal = vertex;
		vec2f tex = vec2f (0, 0);
		if (mesh.mNormals !is null) normal = vec3f (mesh.mNormals [idx].x, mesh.mNormals [idx].y, mesh.mNormals [idx].z);
		if (mesh.mTextureCoords[0] !is null) tex = vec2f (mesh.mTextureCoords [0] [idx].x, 1 - mesh.mTextureCoords [0] [idx].y);

		model ~= Vertex (vertex, normal, tex);
		this._faces.back () ~= Vertex (vertex, normal, tex);
	    }
	}

	auto mat = scene.mMaterials [mesh.mMaterialIndex];
	if (aiGetMaterialTextureCount (mat, aiTextureType_DIFFUSE ) > 0) {
	    aiString name;
	    auto texture = aiGetMaterialTexture (mat, aiTextureType_DIFFUSE, 0, &name);
	    auto texName = path ~ "/" ~ to!string (name.data) [0 .. name.length];
	    this._tex = new Texture ("diffuse", texName, texName, context);
	}
	
	this._modelVBO = new GLBuffer (context.openglContext, GL_ARRAY_BUFFER, GL_STATIC_DRAW);
	this._modelVBO.setData (model);
	
	this._vao.bind ();
	this._modelVBO.bind ();
	this._modelVS.use ();
	this._vao.unbind ();		
    }
    
    ref Texture tex () {
	return this._tex;
    }
    
       
}
