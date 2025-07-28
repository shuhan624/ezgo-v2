require "audited"

Audited::Railtie.initializers.each(&:run)
Audited.current_user_method = :current_admin

Audited.config do |config|
  config.audit_class = 'CustomAudit'
end
