shader_type canvas_item;

uniform sampler2D image_texture : filter_nearest;
uniform sampler2D cooked_variant : filter_nearest;
uniform sampler2D heatmap_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 original_color = texture(image_texture, UV);
	vec4 cooked_color = texture(cooked_variant, UV);
	vec4 heatmap_color = texture(heatmap_texture, UV);
	
	COLOR = mix(cooked_color, original_color, heatmap_color.r);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
