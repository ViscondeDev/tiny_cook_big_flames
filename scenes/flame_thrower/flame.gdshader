shader_type canvas_item;

uniform sampler2D noise1_texture;
uniform sampler2D noise2_texture;
uniform float fire_progress : hint_range(0.0, 1.0) = 0.0;
uniform float clean_progress : hint_range(0.0, 1.0) = 0.0;
uniform vec3 color1 : source_color;
uniform vec3 color2 : source_color;

void vertex() {}

float flameShape(float x) {
	return sqrt(1.0 - pow(x - 1.0, 2.0));
}

void fragment() {
	float dist = flameShape(UV.x);
	float vv = abs(UV.y * 2.0 - 1.0);
	if (vv > dist) discard;
	
	float v1 = texture(noise1_texture, UV).r;
	float v2 = texture(noise2_texture, UV).r;
	float val = v1 * v2;
	float x = pow(UV.x, 3.0 * fire_progress);
	float step1 = step(x - 0.1, val);
	float step2 = step(x, val);
	float cleanup_alpha = step(pow(1.0 - UV.x, 100.0 * (1.0 - clean_progress)), val);
	if (step2 > 0.5) {
		//COLOR = vec4(color2, step2);
		COLOR.rgb = color2;
		COLOR.a = min(cleanup_alpha, step2);
	} else {
		COLOR.rgb = color1;
		COLOR.a = min(cleanup_alpha, step1);
		//COLOR = vec4(color1, step1);
	}
	
	// beginning outline
	if (vv > dist - 0.05) {
		float alpha = min(step1, step2);
		alpha = min(alpha, cleanup_alpha);
		COLOR = vec4(color1, alpha);
	}
	
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
