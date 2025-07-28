class ContactController < PublicController
  before_action :validate_cloudflare_turnstile, only: %i[create]

  def new
    @contact = Contact.new
    @social_items = Setting.social
    @page = CustomPage.find_by(slug: 'contact')&.decorate
    @meta_tag = @page
    set_meta_info
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      ContactMailer.contact_email(@contact).deliver_later
      redirect_to thanks_url
    else
      @page = CustomPage.find_by(slug: 'contact')&.decorate
      render :new
    end
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :company, :content)
  end
end
