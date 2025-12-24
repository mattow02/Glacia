shader_type canvas_item;

// On garde radius, c'est parfait pour votre Tween
uniform float radius : hint_range(0.0, 10.0) = 0.0;

void fragment() {
    // On utilise TEXTURE au lieu de my_tex pour récupérer l'image du Sprite
    vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
    vec4 col = vec4(0.0);
    float count = 0.0;

    // Boucle de flou
    for (float x = -radius; x <= radius; x++) {
        for (float y = -radius; y <= radius; y++) {
            // On récupère la couleur de l'image du sprite (TEXTURE)
            col += texture(TEXTURE, UV + vec2(x, y) * pixel_size);
            count++;
        }
    }

    COLOR = col / count;
}