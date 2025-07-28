# frozen_string_literal: true

class Admin::FaqsController < AdminController
  before_action :set_faq, only: %i[show edit update destroy sort]

  # GET /faqs
  def index
    authorize Faq
    @q = Faq.includes(:faq_category).ransack(params[:q])
    @q.sorts = 'position asc'
    faqs = @q.result
    @pagy, @faqs = pagy(faqs)
    @faqs = @faqs.decorate
  end

  # GET /faqs/:id
  def show
    @faq = @faq.decorate
  end

  # GET /faqs/new
  def new
    @faq = Faq.new
    authorize @faq
  end

  # GET /faqs/:id/edit
  def edit; end

  # POST /faqs
  def create
    @faq = Faq.new(permitted_attributes(Faq))
    authorize @faq

    if @faq.save
      redirect_to admin_faq_path(@faq), notice: successful_message
    else
      render :new
    end
  end

  # PATCH/PUT /faqs/:id
  def update
    if @faq.update(faq_params)
      redirect_to admin_faq_path(@faq), notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /faqs/:id
  def destroy
    @faq.destroy
    redirect_to admin_faqs_url, notice: successful_message
  end

  def sort
    @faq.insert_at(params[:to].to_i + 1) if @faq.valid?
    if !@faq.valid? || @faq.errors.present?
      render js: notify_script(:alert, @faq.errors.full_messages)
    else
      render js: notify_script(:success, successful_message(model: Faq, action: :update))
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_faq
    @faq = Faq.find(params[:id])
    authorize @faq
  end

  # Only allow a list of trusted parameters through.
  def faq_params
    params.require(:faq).permit(policy(@faq).permitted_attributes)
  end
end
