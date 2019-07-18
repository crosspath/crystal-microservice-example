class AppDatabase < Avram::Database
end

AppDatabase.configure do |settings|
  if Lucky::Env.production?
    settings.url = ENV.fetch("DATABASE_URL")
  else
    settings.url = ENV["DATABASE_URL"]? || Avram::PostgresURL.build(
      hostname: "localhost",
      database: "bonusapp_#{Lucky::Env.name}"

      # Optional settings:
      #
      # username: "postgres",
      # password: "postgres",
      # port: 5432
    )
  end
end

# In development and test, raise an error if you forget to preload associations
Avram.configure do |settings|
  settings.lazy_load_enabled   = Lucky::Env.production?
  settings.database_to_migrate = AppDatabase
end
