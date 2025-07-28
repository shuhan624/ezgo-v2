class Admin::TagsController < AdminController
  def index
    authorize Tag
    tags = Tag.search(params[:keyword]).order(name: :asc)
    # .order(clicks_count: :desc)
    @pagy, @tags = pagy(tags)
    render json: { total_count: @pagy.count, items: @tags.as_json(only: [:name]) }
  end
end
