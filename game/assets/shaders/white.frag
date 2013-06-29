#version 100
precision mediump float;

varying vec2 fragTexCoord;

uniform sampler2D tex;

void main() {
  gl_FragColor = texture2D(tex, fragTexCoord);
}