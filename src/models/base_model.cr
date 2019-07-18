abstract class BaseModel < Avram::Model
  def self.database
    AppDatabase
  end

  macro default_columns
    primary_key id : Int32 # Keep Int32 instead of Int64
    timestamps
  end
end
