class FlagsController < ApplicationController
  def new
    build_required_resources
  end

  def create
    # returns a ruby hash
    report_attributes = ReportSerializer.new(flag_params[:report_attributes].to_h).serialize
    updated_flag_params = flag_params.merge(report_attributes: report_attributes)

    @flag = Flag.new(updated_flag_params)

    if @flag.save
      flash[:success] = 'Thank you for reporting this issue! We will reach out to you shortly.'
      redirect_to root_path
    else
      flash.now[:error] = 'Could not report this issue! Please try after sometime.'
      build_required_resources
      render :new
    end
  end

  private

  def flag_params
    params.require(:flag).permit(:resource_type, :resource_id, :description, :email, report_attributes: {})
  end

  def build_required_resources
    @resource_id = params[:resource_id] || params.dig(:flag, :resource_id)
    @resource_type = params[:resource_type] || params.dig(:flag, :resource_type)
    @resource = Location.get(@resource_id) if @resource_type == 'Location'

    @flag = Flag.new(
      email: params.dig(:flag, :email) || "",
      description: params.dig(:flag, :description) || "",
      report_attributes: params.dig(:flag, :report_attributes) || {}
    )
  end
end
