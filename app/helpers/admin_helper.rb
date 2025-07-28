module AdminHelper
  include Pagy::Frontend

  def notify_script(flash_key, flash_msg)
    case flash_key.to_sym
    when :success, :ok
      "notify.success('#{flash_msg}');"
    when :info, :notice
      "notify.info('#{flash_msg}');"
    when :warning
      "notify.warning('#{flash_msg}');"
    when :error, :alert
      "notify.error('#{flash_msg}');"
    end
  end

  def here?(str)
    c, a = str.split('#')
    return controller_name == c if a.blank?
    return action_name == a if c.blank?
    controller_name == c && action_name == a
  end

  def successful_message(model: controller_name.classify.constantize, action: action_name)
    I18n.t("successful.#{action}", model: render_model_i18n(model))
  end

  def render_model_i18n(model)
    model_key = case model
                when String, Symbol then model
                else model&.model_name&.i18n_key
                end
    I18n.t("activerecord.models.#{model_key}", default: model_key.to_s.humanize)
  end

  def render_action_i18n(action, model = nil)
    m_text = render_model_i18n(model) if model
    I18n.t("action.#{action}",
           default: action.to_s.humanize, model: m_text)
  end
end
