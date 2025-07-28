# frozen_string_literal: true

class Admin::ContactsController < AdminController
  before_action :set_contact, only: %i[show edit update destroy]

  # GET /contacts
  def index
    authorize Contact
    @q = Contact.ransack(params[:q])
    @q.sorts = 'created_at desc'
    contacts = @q.result
    @pagy, @contacts = pagy(contacts)
    @contacts = @contacts.decorate
  end

  # GET /contacts/:id
  def show
    @contact = @contact.decorate
  end

  # GET /contacts/new
  # def new
  #   @contact = Contact.new
  # end

  # GET /contacts/:id/edit
  def edit; end

  # POST /contacts
  # def create
  #   @contact = Contact.new(permitted_attributes(Contact))
  #   if @contact.save
  #     redirect_to admin_contacts_url, notice: successful_message
  #   else
  #     render :new
  #   end
  # end

  # PATCH/PUT /contacts/:id
  def update
    if @contact.update(contact_params)
      redirect_to admin_contact_path(@contact), notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /contacts/:id
  def destroy
    @contact.destroy
    redirect_to admin_contacts_url, notice: successful_message
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
    authorize @contact
  end

  # Only allow a list of trusted parameters through.
  def contact_params
    params.require(:contact).permit(policy(@contact).permitted_attributes)
  end
end
