class ApplicationController < ActionController::Base
  cattr_accessor :current_user
  self.current_user = nil

  helper_method :current_user
end
