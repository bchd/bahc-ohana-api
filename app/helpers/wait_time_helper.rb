module WaitTimeHelper
  def wait_time_select_options
    SETTINGS[:wait_times].map do |wait_time|
      [
        translate("service.wait_time.#{wait_time}"),
        wait_time
      ]
    end
  end

  def wait_time_text(wait_time)
    return translate('service_fields.availability.unknown') unless wait_time

    translate("service_fields.availability.#{wait_time}")
  end

  # rubocop:disable Metrics/MethodLength
  def wait_time_icon_classes(service)
    case service&.wait_time
    when 'available_today'
      'fa fa-check-circle-o available'
    when 'next_day_service'
      'fa fa-chevron-circle-right next-day'
    when 'two_three_day_wait'
      'fa fa-clock-o short-wait'
    when 'one_week_wait'
      'fa fa-times-circle-o long-wait'
    else
      'fa fa-question-circle-o unknown'
    end
  end
  
end
