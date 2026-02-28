shader_type canvas_item;

uniform vec4 vignette_color: source_color;
uniform float transparency : hint_range(0.0, 1.0) = 1.0;
uniform float radius : hint_range(0.0, 5.0) = 1.0;

void fragment() {
	float x = abs(UV.x-.5)*2.0;
	float y = abs(UV.y-.5)*2.0;
	float v = (sqrt((x*x)+(y*y))/radius);
	COLOR = vec4(vignette_color.rgb,v*transparency);
}