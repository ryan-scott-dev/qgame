#version 100

uniform sampler2D texture;

varying mediump vec2 fragTexCoord;
varying mediump vec4 textColor;

void main()
{
  mediump float a = texture2D(texture, fragTexCoord.xy).r;
  gl_FragColor = vec4(textColor.rgb, textColor.a * a);
}
