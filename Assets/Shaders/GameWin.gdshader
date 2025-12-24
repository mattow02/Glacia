shader_type canvas_item;

// Cette variable permet de régler la force du flou dans l'inspecteur
// On la limite entre 0.0 (pas de flou) et 5.0 (très flou)
uniform float force_du_flou : hint_range(0.0, 5.0) = 2.5;

// On récupère la texture de l'écran
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // On lit la texture de l'écran à un niveau de détail (LOD) différent
    // Plus le niveau est élevé, plus c'est flou.
    vec4 couleur_ecran = textureLod(screen_texture, SCREEN_UV, force_du_flou);

    // On applique cette couleur floutée à notre ColorRect
    COLOR = couleur_ecran;
}