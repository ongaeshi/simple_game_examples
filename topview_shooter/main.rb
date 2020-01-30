require "../lib/raylib"
include Raylib

SCREEN_WIDTH = 128
SCREEN_HEIGHT = 128

window(SCREEN_WIDTH, SCREEN_HEIGHT, "topview_shooter") do
	set_target_fps(60)

	until window_should_close do
		# Update
		# TODO: Update your variables here

		# Draw
		draw do
			clear_background(RAYWHITE)
			draw_text("Hello, World!", 190, 200, 20, LIGHTGRAY);
		end
	end
end
