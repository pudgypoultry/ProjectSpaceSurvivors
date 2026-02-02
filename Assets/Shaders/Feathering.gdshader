shader_type spatial;
render_mode unshaded;
// Renders a tileable 2D texture to screen, using spatial polygons as a mask.
// Remove blur from textures by unchecking "Detect 3D" and "Filter" in Import.
// Demo: https://github.com/DeerTears/Polygon-Mask-for-2D-Textures/

uniform sampler2D tiling_texture;
uniform vec3 albedo : source_color;
uniform float albedo_weight = 0.0;
uniform float tiling_scale = 1.0;
uniform float move_speed = 1.0;
uniform float uv_offset;
uniform float x_offset;
uniform float y_offset;
uniform float rotation_amount;
uniform float frequency;
uniform float amplitude;

const float DEFAULT_SCALE = 8.0;

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
			vec2(cos(angle), sin(angle)));
    
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

void vertex() {
	
}

void fragment() {
	vec2 uv = FRAGCOORD.xy;
	uv.x += x_offset;
	uv.y += y_offset;
	
	vec2 flat_right_vector = vec2(MODEL_MATRIX[0].x, MODEL_MATRIX[0].z);
	float object_rotation_y = atan(flat_right_vector.y, flat_right_vector.x);
	uv.x += sin(UV.y * frequency + TIME * move_speed) * amplitude;
	vec2 rotated_uv = rotate(uv, vec2(0.5), object_rotation_y + rotation_amount);
	
	vec2 tiling_uv = rotated_uv / (DEFAULT_SCALE * tiling_scale * -1.0) + uv_offset;
	vec4 texture_result = texture(tiling_texture, tiling_uv);
	//vec2 rotated_uv = rotate(uv, vec2(0.5), rotation_amount*TIME);
	ALBEDO = mix(albedo, texture_result.rgb, albedo_weight);
	ALPHA = texture_result.a;
}