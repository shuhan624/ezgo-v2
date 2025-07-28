# frozen_string_literal: true

class Admin::PartnersController < AdminController
  before_action :set_partner, only: %i[show edit update destroy sort]

  # GET /partners
  def index
    authorize Partner
    @q = Partner.with_attached_image.with_attached_image_en.ransack(params[:q])
    @q.sorts = 'position asc'
    partners = @q.result
    @pagy, @partners = pagy(partners)
    @partners = @partners.decorate
  end

  # GET /partners/:id
  def show
    @partner = @partner.decorate
  end

  # GET /partners/new
  def new
    @partner = Partner.new
    authorize @partner
  end

  # GET /partners/:id/edit
  def edit; end

  # POST /partners
  def create
    @partner = Partner.new(permitted_attributes(Partner))
    authorize @partner

    if @partner.save
      redirect_to admin_partner_path(@partner), notice: successful_message
    else
      keep_images
      render :new
    end
  end

  # PATCH/PUT /partners/:id
  def update
    @partner.image.purge if params[:destroy_image] == 'true'
    if @partner.update(partner_params)
      redirect_to admin_partner_path(@partner), notice: successful_message
    else
      keep_images
      render :edit
    end
  end

  # DELETE /partners/:id
  def destroy
    @partner.destroy
    redirect_to admin_partners_url, notice: successful_message
  end

  def sort
    @partner.insert_at(params[:to].to_i + 1) if @partner.valid?
    if !@partner.valid? || @partner.errors.present?
      render js: notify_script(:alert, @partner.errors.full_messages)
    else
      render js: notify_script(:success, successful_message(model: Partner, action: :update))
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_partner
    @partner = Partner.friendly.find(params[:id])
    authorize @partner
  end

  #without this, ActiveSupport::MessageVerifier::InvalidSignature
  def keep_images
    @partner.attachment_changes.each do |_, change|
      if change.is_a?(ActiveStorage::Attached::Changes::CreateOne)
        change.upload
        change.blob.save
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def partner_params
    params.require(:partner).permit(policy(@partner).permitted_attributes)
  end
end
