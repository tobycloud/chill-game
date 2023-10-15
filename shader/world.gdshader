shader_type sky;
render_mode use_half_res_pass;

uniform vec4 skyColor:source_color = vec4(0.5, 0.8, 1.0, 1.0);

void sky() {
	COLOR=skyColor.xyz;
}
