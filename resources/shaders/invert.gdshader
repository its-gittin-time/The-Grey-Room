shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 screen_colour = textureLod(screen_texture, SCREEN_UV, 0.0);
	COLOR.rgb = vec3(1.0-screen_colour.r,1.0-screen_colour.g,1.0-screen_colour.b);
}