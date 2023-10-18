shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform float size;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaleUV = (SCREEN_UV - vec2(0.5, 0.0))/vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size-0.1, size, length(scaleUV - center))) * smoothstep(size-0.45, size-0.1, length(scaleUV - center));
	vec2 disp = normalize(scaleUV - center) * force * mask;
	
	//COLOR = vec4(SCREEN_UV - disp, 0.0, 1.0);
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
	//COLOR.rgb = vec3(mask);
}