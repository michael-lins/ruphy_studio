class BuilderController < ApplicationController
  def index
  end

  def borderless
  end

  def save
    # Save the dropped components' data to the database or session
    session[:layout] = params[:layout]
    render json: { message: "Layout saved successfully!" }
  end

  def load
    # Load the layout data from the database or session
    layout = session[:layout] || []
    render json: { layout: layout }
  end
end
