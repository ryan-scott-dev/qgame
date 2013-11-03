#version 100

attribute vec3 vert;
attribute vec2 vertTexCoord;

varying vec2 fragTexCoord;

uniform mat4 projection;
uniform mat4 view;

uniform vec3 position;
uniform vec3 scale;
uniform vec3 rotation;

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

    mat4 x_rotation_mat = mat4(1.0);
    x_rotation_mat[1][1] = cos(rotation.x);
    x_rotation_mat[1][2] = sin(rotation.x);
    x_rotation_mat[2][1] = -sin(rotation.x);
    x_rotation_mat[2][2] = cos(rotation.x);

    mat4 y_rotation_mat = mat4(1.0);
    y_rotation_mat[0][0] = cos(rotation.y);
    y_rotation_mat[0][2] = -sin(rotation.y);
    y_rotation_mat[2][0] = sin(rotation.y);
    y_rotation_mat[2][2] = cos(rotation.y);

    mat4 z_rotation_mat = mat4(1.0);
    z_rotation_mat[0][0] = cos(rotation.z);
    z_rotation_mat[0][1] = sin(rotation.z);
    z_rotation_mat[1][0] = -sin(rotation.z);
    z_rotation_mat[1][1] = cos(rotation.z);

    mat4 rotation_mat = x_rotation_mat * y_rotation_mat * z_rotation_mat;

    mat4 world = position_mat * rotation_mat * scale_mat;
    gl_Position = projection * view * world * vec4(vert, 1);
}