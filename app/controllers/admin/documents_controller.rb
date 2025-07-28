# frozen_string_literal: true

class Admin::DocumentsController < AdminController
  before_action :set_document, only: %i[show edit update destroy sort]

  # GET /documents
  def index
    authorize Document
    @q = Document.ransack(params[:q])
    @q.sorts = ['created_at desc']
    documents = @q.result
    @pagy, @documents = pagy(documents)
    @documents = @documents.decorate
  end

  # GET /documents/:id
  def show
    @document = @document.decorate
  end

  # GET /documents/new
  def new
    @document = Document.new
    authorize @document
  end

  # GET /documents/:id/edit
  def edit; end

  # POST /documents
  def create
    @document = Document.new(permitted_attributes(Document))
    authorize @document

    if @document.save
      redirect_to admin_document_path(@document), notice: successful_message
    else
      keep_files
      render :new
    end
  end

  # PATCH/PUT /documents/:id
  def update
    if @document.update(document_params)
      redirect_to admin_document_path(@document), notice: successful_message
    else
      keep_files
      render :edit
    end
  end

  # DELETE /documents/:id
  def destroy
    @document.destroy
    redirect_to admin_documents_url, notice: successful_message
  end

  def sort
    @document.insert_at(params[:to].to_i + 1) if @document.valid?
    if !@document.valid? || @document.errors.present?
      render js: notify_script(:alert, @document.errors.full_messages)
    else
      render js: notify_script(:success, successful_message(model: Document, action: :update))
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.friendly.find(params[:id])
    authorize @document
  end

  #without this, ActiveSupport::MessageVerifier::InvalidSignature
  def keep_files
    @document.attachment_changes.each do |_, change|
      if change.is_a?(ActiveStorage::Attached::Changes::CreateOne)
        change.upload
        change.blob.save
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def document_params
    params.require(:document).permit(policy(@document).permitted_attributes)
  end
end
