# Variables declared in `.env` file are not accessible when I run `lucky db.migrate`,
# but when I run `lucky dev`, Foreman reads `.env` file & sets these variables for
# the application. The idea is to read this file when we are not running Foreman.
#
# NOTE: This file loads twice, before "Beginnning to watch your project",
# and after "compiling...", when I run `lucky dev`.
# Also, this file loads once in `lucky db.migrate`.
#
# pp ENV["DATABASE_URL"]?
# unless ENV.has_key?("DATABASE_URL") # or "FOREMAN_WORKER_NAME"
#   Dotenv.load
# end

module Lucky::Env
  extend self

  {% for env in [:development, :test, :production] %}
    def {{ env.id }}?
      name == {{ env.id.stringify }}
    end
  {% end %}

  def name
    ENV["LUCKY_ENV"]? || "development"
  end

  def show_exceptions?
    ENV.fetch("SHOW_EXCEPTIONS", "0") > "0"
  end
end
