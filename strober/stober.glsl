uniform float uTime;
uniform int uFadeType;
uniform float uFadeFreq;
uniform int uPulseType;
uniform float uPulseFreq;
uniform bool uBurstMode;
uniform bool uBurst;

out vec4 fragColor;

float calcValue(int type, float t, float freq) {
  switch (type) {
    // ramp
    case 1:
      return fract(t * freq);
    // square
    case 2:
      return step(0.5, fract(t * freq));
  }
  return sin(t * freq) * 0.5 + 0.5;
}

void main() {
  vec4 color = texture(sTD2DInputs[0], vUV.st);
  float fade;
  if (uBurstMode) {
    fade = float(uBurst);
  } else {
    fade = calcValue(uFadeType, uTime, uFadeFreq);
  }
  float pulse = calcValue(uPulseType, uTime, uPulseFreq);
  color *= fade * pulse;
  fragColor = TDOutputSwizzle(color);
}
