class PaintingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @paitings = Painting.all
  end
end
