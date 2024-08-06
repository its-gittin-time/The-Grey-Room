shader_type spatial;
render_mode depth_test_disabled, cull_front, unshaded;

uniform bool enabled = false;
global uniform vec4 outline_colour : source_color = vec4(1.0,1.0,1.0,1.0);
uniform float thickness = 1.0;
global uniform sampler2D blue_noise : source_color, filter_nearest;

void vertex() {
	if (enabled) {
		VERTEX *= 1.0 + (thickness / 20.0);
	}
}

float abssin(float x) {
	return ((sin(x) + 1.0) / 2.0);
}

void fragment() {
	if (enabled) {
		ALBEDO = outline_colour.rgb;
		//EMISSION = outline_colour.rgb;
		//ALPHA = step(abssin(((UV.y + (UV.x)) - TIME / 20.0) * 100.0), 0.5);
		ALPHA = outline_colour.a;
		vec2 screen_wrap_uv = VIEWPORT_SIZE / vec2(textureSize(blue_noise, 0));

		if (true) {
			screen_wrap_uv *= SCREEN_UV / 1.0;
			//screen_wrap_uv.y += TIME / 200.0;
			float noise = texture(blue_noise, screen_wrap_uv).r;
			if (noise < 0.4) {
				ALPHA = 0.6;
				//ALBEDO.rgb = vec3(0.8,0.8,0.8);
			} else {
				ALPHA = 0.4;
			}

			ALBEDO = vec3(1.0);
		} else {
			ALPHA = 0.0;
		}
	} else {
		ALPHA = 0.0;
	}
}