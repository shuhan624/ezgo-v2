class AdminDecorator < ApplicationDecorator
  delegate_all

  def languages
    languages = []
    languages << '中文' if object.tw = true
    languages << '英文' if object.en = true
    h.simple_format( languages.join("、"), {}, wrapper_tag: 'span')
  end

  def account_role
    h.t("simple_form.options.admin.role.#{object.role}")
  end

  def status
    if object.account_active == true
      h.image_tag('admin/status_visible.svg', alt: "啟用", data: { toggle: 'tooltip', placement: 'top', title: '啟用' })
    elsif object.account_active == false
      h.image_tag('admin/status_invisible.svg', alt: "禁用", data: { toggle: 'tooltip', placement: 'top', title: '禁用' })
    end
  end
end
