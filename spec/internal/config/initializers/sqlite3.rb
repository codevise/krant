if Rails.application.config.active_record.sqlite3.respond_to?(:represent_boolean_as_integer=)
  Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true
end
