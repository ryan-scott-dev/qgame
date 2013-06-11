#version 150

in vec3 vert;
in vec2 vertTexCoord;

out vec2 fragTexCoord;

void main() {
    fragTexCoord = vertTexCoord;

    // does not alter the vertices at all
    gl_Position = vec4(vert, 1);
}