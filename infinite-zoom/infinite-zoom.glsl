uniform float uTime;
uniform float uFreq;
// 0.25 seems like the most reasonable value for this
uniform float uFadePct;

layout(location = 0) out vec4 fragColor;

// NOTE: Just for debugging
//layout(location = 1) out vec4 fragColorA;
//layout(location = 2) out vec4 fragColorB;

float getAlpha(float zoom) {
  return min( smoothstep(0., uFadePct, zoom),
              smoothstep(1., 1 - uFadePct, zoom)
  );
}

void main() {
  // uv for first zoom
  vec2 uvA = vUV.st;
  // Calculate zoom factor
  float zoomA = fract(-uTime * uFreq);
  // apply zoom
  uvA = (uvA - 0.5) * zoomA + 0.5;
  // Calculate fading based on zoom
  // Adjust these values to change the fade thresholds
  vec4 colorA = texture(sTD2DInputs[0], uvA);
  colorA *= getAlpha(zoomA);

  // Implement fading between the zoomed in texture and the original
  vec2 uvB = vUV.st;
  // calc zoomB as phase offset from zoomA by 50%
  float zoomB = fract(zoomA + 0.5);
  // apply zoom
  uvB = (uvB - 0.5) * zoomB + 0.5;
  // Start blending the original texture as the zoomed one fades out
  vec4 colorB = texture(sTD2DInputs[0], uvB);
  colorB *= getAlpha(zoomB);

  vec4 color = mix(colorA, colorB, 0.5);
  fragColor = TDOutputSwizzle(color);

  // NOTE: Just for debugging
  //fragColorA = TDOutputSwizzle(colorA);
  //fragColorB = TDOutputSwizzle(colorB);
}
