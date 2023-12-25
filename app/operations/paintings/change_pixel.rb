module Paintings
  class ChangePixel < ::BaseOperation
    def call(user, painting_id, params)
      painting = Painting.find_by(id: painting_id)
      pixel_params = yield validate_params(painting, params)
      ApplicationRecord.transaction do
        PixelChange.create! user: user, painting_id: painting_id, **pixel_params
        Pixel.upsert(
          { painting_id: painting_id, **pixel_params },
          unique_by: [:painting_id, :row, :col]
        )
      end

      Success()
    end

    private

    def validate_params(painting, params)
      row = yield validate_row(painting, params[:row])
      col = yield validate_col(painting, params[:col])
      color = yield parse_color(params[:color])

      Success(
        row: row,
        col: col,
        color: color
      )
    end

    def validate_row(painting, row)
      return Success(row) if row >=0 && row < painting.height

      Failure(row: err(:out_of_bounds))
    end

    def validate_col(painting, col)
      return Success(col) if col >=0 && col < painting.width

      Failure(col: err(:out_of_bounds))
    end

    def parse_color(color_str)
      Success(PixelData::Color.parse_json(color_str))
    rescue PixelData::Color::InvalidString
      Failure(color: err(:invalid_color))
    end

    def err(err_id, **opts)
      I18n.t!("operations.paintings.errors.#{err_id}", **opts)
    end
  end
end
