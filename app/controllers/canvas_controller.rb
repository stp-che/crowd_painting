class CanvasController < ApplicationController
  def show
    painting = Painting.find_by(id: params[:painting_id])
    Paintings::BuildCanvas.new.(painting).fmap do |canvas|
      send_data canvas, type: 'image/png', disposition: 'inline'
    end
  end
end
