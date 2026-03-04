shader_type spatial;

uniform vec3 base_color = vec3(0.0);
uniform vec3 outline_color = vec3(1.0);

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment()
{
	float basic_fresnel = fresnel(7.0, NORMAL, VIEW);
	if(basic_fresnel < 0.1) {
		ALBEDO = base_color;
	} else {
		ALBEDO = outline_color;
	}
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
