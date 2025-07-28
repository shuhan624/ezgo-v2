class DocumentDecorator < ApplicationDecorator
  delegate_all

  def document_content
    if object.file_type == 'file'
      h.image_tag(document.file.preview(resize_to_limit: [50, nil]).processed, alt: document.file.filename) if document.file.previewable?
    elsif object.file_type == 'link'
      object.link
    end
  end

  def file_url
    controller = '/documents'
    host = Rails.application.config.action_mailer.default_url_options[:host]
    url = h.url_for(controller: controller, action: 'show', id: object.slug, host: host)

    case object.file_type
    when 'file'
      h.link_to(url, url, target: '_blank')
    when 'link'
      h.link_to(object.link, object.link, target: '_blank')
    end
  end

  def show_published_at
    dates = []
    dates << published_at if object.published_at.present?
    dates << published_at_en if object.published_at_en.present?
    h.simple_format( dates.join("\n"), {}, wrapper_tag: 'span')
  end

  def show_file_preview
    h.image_tag(object.file.preview(resize_to_limit: [150, nil]).processed, alt: object.file.filename) if object.file.attached? && object.file.previewable?
  end

  def show_language
    h.t("simple_form.options.document.language.#{object.language}")
  end

  def show_quarterly_report_type
    h.t("simple_form.options.document.quarterly_report_type.#{object.quarterly_report_type}")
  end

  def show_disposition
    case object.file.content_type
    when 'application/vnd.ms-excel' # XLS
      'attachment'
    when 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' # XLSX
      'attachment'
    else
      'inline'
    end
  end

  def show_file_icon
    case object.file.content_type
    when 'application/pdf' # PDF
      'pdf'
    when 'application/vnd.ms-excel' # XLS
      'xls'
    when 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' # XLSX
      'xls'
    else
      'pdf'
    end
  end
end
