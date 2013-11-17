#version 100

uniform mat4 world;
uniform mat4 view;
uniform mat4 projection;

uniform vec4 tint;

attribute vec3 vertex;
attribute vec2 tex_coord;
attribute vec4 color;

varying vec2 fragTexCoord;
varying vec4 textColor;

void main()
{
  fragTexCoord.xy   = tex_coord.xy;
  textColor         = color * tint;
  gl_Position       = projection*(view*(world*vec4(vertex,1.0)));
}
