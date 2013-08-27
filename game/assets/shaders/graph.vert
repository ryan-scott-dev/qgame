#version 100

uniform float transparency;
uniform float z_index;

uniform mat4 view;
uniform mat4 projection;

attribute vec2 vertex;

varying vec4 fragColor;
varying float fragTransparency;

void main()
{
	mat4 position_mat = mat4(1.0);
	position_mat[3][2] = z_index;
	
	mat4 world = position_mat;

    fragColor         = vec4(1, 1, 1, 1);
    fragTransparency  = transparency;
    gl_Position       = projection*(view*(world*vec4(vertex,0.0,1.0)));
}
