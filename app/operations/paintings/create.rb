module Paintings
  class Create < ::BaseOperation
    def call(user, params)
      prm = yield picture_params(params)

      painting = Painting.create!(user: user, **prm)

      Success(painting)
    end

    private

    def picture_params(params)
      errors = {}

      if params[:size].nil?
        errors[:size] = err(:is_blank)
      end

      size = Painting::SIZES[params[:size]]

      unless size
        errors[:size] = err(:wrong_size)
      end

      return Failure(errors) unless errors.empty?

      title = params[:title]
      title = nil if title.blank?

      Success({
        width: size.first, 
        height: size.last,
        title: title
      })
    end

    def err(err_id, **opts)
      I18n.t!("operations.paintings.errors.#{err_id}", **opts)
    end
  end
end
