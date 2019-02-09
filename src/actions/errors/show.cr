class Errors::Show < Lucky::ErrorAction
  def handle_error(error : JSON::ParseException)
    message = "There was a problem parsing the JSON." +
              " Please check that it is formed correctly"

    json Errors::ShowSerializer.new(message, 400), status: 400
  end

  def handle_error(error : Lucky::RouteNotFoundError)
    json Errors::ShowSerializer.new("Not found", 404), status: 404
  end

  def handle_error(error : Exception)
    error.inspect_with_backtrace(STDERR)

    message = "An unexpected error occurred"

    json Errors::ShowSerializer.new(message, 500), status: 500
  end
end
