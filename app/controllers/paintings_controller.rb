class PaintingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @paintings = Painting.all.order(created_at: :desc)
  end
end
