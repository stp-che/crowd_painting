module PaintingsHelper
  def link_to_painting(painting)
    link_to painting_title(painting), painting_path(painting)
  end

  def painting_title(painting)
    return "##{ painting.id }" if painting.title.blank?

    painting.title
  end

  def painting_size(painting)
    "#{painting.width} x #{painting.height}"
  end

  def painting_sizes_options
    options_for_select Painting::SIZES.keys
  end
end
