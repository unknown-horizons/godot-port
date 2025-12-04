shader_type canvas_item;
render_mode blend_mix;

uniform vec4 cannot_build_color: source_color = vec4(1.0, 0.0, 0.0, 1.0);

void vertex() {
	COLOR = cannot_build_color;
}
