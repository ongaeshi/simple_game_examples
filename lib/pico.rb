module Pico
  SCREEN_WIDTH = 128
  SCREEN_HEIGHT = 128
  SPRITE_SIZE = 8

  COLORS = [
    Raylib::Color.init(0, 0, 0, 255), # black
    Raylib::Color.init(29, 43, 83, 255), # dark-blue
    Raylib::Color.init(126, 37, 83, 255), # dark-purple
    Raylib::Color.init(0, 135, 81, 255), # dark-green
    Raylib::Color.init(171, 82, 54, 255), # brown
    Raylib::Color.init(95, 87, 79, 255), # dark-gray
    Raylib::Color.init(194, 195, 199, 255), # light-gray
    Raylib::Color.init(255, 241, 232, 255), # white
    Raylib::Color.init(255, 0, 77, 255), # red
    Raylib::Color.init(255, 163, 0, 255), # orange
    Raylib::Color.init(255, 236, 39, 255), # yellow
    Raylib::Color.init(0, 228, 54, 255), # green
    Raylib::Color.init(41, 173, 255, 255), # blue
    Raylib::Color.init(131, 118, 156, 255), # indigo
    Raylib::Color.init(255, 119, 168, 255), # pink
    Raylib::Color.init(255, 204, 170, 255),  # peach
  ]

  @@spritesheet = nil

  def cls(col = 0)
    Raylib::clear_background(COLORS[col])
    # slower patch: https://github.com/raysan5/raylib/issues/922
    Raylib::draw_sphere(Raylib::Vector3.init(0, 0, 0), 0, Raylib::WHITE)
  end

  module_function :cls

  def rectfill(x0, y0, x1, y1, col = 0)
    Raylib::draw_rectangle(x0, y0, x1, y1, COLORS[col])
  end

  module_function :rectfill

  def print(str, x, y, col = 0)
    Raylib::draw_text(str, x, y, 8, COLORS[col])
  end

  module_function :print

  def spr(n, x, y, w = 1.0, h = 1.0, flip_x = false, flip_y = false)
    s = SPRITE_SIZE
    ss = SCREEN_WIDTH / SPRITE_SIZE
    Raylib::draw_texture_rec(
      @@spritesheet,
      Raylib::Rectangle.init((n % ss) * s, (n / ss).to_i * s, s * w, s * h),
      Raylib::Vector2.init(x, y),
      Raylib::WHITE
    )
  end

  module_function :spr

  BTN_KEY = [
    Raylib::KEY_LEFT,
    Raylib::KEY_RIGHT,
    Raylib::KEY_UP,
    Raylib::KEY_DOWN,
    Raylib::KEY_Z,
    Raylib::KEY_X,
  ]

  def btn(i = 0, p = 0)
    return false if i >= BTN_KEY.length

    Raylib::is_key_down(BTN_KEY[i]) ||
    game_pad_key_down(i, p)
  end
  
  module_function :btn

  def game_pad_key_down(i, p)
    ANALOG_THRESHOLD = 0.5

    case i
    when 0
      Raylib::get_gamepad_axis_movement(0, 1) < -ANALOG_THRESHOLD
    when 1
      Raylib::get_gamepad_axis_movement(0, 1) > ANALOG_THRESHOLD
    when 2
      Raylib::get_gamepad_axis_movement(0, 2) < -ANALOG_THRESHOLD
    when 3
      Raylib::get_gamepad_axis_movement(0, 2) > ANALOG_THRESHOLD
    when 4
      Raylib::is_gamepad_button_down(0, 17)
    when 5
      Raylib::is_gamepad_button_down(0, 16)
    end
  end

  def pausebtn(p = 0)
    Raylib::is_key_down(Raylib::KEY_ENTER) ||
    Raylib::is_key_down(Raylib::KEY_ESCAPE) ||
    Raylib::is_gamepad_button_down(0, 10)
  end


  def circfill(x, y, r = 4, col = 0)
    Raylib::draw_circle(x, y, r, COLORS[col])
  end

  module_function :circfill

  def rnd(max = 1.0)
    Math::rand * max
  end

  module_function :rnd

  def sqrt(num)
    Math.sqrt(num)
  end

  module_function :sqrt

  def abs(num)
    num.abs
  end

  module_function :abs

  def flr(num)
    num.floor
  end

  module_function :flr

  def line(x0, y0, x1, y1, col = 7)
    Raylib::draw_line(x0, y0, x1, y1, COLORS[col]);
  end

  module_function :line

  def run(scene, title, scale = 3)
    Raylib::window(SCREEN_WIDTH * scale, SCREEN_HEIGHT * scale, title) do
      Raylib::set_target_fps(30)

      target = Raylib::load_render_texture(SCREEN_WIDTH, SCREEN_HEIGHT)
      @@spritesheet = Raylib::load_texture("resource/spritesheet.png")

      until Raylib::window_should_close
        # Update
        scene.update()

        # Draw
        Raylib::draw do
          Raylib::texture_mode(target) do
            scene.draw()
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

  module_function :run
end
