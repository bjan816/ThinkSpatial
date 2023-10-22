shader_type canvas_item;

uniform float rad = 1.0;
uniform sampler2D tx;


float c(vec2 uv, float r) {
  return step(length(uv-0.5), r);
}

void fragment() {
    COLOR.rgb = texture(tx, UV).rgb + 1.0;
    //COLOR.a *= 1.0 - c(UV, rad);
}
