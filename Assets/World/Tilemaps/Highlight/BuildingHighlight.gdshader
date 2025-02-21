shader_type canvas_item;

uniform vec4 can_build_color : source_color = vec4(1.0);
uniform vec4 cannot_build_color : source_color = vec4(1.0);
uniform bool can_build = true;
uniform bool should_show = false;

void vertex() {
  if (should_show){
    if (can_build){
      COLOR = can_build_color;
    }
    else {
      COLOR = cannot_build_color;
    }
  }
}