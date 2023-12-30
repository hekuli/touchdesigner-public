out vec4 fragColor;
uniform float uDamping;

vec2 RES = uTD2DInfos[0].res.xy;

vec4 offset(int xOffset, int yOffset) {
  vec2 pos = vec2(vUV.x + (float(xOffset) * RES.x),
                  vUV.y + (float(yOffset) * RES.y));

  return vec4(texture(sTD2DInputs[0], pos));
}

vec4 calcColor(vec4 prevColor) {
  // prev state in R-channel, two before in G-channel
  // current pixel 1 frame ago (same as input)
  // float d1 = prevColor.r;
  // current pixel 2 frames ago
  float d2 = prevColor.g;

  float left = offset(-1, 0).r;
  float right = offset(1, 0).r;
  float up = offset(0, 1).r;
  float down = offset(0, -1).r;

  float curr = texture(sTD2DInputs[1], vUV.st).r;
  curr += ( (left + right + up + down) / 2 - d2);
  curr *= uDamping;
  return vec4(curr, prevColor.r, 0., 0.);
}

void main() {
  vec4 prevColor = texture(sTD2DInputs[0], vUV.st);
  vec4 newColor = calcColor(prevColor);
  fragColor = TDOutputSwizzle(newColor);
}
