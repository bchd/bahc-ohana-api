class Admin
  class OrganizationsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    include Searchable

    def index
      @search_terms = search_params(params)

      @all_orgs =
        Organization.
          unscoped.
          with_name(@search_terms[:keyword])

      @scoped_orgs = policy_scope(@all_orgs)
      @orgs = Kaminari.paginate_array(@scoped_orgs).page(params[:page])

      respond_to do |format|
        format.html
        format.json do
          render json: @orgs
        end
      end
    end

    def edit
      @organization = Organization.find(params[:id])
      @updated = @organization.updated_at

      authorize @organization
    end

    def update
      @organization = Organization.find(params[:id])

      authorize @organization

      if @organization.update(org_params)
        redirect_to [:admin, @organization],
                    notice: 'Organization was successfully updated.'
      else
        render :edit
      end
    end

    def new
      @organization = Organization.new
      authorize @organization
    end

    def create
      @organization = Organization.new(org_params)
      authorize @organization

      if @organization.save
        redirect_to admin_organizations_url,
                    notice: 'Organization was successfully created.'
      else
        render :new
      end
    end

    def destroy
      organization = Organization.find(params[:id])
      authorize organization
      organization.destroy
      redirect_to admin_organizations_url
    end

    private

    def org_params
      params.require(:organization).permit(
        { accreditations: [] }, :alternate_name, :date_incorporated, :description,
        :email, { funding_sources: [] }, :legal_status, { licenses: [] }, :name,
        :tax_id, :tax_status, :website, { tag_list: [] },
        phones_attributes: %i[
          country_prefix department extension number number_type vanity_number id _destroy
        ]
      )
    end
  end
end
