shader_type canvas_item;

uniform float transparency = 0.5;

void vertex() {
	//VERTEX += vec2(cos(TIME)*10.0, sin(TIME)*10.0);
	COLOR.a = transparency;
}

void fragment(){
  //COLOR.a = 0;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
