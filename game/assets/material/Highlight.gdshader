shader_type spatial;
render_mode unshaded,cull_front,depth_draw_never;

uniform float border = 0.03125;

void vertex() {
  VERTEX += VERTEX * border;
}
