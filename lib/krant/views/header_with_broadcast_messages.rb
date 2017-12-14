module Krant
  module Views
    # Extends the normal Active Admin header to include broadcast
    # messages.
    class HeaderWithBroadcastMessages < Arbre::Component
      builder_method :krant_header_with_broadcast_messages

      def build(*args)
        insert_tag(ActiveAdmin::Views::Header, *args)
        div do
          TranslatedBroadcastMessage.active.each do |broadcast_message|
            div class: 'krant-broadcast-messages-bar' do
              broadcast_message.text
            end
          end
        end
      end
    end
  end
end
