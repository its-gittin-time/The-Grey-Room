shader_type canvas_item;
render_mode unshaded;

global uniform mat3 colour_matrix;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float colour_levels : hint_range(1,256,1) = 16.0;

vec3 linear_srgb_to_oklab(vec3 c) {
	float l = 0.4122214708f * c.r + 0.5363325363f * c.g + 0.0514459929f * c.b;
	float m = 0.2119034982f * c.r + 0.6806995451f * c.g + 0.1073969566f * c.b;
	float s = 0.0883024619f * c.r + 0.2817188376f * c.g + 0.6299787005f * c.b;

	float l_ = pow(l, 1.0/3.0);
	float m_ = pow(m, 1.0/3.0);
	float s_ = pow(s, 1.0/3.0);

	return vec3(
		0.2104542553f*l_ + 0.7936177850f*m_ - 0.0040720468f*s_,
		1.9779984951f*l_ - 2.4285922050f*m_ + 0.4505937099f*s_,
		0.0259040371f*l_ + 0.7827717662f*m_ - 0.8086757660f*s_);
}
vec3 oklab_to_linear_srgb(vec3 c) {
	float l_ = c.x + 0.3963377774f * c.y + 0.2158037573f * c.z;
	float m_ = c.x - 0.1055613458f * c.y - 0.0638541728f * c.z;
	float s_ = c.x - 0.0894841775f * c.y - 1.2914855480f * c.z;

	float l = l_*l_*l_;
	float m = m_*m_*m_;
	float s = s_*s_*s_;

	return vec3(
		+4.0767416621f * l - 3.3077115913f * m + 0.2309699292f * s,
		-1.2684380046f * l + 2.6097574011f * m - 0.3413193965f * s,
		-0.0041960863f * l - 0.7034186147f * m + 1.7076147010f * s);
}

vec3 srgb_to_linear(vec3 input) {
	vec3 output;
	if (input.r <= 0.04045) {
		output.r = input.r / 12.92;
	} else {
		output.r = pow((input.r + 0.055) / 1.055, 2.4);
	}
	if (input.g <= 0.04045) {
		output.g = input.g / 12.92;
	} else {
		output.g = pow((input.g + 0.055) / 1.055, 2.4);
	}
	if (input.b <= 0.04045) {
		output.b = input.b / 12.92;
	} else {
		output.b = pow((input.b + 0.055) / 1.055, 2.4);
	}
	return output;
}
vec3 linear_to_srgb(vec3 input) {
	vec3 output;
	if (input.r <= 0.0031308) {
		output.r = 12.92 * input.r;
	} else {
		output.r = (1.055 * pow(input.r, 1.0/2.4)) - 0.055;
	} if (input.g <= 0.0031308) {
		output.g = 12.92 * input.g;
	} else {
		output.g = (1.055 * pow(input.g, 1.0/2.4)) - 0.055;
	}  if (input.b <= 0.0031308) {
		output.b = 12.92 * input.b;
	} else {
		output.b = (1.055 * pow(input.b, 1.0/2.4)) - 0.055;
	}
	return output;
}
void fragment() {
	vec3 screen_colour = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	vec3 colour_blind = vec3(screen_colour * colour_matrix);
	COLOR.rgb = colour_blind;

	//vec3 oklab = linear_srgb_to_oklab(srgb_to_linear(colour_blind));
	//oklab.x = floor(oklab.x * colour_levels) / (colour_levels - 1.0);
	//float x = oklab_to_linear_srgb(oklab).x;
	//COLOR.rgb = linear_to_srgb(oklab_to_linear_srgb(oklab));
}
