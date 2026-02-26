require 'glimmer-dsl-libui'

include Glimmer

window('Ruphy Studio', 128, 128) {
  borderless true
  resizable false

  area { 
    on_draw do |area_draw_params|
      image(File.expand_path('icons/ruphino.png', __dir__), 128, 128){
      on_click do 
        puts 'Hey!'
      end
      }
    end
  }
}.show
