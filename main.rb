require 'glimmer-dsl-libui'

include Glimmer

window('Ruphy Studio', 128, 128, has_border: false) {
  area {
    on_mouse_drag_started do |mouse| 
      p window
      # window.x = mouse[:x]
      # window.y = mouse[:y]
    end
  }
  on_closing do
    exit(0)
  end
}.show
