shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec2 mouse_position;

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV, 0.0);

		float distance_to_mouse = distance(SCREEN_UV / SCREEN_PIXEL_SIZE, mouse_position / SCREEN_PIXEL_SIZE);

		if (distance_to_mouse > 150.0) {
			if(distance_to_mouse < 170.0) {
				color.a *= 1.0 - (distance_to_mouse - 150.0) / 20.0;
			} else {
				color.a = 0.0;
			}
		}

		COLOR = color;
}
