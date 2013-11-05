#version 100

attribute vec3 vert;
attribute vec2 vertTexCoord;

varying vec2 fragTexCoord;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 world;

void main() {
    fragTexCoord = vertTexCoord;

    gl_Position = projection * view * world * vec4(vert, 1);
}