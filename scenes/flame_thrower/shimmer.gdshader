shader_type canvas_item;

uniform sampler2D shimmer_texture;
uniform sampler2D screen_texture : hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 displacement = texture(shimmer_texture, SCREEN_UV).rgb;
	vec2 screen_displacement = displacement.xy * 2.0 - 1.0;
	COLOR = texture(screen_texture, SCREEN_UV + screen_displacement / 60.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
