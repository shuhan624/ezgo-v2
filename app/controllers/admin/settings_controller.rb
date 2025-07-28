# frozen_string_literal: true

class Admin::SettingsController < AdminController
  before_action :set_setting, only: %i[edit update sort]

  # GET /settings
  def index
    authorize Setting
    @site_items = Setting.site_items.with_attached_image.with_attached_image_en.order(created_at: :asc)
    @seo_items = Setting.seo_items.order(created_at: :asc)
    @contact_items = Setting.contact_items.order(created_at: :asc)
    @social_items = Setting.social_items.with_attached_image.order(position: :asc)
    @custom_items = Setting.custom_items.order(created_at: :asc)
  end

  # GET /settings/:id/edit
  def edit
  end

  # PATCH/PUT /settings/:id
  def update
    @setting.image.purge if params[:destroy_image] == 'true'
    @setting.image_en.purge if params[:destroy_image_en] == 'true'
    if @setting.update(setting_params)
      redirect_to admin_settings_url, notice: successful_message
    else
      keep_images
      render :edit
    end
  end

  def sort
    @setting.insert_at(params[:to].to_i + 1) if @setting.valid?
    if !@setting.valid? || @setting.errors.present?
      render js: notify_script(:alert, @setting.errors.full_messages)
    else
      render js: notify_script(:success, successful_message(model: Setting, action: :update))
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_setting
    @setting = Setting.friendly.find(params[:id])
    authorize @setting
  end

  #without this, ActiveSupport::MessageVerifier::InvalidSignature
  def keep_images
    @setting.attachment_changes.each do |_, change|
      if change.is_a?(ActiveStorage::Attached::Changes::CreateOne)
        change.upload
        change.blob.save
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def setting_params
    params.require(:setting).permit(:content_zh_tw, :content_en, :status_zh_tw, :status_en, :image, :image_en)
  end
end
