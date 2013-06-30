#version 100

uniform sampler2D tex;

varying mediump vec2 fragTexCoord;

void main(void) {
  gl_FragColor = texture2D(tex, fragTexCoord);
}