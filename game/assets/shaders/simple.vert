#version 150

in vec3 vert;
in vec2 vertTexCoord;

out vec2 fragTexCoord;

uniform mat4 projection;
uniform vec2 position;
uniform vec2 scale;

void main() {
    fragTexCoord = vertTexCoord;

    mat4 world = mat4(1.0);
    world[0][0] = scale.x;
    world[1][1] = scale.y;
    world[3][0] = position.x;
    world[3][1] = position.y;

    gl_Position = projection * world * vec4(vert, 1);
}