shader_type spatial;
render_mode unshaded;
uniform sampler2D tx : source_color;

void fragment() {
  ALBEDO = texture(tx,SCREEN_UV).rgb;
}
