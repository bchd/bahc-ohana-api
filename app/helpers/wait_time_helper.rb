module WaitTimeHelper
  def wait_time_select_options
    SETTINGS[:wait_times].map do |wait_time|
      [
        translate("service.wait_time.#{wait_time}"),
        wait_time
      ]
    end
  end
end
