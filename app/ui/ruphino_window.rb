require 'glimmer-dsl-swt'

class RuphinoWindow
  include Glimmer

  DIAMETER  = 128
  ICON_PATH = File.expand_path('../../icons/ruphino.png', __dir__)

  def initialize
    @shell = build_shell
  end

  def open
    @shell.open
  end

  private

  def build_shell
    shell(:no_trim, :on_top) do |s|
      size DIAMETER, DIAMETER
      minimum_size DIAMETER, DIAMETER      
      background :transparent

      img = Image.new(s.swt_widget.display, ICON_PATH)
      region = build_region_from_png(img.get_image_data)

      label {
        image img
        enable_dragging
      }

      s.swt_widget.set_region region

      region.dispose
   end
  end

  def build_region_from_png(data)
    region = Region.new
    pixel  = Rectangle.new(0, 0, 1, 1)

    data.height.times do |y|
      data.width.times do |x|
        next unless data.get_alpha(x, y) > 0

        pixel.x = x 
        pixel.y = y
        region.add(pixel)
      end
    end

    region
  end

  def enable_dragging()
    on_mouse_down do |event|
      @drag_origin = [event.x, event.y]
    end

    on_mouse_up do |_event|
      @drag_origin = nil
    end

    on_mouse_move do |event|
      next unless @drag_origin

      p = event.display.map(event.widget, nil, event.x, event.y)
      @shell.swt_widget.setLocation(
        p.x - @drag_origin[0],
        p.y - @drag_origin[1]
      )
    end
  end
end
