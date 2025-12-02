shader_type canvas_item;

//void vertex() {
  //// Called for every vertex the material is visible on.
//}

uniform bool is_hovered = false;
uniform bool is_active = false;

uniform vec4 glow_color : source_color = vec4(0.9765625, 1.0, 1.0, 0.3); // color of the glow
uniform float glow_radius: hint_range(0.0, 1.0) = 0.5;   // radius of the glow (0–1)
uniform float glow_softness: hint_range(0.0, 1.0) = 0.5; // edge softness (0–1)
//uniform float glow_strength = 1.5; // intensity multiplier

void fragment() {
  vec4 tex_color = texture(TEXTURE, UV); // Sample original texture
  vec4 final_color = tex_color;

  if (is_hovered) {
    vec2 uv_centered = UV - vec2(REGION_RECT[0]+REGION_RECT[2]/2.0, REGION_RECT[1]+REGION_RECT[3]/2.0); // UV center (0.5, 0.5 is center of texture)
    float dist = length(uv_centered) * 2.0 / REGION_RECT[2]; // Distance from center (normalized)

    // Soft circular gradient for glow
    float glow_alpha = 1.0 - smoothstep(glow_radius, glow_radius + glow_softness, dist);

    // Combine texture + glow (glow drawn "behind")
    vec4 glow_layer = vec4(glow_color.rgb, glow_alpha);

    vec4 top = tex_color;
    vec4 bottom = glow_layer;
    float result_alpha = top.a + bottom.a*(1.0 - top.a);
    // vec3 result_rgb = mix(bottom.rgb, top.rgb, top.a) / result_alpha;
    // vec3 result_rgb = mix(bottom.rgb, top.rgb, top.a);
    vec3 result_rgb = (top.rgb * top.a + bottom.rgb * bottom.a * (1.0 - top.a)) / result_alpha;
    final_color = vec4(result_rgb, result_alpha);

    // final_color = vec4(glow_alpha,1,1,1);
    // final_color = tex_color;
    if (dist > glow_radius + glow_softness) {
      // final_color = vec4(1,1,1,1);
      // final_color = vec4(glow_alpha,1,1,1);
      final_color = tex_color;
    }
  }


  COLOR = final_color;
}
