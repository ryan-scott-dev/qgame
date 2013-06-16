#version 150

in vec3 vert;
in vec2 vertTexCoord;

out vec2 fragTexCoord;

uniform mat4 projection;

void main() {
    fragTexCoord = vertTexCoord;

    // does not alter the vertices at all
    gl_Position = projection * vec4(vert, 1);
}