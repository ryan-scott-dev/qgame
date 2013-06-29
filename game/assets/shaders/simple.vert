#version 100
precision mediump float;

attribute vec3 vert;
attribute vec2 vertTexCoord;

varying vec2 fragTexCoord;

uniform mat4 projection;
uniform mat4 view;

uniform vec2 position;
uniform float rotation;
uniform vec2 scale;
uniform vec2 offset;

void main() {
    fragTexCoord = vertTexCoord;

    float sr = sin(rotation);
    float cr = cos(rotation);

    mat4 offset_mat = mat4(1.0);
    offset_mat[3][0] = -offset.x;
    offset_mat[3][1] = -offset.y;

    mat4 scale_mat = mat4(1.0);
    scale_mat[0][0] = scale.x;
    scale_mat[1][1] = scale.y;

    mat4 rotation_mat = mat4(1.0);
    rotation_mat[0][0] = cr;
    rotation_mat[0][1] = sr;
    rotation_mat[1][0] = -sr;
    rotation_mat[1][1] = cr;

    mat4 position_mat = mat4(1.0);
    position_mat[3][0] = offset.x + position.x;
    position_mat[3][1] = offset.y + position.y;

    mat4 world = position_mat * rotation_mat * scale_mat * offset_mat;

    gl_Position = projection * view * world * vec4(vert, 1);
}