class CustomAuditDecorator < ApplicationDecorator
  delegate_all

  def auditable_type_name
    I18n.t("activerecord.models.#{object.auditable_type.underscore}", default: object.auditable_type)
  end

  def show_action_name
    action_mapping = {
       'create': { class: 'badge bg-warning' },
       'update': { class: 'badge bg-success' },
      'destroy': { class: 'badge bg-danger' }
    }

    style_options = action_mapping[object.action.to_sym]

    h.content_tag(:span, class: style_options[:class]) do
      I18n.t(object.action, scope: 'simple_form.options.audit.action')
    end
  end

  def item_title
    @host = Rails.application.config.action_mailer.default_url_options[:host]

    if object.auditable.present?
      case object.auditable_type
      when 'Setting'
        text = I18n.t("setting.#{object.auditable.name}")
        slug = Setting.find_by(id: auditable_id).slug
        link = h.edit_admin_setting_path(host: @host, id: slug)
      when 'RedirectRule'
        text = object.auditable.source_path
        slug = auditable_id
        link = h.send("admin_redirect_rule_path", host: @host, id: slug)
      else
        text = object.auditable.respond_to?(:title) ? object.auditable.title : object.auditable.name
        slug = object.auditable.respond_to?(:slug) ? auditable.slug : auditable_id
        link = h.send("admin_#{auditable_type.underscore}_path", host: @host, id: slug)
      end
      h.link_to(text, link, target: '_blank')
    else
      records = CustomAudit.where(auditable_type: auditable_type, auditable_id: auditable_id).order(created_at: :desc)
      record = records.find_by(action: 'destroy').audited_changes
      record['title'] ? record['title'] : record['name']
    end
  end
end
