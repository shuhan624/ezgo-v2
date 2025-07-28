class DownloadDecorator < ApplicationDecorator
  delegate_all

  def category
    h.simple_format(object.download_category.name)
  end
end
