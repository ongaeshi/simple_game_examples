module Pico
  SCREEN_WIDTH = 128
  SCREEN_HEIGHT = 128

  def mainloop(title, scale = 3)
    Raylib::window(SCREEN_WIDTH * scale, SCREEN_HEIGHT * scale, title) do
      Raylib::set_target_fps(30)

      target = Raylib::load_render_texture(SCREEN_WIDTH, SCREEN_HEIGHT)

      init()

      until Raylib::window_should_close
        # Update
        update()

        # Draw
        Raylib::draw do
          Raylib::texture_mode(target) do
            draw()
          end

          Raylib::draw_texture_pro(
            target.texture,
            Raylib::Rectangle.init(
              0.0,
              0.0,
              target.texture.width,
              -target.texture.height
            ),
            Raylib::Rectangle.init(
              (Raylib::get_screen_width() - SCREEN_WIDTH * scale) * 0.5,
              (Raylib::get_screen_height() - SCREEN_HEIGHT * scale) * 0.5,
              SCREEN_WIDTH * scale,
              SCREEN_HEIGHT * scale
            ),
            Raylib::Vector2.init(0, 0),
            0.0,
            Raylib::WHITE
          )
        end
      end
    end
  end
end
