#version 100

/* =========================================================================
 * Freetype GL - A C OpenGL Freetype engine
 * Platform:    Any
 * WWW:         http://code.google.com/p/freetype-gl/
 * -------------------------------------------------------------------------
 * Copyright 2011 Nicolas P. Rougier. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY NICOLAS P. ROUGIER ''AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL NICOLAS P. ROUGIER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of Nicolas P. Rougier.
 * ========================================================================= */
uniform vec2 position;
uniform float rotation;
uniform vec2 offset;
uniform float transparency;
uniform float z_index;

uniform mat4 view;
uniform mat4 projection;

attribute vec3 vertex;
attribute vec2 tex_coord;
attribute vec4 color;

varying vec2 fragTexCoord;
varying vec4 textColor;
varying float fragTransparency;

void main()
{
	float sr = sin(rotation);
	float cr = cos(rotation);

	mat4 offset_mat = mat4(1.0);
	offset_mat[3][0] = -offset.x;
	offset_mat[3][1] = -offset.y;

	mat4 rotation_mat = mat4(1.0);
	rotation_mat[0][0] = cr;
	rotation_mat[0][1] = sr;
	rotation_mat[1][0] = -sr;
	rotation_mat[1][1] = cr;

	mat4 position_mat = mat4(1.0);
	position_mat[3][0] = offset.x + position.x;
	position_mat[3][1] = offset.y + position.y;
	position_mat[3][2] = z_index;
	
	mat4 world = position_mat * rotation_mat * offset_mat;

    fragTexCoord.xy   = tex_coord.xy;
    textColor         = color;
    fragTransparency  = transparency;
    gl_Position       = projection*(view*(world*vec4(vertex,1.0)));
}
