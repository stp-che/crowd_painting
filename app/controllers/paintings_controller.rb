class PaintingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @paintings = Painting.all.order(created_at: :desc)
  end

  def create
    Paintings::Create.new.(current_user, create_params).or do |errors|
      flash[:alert] = errors.values.join('; ')
    end

    redirect_to paintings_path
  end

  def show
    @painting = Painting.find_by(id: params[:id])

    unless @painting
      redirect_to paintings_path
      return
    end
  end

  private

  def create_params
    params.require(:painting).permit(:size, :title)
  end
end
