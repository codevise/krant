module Krant
  # @api private
  class BroadcastMessage < ActiveRecord::Base
    has_many(:translations, class_name: 'BroadcastMessageTranslation')

    scope(:active, -> { where(active: true) })
  end
end
