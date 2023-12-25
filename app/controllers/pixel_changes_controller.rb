class PixelChangesController < ApplicationController
  before_action :authenticate_user!

  def create
    res = Paintings::ChangePixel.new.(
      current_user,
      params[:painting_id],
      params.permit(:row, :col, :color)
    )

    return head(:no_content) if res.success?

    render json: res.failure, status: :unprocessable_entity
  end
end
