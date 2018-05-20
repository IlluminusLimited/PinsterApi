# frozen_string_literal: true

module EagerLoadable
  def build_query(params)
    if params[:images].nil? || params[:images].to_s == 'true'
      with_images.with_counts
    else
      default_result
    end
  end

  private

    def default_result
      all
    end
end
