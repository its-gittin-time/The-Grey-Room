shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
global uniform mat3 colour_matrix;
//const mat3 colour_matrix = mat3(
/*	vec3(0.152286,1.052583,-0.204868),
	vec3(0.114503,0.786281,0.099216),
	vec3(-0.003882,-0.048116,1.051998)
);
*/
//uniform float colour_levels : hint_range(1,256,1) = 16.0;
void fragment() {
	vec4 screen_colour = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec4 colour_blind = vec4(vec3(screen_colour.rgb * colour_matrix), 1.0);
	COLOR = colour_blind;//colour_blind;
}
