class CanvasController < ApplicationController
  def show
    painting = Painting.find_by(id: params[:painting_id])
    canvas = Paintings::BuildCanvas.new.(painting)

    send_data canvas, type: 'image/png', disposition: 'inline'
  end
end
