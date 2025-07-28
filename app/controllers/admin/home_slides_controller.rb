# frozen_string_literal: true

class Admin::HomeSlidesController < AdminController
  before_action :set_home_slide, only: %i[show edit update destroy sort]

  # GET /home_slides
  def index
    authorize HomeSlide
    @q = HomeSlide.with_attached_banner.with_attached_banner_m.ransack(params[:q])
    @q.sorts = 'position asc'
    home_slides = @q.result
    @pagy, @home_slides = pagy(home_slides)
    @home_slides = @home_slides.decorate
  end

  # GET /home_slides/:id
  def show
    @home_slide = @home_slide.decorate
  end

  # GET /home_slides/new
  def new
    @home_slide = HomeSlide.new
    authorize @home_slide
  end

  # GET /home_slides/:id/edit
  def edit; end

  # POST /home_slides
  def create
    @home_slide = HomeSlide.new(permitted_attributes(HomeSlide))
    authorize @home_slide

    if @home_slide.save
      redirect_to admin_home_slide_path(@home_slide), notice: successful_message
    else
      keep_images
      render :new
    end
  end

  # PATCH/PUT /home_slides/:id
  def update
    @home_slide.banner.purge if params[:destroy_banner] == 'true'
    @home_slide.banner_m.purge if params[:destroy_banner_m] == 'true'
    @home_slide.banner_en.purge if params[:destroy_banner_en] == 'true'
    @home_slide.banner_m_en.purge if params[:destroy_banner_m_en] == 'true'
    if @home_slide.update(home_slide_params)
      redirect_to admin_home_slide_path(@home_slide), notice: successful_message
    else
      keep_images
      render :edit
    end
  end

  # DELETE /home_slides/:id
  def destroy
    @home_slide.destroy
    redirect_to admin_home_slides_url, notice: successful_message
  end

  def sort
    @home_slide.insert_at(params[:to].to_i + 1) if @home_slide.valid?
    if !@home_slide.valid? || @home_slide.errors.present?
      render js: notify_script(:alert, @home_slide.errors.full_messages)
    else
      render js: notify_script(:success, successful_message(model: HomeSlide, action: :update))
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_home_slide
    @home_slide = HomeSlide.find(params[:id])
    authorize @home_slide
  end

  #without this, ActiveSupport::MessageVerifier::InvalidSignature
  def keep_images
    @home_slide.attachment_changes.each do |_, change|
      if change.is_a?(ActiveStorage::Attached::Changes::CreateOne)
        change.upload
        change.blob.save
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def home_slide_params
    params.require(:home_slide).permit(policy(@home_slide).permitted_attributes)
  end
end
