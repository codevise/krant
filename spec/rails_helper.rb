ENV['RAILS_ENV'] ||= 'test'

require 'sassc'
require 'sassc-rails'

require 'combustion'
Combustion.initialize!(:active_record, :action_controller, :action_view, :sprockets)

require 'rspec/rails'
require 'support/factory_bot'
require 'support/current_user'
require 'support/test_news'

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
