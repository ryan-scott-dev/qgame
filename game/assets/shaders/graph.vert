#version 100

uniform float transparency;
uniform float z_index;

uniform float x_min;
uniform float x_max;
uniform float y_min;
uniform float y_max;

uniform mat4 view;
uniform mat4 projection;

attribute vec2 vertex;

varying vec4 fragColor;
varying float fragTransparency;

void main()
{
	/* Clamp the vertex position between 0 and 1 */
	vec2 min = vec2(x_min, y_min);
	vec2 max = vec2(x_max, y_max);
	vec2 vertexLocal = (vertex - min) / (max - min);
	vertexLocal = vec2(vertexLocal.x * 2.0 - 1.0, vertexLocal.y* 2.0 - 1.0);

	mat4 position_mat = mat4(1.0);
	position_mat[3][2] = z_index;
	
	mat4 world = position_mat;

    fragColor         = vec4(1, 0, 0, 1);
    fragTransparency  = transparency;
    gl_Position       = view*(world*vec4(vertexLocal,0.0,1.0));
}
