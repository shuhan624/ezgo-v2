class DeviseMailer < Devise::Mailer
  layout 'mailer'
  include Devise::Controllers::UrlHelpers

  def headers_for(action, opts)
    super.merge!({ template_path: 'devise/users/mailer' }) # app/views/users/mailer
  end
end
