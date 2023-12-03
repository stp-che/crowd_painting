module PaintingsHelper
  def link_to_painting(painting)
    title = painting.title
    title = "##{painting.id}" if title.blank?
    link_to title, painting_path(painting)
  end

  def painting_size(painting)
    "#{painting.width} x #{painting.height}"
  end
end
