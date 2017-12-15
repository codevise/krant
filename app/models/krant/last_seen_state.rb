module Krant
  # @api private
  class LastSeenState < ActiveRecord::Base
    belongs_to :user, polymorphic: true
  end
end
