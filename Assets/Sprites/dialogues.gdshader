shader_type canvas_item;

uniform vec4 key_color1 : source_color = vec4(0.0, 1.0, 0.0, 1.0); // vert
uniform float tolerance : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float diff1 = distance(tex_color.rgb, key_color1.rgb);
    if (diff1 < tolerance) {
        tex_color.a = 0.0; // transparent
    }
    COLOR = tex_color;
}
