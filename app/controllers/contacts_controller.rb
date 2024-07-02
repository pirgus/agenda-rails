class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]
  before_action :set_kinds, only: %i[ new edit update create ]

  http_basic_authenticate_with name: "jaq", password: "secret", only: :destroy

  # GET /contacts or /contacts.json
  def index
    @contacts = Contact.order(:name).page(params[:page]).per(10)
  end

  # GET /contacts/1 or /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @contact.build_address # informa que esse endereço será construído, como se fosse um Address.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts or /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to contact_url(@contact), notice: (t :'contacts.created') }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to contacts_path, notice: (t :'contacts.updated') }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    # é necessario primeiro deletar o atributo que tem a propriedade "belongs_to"
    # em relacao ao contato, se nao ele fica meio que "perdido"
    # depois deleta o contato em si
    if @contact.address != nil
      @contact.address.destroy
    end
    if @contact.phones != nil
      @contact.phones.each do|phone|
        phone.destroy
      end
    end
    @contact.destroy!
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: (t :'contacts.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contact_params
    params.require(:contact).permit(:name, :email, :kind_id, :rmk,
                                    address_attributes: [:id, :street, :city, :state],
                                    phones_attributes: [:id, :phone, :_destroy])
  end

  def set_kinds
    @kind_options = Kind.all
  end

end
