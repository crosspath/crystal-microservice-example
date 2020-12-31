class AppServer < Lucky::BaseAppServer
  def middleware
    [
      Lucky::HttpMethodOverrideHandler.new,
      Lucky::LogHandler.new,

      # Disabled in API mode, but can be enabled if you need them:
      # Lucky::SessionHandler.new,
      # Lucky::FlashHandler.new,
      Lucky::ErrorHandler.new(action: Errors::Show),
      Lucky::RemoteIpHandler.new,
      Lucky::RouteHandler.new,

      # Disabled in API mode:
      # Lucky::StaticFileHandler.new("./public", false),
      Lucky::RouteNotFoundHandler.new,
    ]
  end

  def protocol
    "http"
  end

  # def base_uri
  #   "http://#{host}:#{port}"
  # end
  #
  # def host
  #   Lucky::Server.settings.host
  # end
  #
  # def port
  #   Lucky::Server.settings.port
  # end

  def listen
    server.bind_tcp(host, port, reuse_port: false)
    server.listen
  end

  # def close
  #   server.close
  # end
end
