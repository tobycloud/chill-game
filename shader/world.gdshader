shader_type sky;
render_mode use_half_res_pass;

uniform vec4 skyColor:source_color;

void sky() {
	COLOR=skyColor.xyz;
}
