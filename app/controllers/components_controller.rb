class ComponentsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @component = @project.components.new(component_params)

    if @component.save
      render json: { id: @component.id }, status: :created
    else
      render json: { errors: @component.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @project = Project.find(params[:project_id])
    render json: @project.components
  end

  private

  def component_params
    params.require(:component).permit(:component_type, :x, :y)
  end
end

