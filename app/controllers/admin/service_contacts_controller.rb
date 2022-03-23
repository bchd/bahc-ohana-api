class Admin
  class ServiceContactsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def edit
      @service = Service.find(params[:service_id])
      @contact = Contact.find(params[:id])

      authorize @service.location
    end

    def update
      @contact = Contact.find(params[:id])
      @service = Service.find(params[:service_id])
      location = @service.location

      authorize @service

      if @contact.update(contact_params)
        flash[:notice] = 'Contact was successfully updated.'
        redirect_to [:admin, location, @service, @contact], allow_other_host: true
      else
        render :edit
      end
    end

    def new
      @service = Service.find(params[:service_id])

      authorize @service

      @contact = Contact.new
    end

    def create
      @service = Service.find(params[:service_id])
      @contact = Contact.find_or_initialize_by(name: contact_params[:name])
      location = @service.location

      authorize @service

      if @contact.update(contact_params)
        @service.contacts << @contact
        redirect_to admin_location_service_url(location, @service),
                    allow_other_host: true,
                    notice: "Contact '#{@contact.name}' was successfully created."
      else
        render :new
      end
    end

    def destroy
      service = Service.find(params[:service_id])

      authorize service

      resource = service.resource_contacts.find_by(contact_id: params[:id])
      contact = resource.contact
      resource.destroy

      location = service.location
      redirect_to admin_location_service_url(location, service),
                  allow_other_host: true,
                  notice: "Contact '#{contact.name}' was successfully deleted."
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
