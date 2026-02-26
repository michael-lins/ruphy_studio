require 'glimmer-dsl-swt'

class BorderlessApp
  include Glimmer

  def launch
    shell(:no_trim) { # <--- HERE: :no_trim makes it borderless
      text 'Borderless Window'
      background :black
      
      # Add components here (e.g., a button to close)
      button {
        text 'Quit'
        on_widget_selected {
          exit
        }
      }
    }.open
  end
end

BorderlessApp.new.launch

