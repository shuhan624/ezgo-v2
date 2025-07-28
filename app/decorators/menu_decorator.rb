class MenuDecorator < ApplicationDecorator
  delegate_all

  def link_i18n
    I18n.locale == :en ? object.link_en : object.link
  end
end
