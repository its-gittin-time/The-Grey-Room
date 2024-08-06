shader_type spatial;
render_mode depth_draw_always, unshaded;

global uniform sampler2D blue_noise : filter_nearest, source_color;

void fragment() {
	vec2 fun_uv = VIEWPORT_SIZE / vec2(textureSize(blue_noise, 0));
	float noise = texture(blue_noise, SCREEN_UV * fun_uv).r;
	noise = 0.0;
	if (noise > 0.3) {
		ALPHA = 0.0;
	} else {
		ALPHA = 1.0;
	}
	ALBEDO.rgb = texture(blue_noise, SCREEN_UV * fun_uv).rgb;
}