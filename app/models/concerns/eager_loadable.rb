# frozen_string_literal: true

module EagerLoadable
  def build_query(params)
    if params[:images].nil? || params[:images].to_s == 'true'
      with_images.recently_added
    else
      default_result.recently_added
    end
  end

  private

    def default_result
      all
    end
end
