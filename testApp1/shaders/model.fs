#version 450 core

uniform vec3 lightDir;
uniform sampler2D diffuse;
uniform vec3 eyePos;
uniform vec3 lightPos;
uniform vec3 ambiant;

in vec3 vertexNormal;
in vec2 textureCoords;
in vec3 vecPos;

out vec4 color;

vec4 toVec4 (float x) {
    return vec4 (x, x, x, x);
}

vec4 pointLight(vec3 pos, vec3 normal, vec3 lightPos, vec3 diffuse, vec3 ambiant, vec3 eyePos) {
	vec3 lightVec = pos - lightPos;
	float d = length (lightVec);
	lightVec = lightVec / d;
	
	vec3 spec = vec3 (0, 0, 0);
	vec3 resDiff = spec;
	vec3 reflection;
	
	
	float lightInten = clamp(dot(normal, lightVec), 0.0f, 1.0f);

	if(lightInten > 0.0) {
	    resDiff = diffuse * lightInten * 4;
	    resDiff = clamp(resDiff, 0.0, 1.0);	    
	}
	
	return vec4(ambiant + resDiff, 1.0);

}

void main() {
    vec4 tex = texture (diffuse, textureCoords);
    vec3 gamma = vec3(0.7 / 1.0);	
    color = (vec4 (ambiant, 1.0) + pointLight (vecPos, vertexNormal, lightPos, vec3 (1, 1, 1), vec3 (0.0, 0.0, 0.0), eyePos)) * tex;
    color = vec4 (pow (color.xyz, gamma), 1.0);
}
