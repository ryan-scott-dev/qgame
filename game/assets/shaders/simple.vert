#version 100

attribute vec3 vert;
attribute vec2 vertTexCoord;

varying vec2 fragTexCoord;

uniform mat4 projection;
uniform mat4 view;

uniform vec3 position;
uniform vec3 scale;

void main() {
    fragTexCoord = vertTexCoord;

    mat4 scale_mat = mat4(1.0);
    scale_mat[0][0] = scale.x;
    scale_mat[1][1] = scale.y;
    scale_mat[2][2] = scale.z;

    mat4 position_mat = mat4(1.0);
    position_mat[3][0] = position.x;
    position_mat[3][1] = position.y;
    position_mat[3][2] = position.z;
    
    mat4 world = position_mat * scale_mat;
    gl_Position = view * world * vec4(vert, 1);
}