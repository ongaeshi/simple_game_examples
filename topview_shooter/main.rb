require "../lib/raylib"
include Raylib

SCREEN_WIDTH = 128
SCREEN_HEIGHT = 128
SCALE = 3

window(SCREEN_WIDTH * SCALE, SCREEN_HEIGHT * SCALE, "topview_shooter") do
  set_target_fps(30)

	target = load_render_texture(SCREEN_WIDTH, SCREEN_HEIGHT)
	
	x = 0

  until window_should_close
    # Update
    # TODO: Update your variables here
		x += 1
		x = -80 if x > 150

    # Draw
    draw do
			texture_mode(target) do
				clear_background(Color.init(194, 195, 199, 255))
				
				(0...16).each do |i|
					(0...16).each do |j|
						if i % 2 == 0 || j % 2 == 0
							draw_rectangle(i*8, j*8, 8, 8, Color.init(29, 43, 83, 255))
						end
					end
				end

				draw_text("Hello, World!", x, SCREEN_HEIGHT*0.5-5, 10, Color.init(255, 163, 0, 255))
      end

      draw_texture_pro(
        target.texture,
        Rectangle.init(
          0.0,
          0.0,
          target.texture.width,
          -target.texture.height
        ),
        Rectangle.init(
          (get_screen_width() - SCREEN_WIDTH * SCALE) * 0.5,
          (get_screen_height() - SCREEN_HEIGHT * SCALE) * 0.5,
          SCREEN_WIDTH * SCALE,
          SCREEN_HEIGHT * SCALE
        ),
        Vector2.init(0, 0),
        0.0,
        WHITE
      )
    end
  end
end
