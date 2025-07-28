class ContactDecorator < ApplicationDecorator
  delegate_all

  def status
    I18n.t(object.status, scope: 'simple_form.options.contact.status')
  end

  def summary
    self.content&.html_safe&.first(80)
  end
end
