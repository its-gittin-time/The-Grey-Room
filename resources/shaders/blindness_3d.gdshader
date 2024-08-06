shader_type spatial;
render_mode unshaded, skip_vertex_transform;

global uniform mat3 colour_matrix;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec3 screen_colour = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	ALBEDO = vec3(screen_colour * colour_matrix);
}
