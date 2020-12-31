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

  def task?
    ENV["LUCKY_TASK"]? == "true"
  end

  def show_exceptions?
    ENV.fetch("SHOW_EXCEPTIONS", "1") == "1"
  end
end
