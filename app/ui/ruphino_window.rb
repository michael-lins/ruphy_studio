require 'glimmer-dsl-swt'
require 'shellwords'
require 'fileutils'

class RuphinoWindow
  include Glimmer

  DIAMETER   = 128
  ICON_PATH  = File.expand_path('../../icons/ruphino.png', __dir__)
  BTN_WIDTH  = 130
  BTN_HEIGHT = 34
  BTN_GAP    = 20

  def initialize
    @menu_visible  = false
    @close_pending = false
    @shell         = build_shell
    @menu_shells   = build_menu_shells
  end

  def start
    @shell.open
  end

  private

  def build_shell
    shell(:no_trim, :on_top) do |s|
      size DIAMETER, DIAMETER
      minimum_size DIAMETER, DIAMETER
      background :transparent

      img    = Image.new(s.swt_widget.display, ICON_PATH)
      region = build_region_from_png(img.get_image_data)

      label {
        image img
        enable_interactions
      }

      s.swt_widget.set_region region
      region.dispose
    end
  end

  def build_menu_shells
    [
      { text: 'Create Project', action: -> { create_project } },
      { text: 'Open Project',   action: -> { puts 'Open Project'   } }
    ].map do |item|
      shell(:no_trim, :on_top) {
        minimum_size BTN_WIDTH, BTN_HEIGHT

        label {
          text      item[:text]
          alignment :center
          foreground :white
          background rgb(45, 45, 45)
          bounds 0, 0, BTN_WIDTH, BTN_HEIGHT

          on_mouse_up {
            item[:action].call
            hide_menu
          }
        }

        on_shell_deactivated { schedule_menu_close }
        on_shell_activated   { @close_pending = false }
      }
    end
  end

  # ── Task 3: Create project ────────────────────────────────────────────────

  def create_project
    dir_dialog = org.eclipse.swt.widgets.DirectoryDialog.new(@shell.swt_widget)
    dir_dialog.setText('Select parent folder')
    parent_dir = dir_dialog.open
    return unless parent_dir

    project_name = ask_project_name
    return unless project_name

    project_dir = File.join(parent_dir, project_name)

    puts "→ rails new #{project_name}"
    unless system("cd #{Shellwords.escape(parent_dir)} && rails new #{project_name}")
      puts '✗ rails new failed'
      return
    end

    inject_ruphino(project_dir)

    server_cmd = File.exist?(File.join(project_dir, 'bin', 'dev')) ? 'bin/dev' : 'rails server'
    puts "→ starting #{server_cmd}"
    Thread.new { system("cd #{Shellwords.escape(project_dir)} && #{server_cmd}") }

    @shell.swt_widget.display.timerExec(5000, -> { open_browser('http://localhost:3000') })
  end

  def ask_project_name
    result = [nil]
    d = nil
    d = shell(:dialog_trim, :application_modal) {
      text 'New Project'
      size 300, 130

      label { bounds 10, 10, 280, 20; text 'Project name:' }
      name_field = text { bounds 10, 35, 280, 25 }
      button {
        text 'Create'
        bounds 110, 75, 80, 30
        on_widget_selected {
          result[0] = name_field.swt_widget.getText.strip
          d.swt_widget.close
        }
      }
    }
    d.open

    display = @shell.swt_widget.display
    until d.swt_widget.isDisposed
      display.sleep unless display.readAndDispatch
    end

    result[0].to_s.empty? ? nil : result[0]
  end

  # ── Task 5: Inject Ruphino into Rails app ────────────────────────────────

  RUPHINO_PARTIAL = <<~ERB
    <% if Rails.env.development? %>
      <div id="ruphino"
           style="position:fixed;top:20px;left:20px;z-index:9999;cursor:grab;user-select:none;">
        <%= image_tag 'ruphino.png', width: 64, height: 64, alt: 'Ruphino' %>
      </div>
      <script>
        (function () {
          const el = document.getElementById('ruphino');
          let dragging = false, ox = 0, oy = 0, moved = false;

          el.addEventListener('mousedown', function (e) {
            dragging = true; moved = false;
            ox = e.clientX - el.offsetLeft;
            oy = e.clientY - el.offsetTop;
            el.style.cursor = 'grabbing';
            e.preventDefault();
          });

          document.addEventListener('mousemove', function (e) {
            if (!dragging) return;
            moved = true;
            el.style.left = (e.clientX - ox) + 'px';
            el.style.top  = (e.clientY - oy) + 'px';
          });

          document.addEventListener('mouseup', function () {
            dragging = false;
            el.style.cursor = 'grab';
          });

          el.addEventListener('click', function () {
            if (!moved) console.log('Ruphino clicked');
          });
        })();
      </script>
    <% end %>
  ERB

  RUPHY_CONTROLLER = <<~RUBY
    class RuphyController < ApplicationController
      def index
      end
    end
  RUBY

  RUPHY_VIEW = <<~ERB
    <!-- Ruphy workspace — dedicated canvas for the Ruphino in-app UI -->
    <div id="ruphy-canvas"></div>
  ERB

  def inject_ruphino(project_dir)
    img_dest = File.join(project_dir, 'app/assets/images/ruphino.png')
    FileUtils.mkdir_p(File.dirname(img_dest))
    FileUtils.cp(ICON_PATH, img_dest)

    partial_path = File.join(project_dir, 'app/views/layouts/_ruphino.html.erb')
    File.write(partial_path, RUPHINO_PARTIAL)

    layout_path = File.join(project_dir, 'app/views/layouts/application.html.erb')
    layout = File.read(layout_path)
    layout.sub!('</body>', "  <%= render 'layouts/ruphino' %>\n</body>")
    File.write(layout_path, layout)

    routes_path = File.join(project_dir, 'config/routes.rb')
    routes = File.read(routes_path)
    routes.sub!(/^end\s*\z/, "  if Rails.env.development?\n    get '/ruphy', to: 'ruphy#index'\n  end\nend\n")
    File.write(routes_path, routes)

    controller_path = File.join(project_dir, 'app/controllers/ruphy_controller.rb')
    File.write(controller_path, RUPHY_CONTROLLER)

    view_dir = File.join(project_dir, 'app/views/ruphy')
    FileUtils.mkdir_p(view_dir)
    File.write(File.join(view_dir, 'index.html.erb'), RUPHY_VIEW)

    puts '✓ Ruphino injected'
    puts '✓ /ruphy page created'
  end

  # ── Task 4: Open browser ──────────────────────────────────────────────────

  def open_browser(url)
    java.awt.Desktop.getDesktop.browse(java.net.URI.new(url))
  rescue => e
    puts "Could not open browser: #{e.message}"
  end

  # ── Menu show/hide ────────────────────────────────────────────────────────

  def show_menu
    return if @menu_visible
    @menu_visible  = true
    @close_pending = false

    loc      = @shell.swt_widget.location
    center_y = loc.y + DIAMETER / 2

    positions = [
      [loc.x - BTN_GAP - BTN_WIDTH, center_y - BTN_HEIGHT / 2],
      [loc.x + DIAMETER + BTN_GAP,  center_y - BTN_HEIGHT / 2]
    ]

    @menu_shells.zip(positions).each do |ms, (x, y)|
      ms.swt_widget.setLocation(x, y)
      ms.swt_widget.setVisible(true)
    end
  end

  def hide_menu
    return unless @menu_visible
    @menu_visible = false
    @menu_shells.each { |ms| ms.swt_widget.setVisible(false) }
  end

  def toggle_menu
    @menu_visible ? hide_menu : show_menu
  end

  def schedule_menu_close
    @close_pending = true
    display = @shell.swt_widget.display
    display.timerExec(100, -> { hide_menu if @close_pending })
  end

  # ── Helpers ───────────────────────────────────────────────────────────────

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

  def enable_interactions
    on_mouse_down do |event|
      @drag_origin  = [event.x, event.y]
      @was_dragging = false
    end

    on_mouse_move do |event|
      next unless @drag_origin
      hide_menu if @menu_visible
      @was_dragging = true
      p = event.display.map(event.widget, nil, event.x, event.y)
      @shell.swt_widget.setLocation(
        p.x - @drag_origin[0],
        p.y - @drag_origin[1]
      )
    end

    on_mouse_up do |_event|
      toggle_menu unless @was_dragging
      @drag_origin  = nil
      @was_dragging = false
    end
  end
end
