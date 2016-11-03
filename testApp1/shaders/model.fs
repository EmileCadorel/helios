#version 330 core

uniform vec3 lightDir;
uniform sampler2D diffuse;

in vec3 vertexNormal;
in vec2 textureCoords;

out vec4 color;

void main() {
    vec4 diffuseColor = texture (diffuse, textureCoords);

    // Diffuse lighting
    float intensity = clamp(dot(normalize(vertexNormal), -lightDir), 0.0f, 1.0f);
	
    color = clamp((diffuseColor * intensity), 0.0f, 1.0f);
    //color = clamp(vertexNormal, 0.0f, 1.0f);
    //color = diffuseColor;
}
