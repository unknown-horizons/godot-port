shader_type canvas_item;

uniform float transparency = 0.5;
uniform float red = 0;
uniform float green = 1;
uniform float blue = 0;

//void set_matirial(transparency, red, green, blue) {
	//
//}

void vertex() {
	COLOR.a = transparency;
	COLOR.r = red;
	COLOR.g = green;
	COLOR.b = blue;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
