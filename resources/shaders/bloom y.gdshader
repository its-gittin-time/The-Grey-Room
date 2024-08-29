shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 direction = vec2(0.0,5.0);
	vec3 sum = vec3(0.0);
	vec2 off1 = vec2(1.3846153846) * direction;
	vec2 off2 = vec2(3.2307692308) * direction;
	sum += textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	sum += texture(screen_texture, SCREEN_UV + (off1 / resolution)).rgb * 0.35294117647058826;
	sum += texture(screen_texture, SCREEN_UV - (off1 / resolution)).rgb * 0.35294117647058826;
	sum += texture(screen_texture, SCREEN_UV - (off2 / resolution)).rgb * 0.0702702703;
	sum += texture(screen_texture, SCREEN_UV - (off2 / resolution)).rgb * 0.0702702703;
	COLOR.rgb = sum;
}