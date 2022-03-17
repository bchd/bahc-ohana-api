class DefaultHost
  def call(request)
    host = request.host
    return host if host.end_with?(default_host)

    default_host
  end

  private

  def default_host
    @default_host ||= ENV['DOMAIN_NAME']
  end
end
