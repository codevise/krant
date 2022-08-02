module Krant
  # @api private
  class BroadcastMessage < ActiveRecord::Base
    has_many(:translations, class_name: 'BroadcastMessageTranslation')

    accepts_nested_attributes_for(:translations)

    scope(:active, -> { where(active: true) })

    def location=(value)
      super(value.presence)
    end
  end
end
