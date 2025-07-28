class ContactMailer < ApplicationMailer
  def contact_email(contact)
    @contact = contact
    receivers = Setting.find_by(name: 'receivers')&.content&.split(',')
    @site_title = Setting.find_by(name: 'site_title')

    mail(to: receivers,
         subject: "#{@site_title.content} - #{@contact.name}"
    )
  end
end
