require 'factory_bot_rails'

RSpec.configure do |config|
  # Allow to use build and create methods without FactoryGirl prefix.
  config.include FactoryBot::Syntax::Methods
end
