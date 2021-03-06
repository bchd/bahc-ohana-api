class Admin
  module Management
    class SuperAdminsController < Admin::ManagementController

      def index
        @search_terms = params[:search]
        @super_admins = AdminsSearch.new(
          super_admin: true,
          search_terms: params[:search],
          page: params[:page],
          per_page: params[:per_page]
        ).search.load&.objects
      end

      def edit; end

      def update
        @admin.update(update_admin_params)
        redirect_to admin_management_super_admins_path,
                    notice: "Update succcessful"
      end

      private

      def update_admin_params
        params['admin']['super_admin'] =
          params['admin']['super_admin'] == '1' ? true : false
        params.require(:admin).permit(:name, :super_admin)
      end
    end
  end
end
