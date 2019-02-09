abstract class ApiAction < Lucky::Action
  # Include modules and add methods that are for all API requests

  before check_api_key

  protected def check_api_key
    if params.get?(:api_key) == ENV["API_KEY"]?
      continue
    else
      response_error(100)
    end
  end

  protected def response_success(**options)
    result = {status: 200}
    json result.merge(options)
  end

  protected def response_error(code, **options)
    result = {status: code, error: ApiStatus::CODES[code]}
    json result.merge(options), Status::UnprocessableEntity
  end
end
