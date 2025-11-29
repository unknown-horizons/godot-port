shader_type canvas_item;

uniform float transparency = 0.5;
uniform float red = 0;
uniform float green = 1;
uniform float blue = 0;

void vertex() {
	COLOR.a = transparency;
	COLOR.r = red;
	COLOR.g = green;
	COLOR.b = blue;
}
