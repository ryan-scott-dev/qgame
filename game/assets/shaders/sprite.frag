#version 100

uniform sampler2D tex;

varying mediump vec2 fragTexCoord;
varying lowp float fragTransparency;

void main(void) {
  gl_FragColor = texture2D(tex, fragTexCoord) * vec4(1, 1, 1, fragTransparency);
}