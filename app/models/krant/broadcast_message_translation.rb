module Krant
  # @api private
  class BroadcastMessageTranslation < ActiveRecord::Base
    belongs_to :broadcast_message
  end
end
