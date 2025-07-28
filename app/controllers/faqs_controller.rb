class FaqsController < PublicController
  PER_PAGE = 10

  def index
    @page = CustomPage.find_by(slug: 'faqs')&.decorate
    @faq_categories = FaqCategory.publishing.order(position: :asc)&.decorate

    if params[:faq_category].present?
      @category = FaqCategory.publishing.friendly.find(params[:faq_category])&.decorate
      @faqs = @category.faqs.publishing.order(position: :asc)
      check_lang_display(@category)
      @meta_tag = @category
    else
      @default_category = FaqCategory.publishing.first&.decorate
      @faqs = @default_category.present? ? @default_category.faqs.publishing.order(position: :asc) : Faq.none
      check_lang_display(@default_category) if @default_category.present?
      @meta_tag = @page
    end

    @pagy, @faqs = pagy(@faqs, items: PER_PAGE)
    @faqs = @faqs.decorate
    set_meta_info
    show_index_title
  end
end
