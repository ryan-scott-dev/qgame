#version 100

varying mediump vec4 fragColor;
varying lowp float fragTransparency;

void main()
{
    gl_FragColor = vec4(fragColor.rgb, fragColor.a*fragTransparency);
}
