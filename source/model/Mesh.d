module model.Mesh;
import system.Shader;
import model.Vertex;
import gfm.math, gfm.opengl, gfm.assimp;


class Mesh {
    
    private GLBuffer _modelVBO;
    private VertexSpecification!Vertex _modelVS;
    private GLVAO _vao;
    private static Assimp _assimp_ = null;
   
    static this () {
	_assimp_ = new Assimp (null);
    }

    
    this (string src, OpenGL context, VertexSpecification!Vertex binder) {
	this._vao = new GLVAO (context);
	this._modelVS = binder;
	this.init (src, context);
    }

    public void draw () {
	this._vao.bind ();
	glDrawArrays (GL_TRIANGLES, 0, cast(int)(this._modelVBO.size() / this._modelVS.vertexSize ()));
	this._vao.unbind ();
    }
    
    private void init (string src, OpenGL context) {
	auto file = new AssimpScene (_assimp_, src, aiProcess_Triangulate);
	auto scene = file.scene ();
	auto mesh = scene.mMeshes [0];
	Vertex[] model;
	foreach (fidx ; 0 .. mesh.mNumFaces) {
	    auto face = mesh.mFaces [fidx];
	    foreach (vidx ; 0 .. face.mNumIndices) {
		auto idx = face.mIndices [vidx];
		auto vertex = mesh.mVertices [idx];
		if (mesh.mNormals !is null) {
		    auto normal = mesh.mNormals [idx];
		
		    model ~= Vertex (vec3f (vertex.x, vertex.y, vertex.z),
				     vec3f (normal.x, normal.y, normal.z));
		} else {
		    model ~= Vertex (vec3f (vertex.x, vertex.y, vertex.z),
				     vec3f (vertex.x, vertex.y, vertex.z));
		}
	    }
	}
	
	this._modelVBO = new GLBuffer (context, GL_ARRAY_BUFFER, GL_STATIC_DRAW);
	this._modelVBO.setData (model);
	
	this._vao.bind ();
	this._modelVBO.bind ();
	this._modelVS.use ();
	this._vao.unbind ();		
    }
    
    
       
}
