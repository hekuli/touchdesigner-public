out vec4 fragColor;

// Extracts out the values from the R-channel, and applies them equally across GB channels.
// b/c the prev GLSL top uses both R and G channels as separate data storage buffers.
// Alpha remains the same.
void main() {
  vec4 c = texture(sTD2DInputs[0], vUV.st);
  vec4 newC = vec4(vec3(c.r), c.a);
  fragColor = TDOutputSwizzle(newC);
}
