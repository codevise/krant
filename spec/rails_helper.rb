ENV['RAILS_ENV'] ||= 'test'

require 'combustion'
Combustion.initialize!(:active_record, :action_controller, :action_view)

require 'rspec/rails'
require 'support/factory_bot'

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
