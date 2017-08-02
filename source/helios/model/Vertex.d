module helios.model.Vertex;
import gfm.opengl, gfm.math;

struct Vertex {
    vec3f position;
    vec3f normal;
    vec2f texcoord;
}

struct Vertex2D {
    vec3f position;
    vec2f texcoord;
}
