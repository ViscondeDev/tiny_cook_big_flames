shader_type canvas_item;

uniform sampler2D image_texture : filter_nearest;
uniform sampler2D heatmap_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(image_texture, UV);
	
	vec4 heatmap_color = texture(heatmap_texture, UV);
	if (heatmap_color.a > .0f) {
		COLOR.r += 1.0 - heatmap_color.r;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
