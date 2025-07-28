class DocumentsController < PublicController
  def show
    @doc = Document.friendly.find(params[:id])
    @blob = @doc.file.blob

    if @blob.blank?
      raise ActiveRecord::RecordNotFound
    end

    if params[:size]
      # generate thumb
      variation_key = Blob.variation(params[:size])
      send_file_by_disk_key @blob.representation(variation_key).processed.key, content_type: @blob.content_type
    else
      # return raw file
      send_file_by_disk_key @blob.key, content_type: @blob.content_type, disposition: @doc.decorate.show_disposition, filename: @blob.filename.to_s
    end
  end

  private

  def send_file_by_disk_key(key, content_type:, disposition: :inline, filename: nil)
    opts = { type: content_type, disposition: disposition, filename: filename }
    send_file Blob.path_for(key), opts
  end
end
