#version 100

uniform sampler2D tex;

varying mediump vec2 fragTexCoord;
varying lowp float fragTransparency;

void main(void) {
  mediump vec4 texel = texture2D(tex, fragTexCoord);
  gl_FragColor = vec4(1, 0, 1, 1);
}