class Admin
  class OrganizationContactsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def edit
      @organization = Organization.find(params[:organization_id])
      @contact = Contact.find(params[:id])

      authorize @organization
    end

    def update
      @contact = Contact.find(params[:id])
      @organization = Organization.find(params[:organization_id])

      authorize @organization

      if @contact.update(contact_params)
        flash[:notice] = 'Contact was successfully updated.'
        redirect_to [:admin, @organization, @contact], allow_other_host: true
      else
        render :edit
      end
    end

    def new
      @organization = Organization.find(params[:organization_id])

      authorize @organization

      @contact = Contact.new
    end

    def create
      @organization = Organization.find(params[:organization_id])
      @contact = Contact.find_or_initialize_by(name: contact_params[:name])

      authorize @organization

      if @contact.update(contact_params)
        @organization.contacts << @contact
        flash[:notice] = "Contact '#{@contact.name}' was successfully created."
        redirect_to admin_organization_url(@organization), allow_other_host: true
      else
        render :new
      end
    end

    def destroy
      organization = Organization.find(params[:organization_id])

      authorize organization

      resource = organization.resource_contacts.find_by(contact_id: params[:id])
      contact = resource.contact
      resource.destroy

      redirect_to admin_organization_url(organization),
                  notice: "Contact '#{contact.name}' was successfully deleted.",
                  allow_other_host: true
    end

    private

    def contact_params
      params.require(:contact).permit(
        :department, :email, :name, :title,
        phones_attributes: %i[
          country_prefix department extension number number_type
          vanity_number id _destroy
        ]
      )
    end
  end
end
