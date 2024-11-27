shader_type canvas_item;
uniform float Switch = 0;



void fragment() {
	COLOR = mix(vec4(0.0),vec4(0.0,0.8,0.0,0.5),Switch);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
