class PixelsController < ApplicationController
  before_action :authenticate_user!

  def index
    filter = index_filter

    painting = Painting.find(params[:painting_id])
    pixels = painting.pixels
    if filter[:after]
      pixels = pixels.after(filter[:after])
    end

    render json: pixels
  end

  private

  def index_filter
    {}.tap do |filter|
      if params[:after].present?
        begin
          filter[:after] = Time.parse(params[:after])
        rescue StandardError
          raise BadRequest, "can't parse after param: #{ params[:after].inspect }"
        end
      end
    end
  end
end
