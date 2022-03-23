class Admin
  class ContactsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def edit
      @location = Location.find(params[:location_id])
      @contact = Contact.find(params[:id])

      authorize @location
    end

    def update
      @contact = Contact.find(params[:id])
      @location = Location.find(params[:location_id])

      authorize @location

      if @contact.update(contact_params)
        flash[:notice] = 'Contact was successfully updated.'
        redirect_to [:admin, @location, @contact], allow_other_host: true
      else
        render :edit
      end
    end

    def new
      @location = Location.find(params[:location_id])

      authorize @location

      @contact = Contact.new
    end

    def create
      @location = Location.find(params[:location_id])
      @contact = Contact.find_or_initialize_by(name: contact_params[:name])

      authorize @location

      if @contact.update(contact_params)
        @location.contacts << @contact
        flash[:notice] = "Contact '#{@contact.name}' was successfully created."
        redirect_to admin_location_url(@location), allow_other_host: true
      else
        render :new
      end
    end

    def destroy
      location = Location.find(params[:location_id])

      authorize location

      resource = location.resource_contacts.find_by(contact_id: params[:id])
      contact = resource.contact
      resource.destroy

      redirect_to admin_location_url(location),
                  allow_other_host: true,
                  notice: "Contact '#{contact.name}' was successfully removed from #{location.name}."
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
