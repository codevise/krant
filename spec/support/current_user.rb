RSpec.configure do |config|
  config.before(:each) do
    ApplicationController.current_user = User.create!
  end
end
