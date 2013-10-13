#version 100

uniform sampler2D tex;

varying mediump vec2 fragTexCoord;
varying lowp float fragTransparency;

void main(void) {
  mediump vec4 texel = texture2D(tex, fragTexCoord) * vec4(1, 1, 1, fragTransparency);
  if(texel.a < 0.5) {
    discard;
  }
  gl_FragColor = texel;
}