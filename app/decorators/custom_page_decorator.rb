class CustomPageDecorator < ApplicationDecorator
  delegate_all

  def menu
    object.menu.present? ? object.menu : object.title
  end

  def content_status
    object.info? ? '✅' : ''
  end
end
