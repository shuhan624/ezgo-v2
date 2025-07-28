# frozen_string_literal: true

class Admin::DownloadsController < AdminController
  before_action :set_download, only: %i[show edit update destroy sort]

  # GET /downloads
  def index
    authorize Download
    @q = Download.includes(:download_category).ransack(params[:q])
    @q.sorts = 'position asc'
    downloads = @q.result
    @pagy, @downloads = pagy(downloads)
    @downloads = @downloads.decorate
  end

  # GET /downloads/:id
  def show
    @download = @download.decorate
  end

  # GET /downloads/new
  def new
    @download = Download.new
    authorize @download
  end

  # GET /downloads/:id/edit
  def edit; end

  # POST /downloads
  def create
    @download = Download.new(download_params)
    authorize @download

    if @download.save
      redirect_to admin_downloads_url, notice: successful_message
    else
      render :new
    end
  end

  # PATCH/PUT /downloads/:id
  def update
    if @download.update(download_params)
      redirect_to admin_downloads_url, notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /downloads/:id
  def destroy
    @download.destroy
    redirect_to admin_downloads_url, notice: successful_message
  end

  def sort
    @download.insert_at(params[:to].to_i + 1) if @download.valid?
    if !@download.valid? || @download.errors.present?
      render js: notify_script(:alert, @download.errors.full_messages)
    else
      render js: notify_script(:success, successful_message(model: Download, action: :update))
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_download
    @download = Download.find(params[:id])
    authorize @download
  end

  # Only allow a list of trusted parameters through.
  def download_params
    params.require(:download).permit(:download_category_id, :title, :title_en, :status, :en_status, :file, :file_en)
  end
end
