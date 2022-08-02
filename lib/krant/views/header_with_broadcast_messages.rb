module Krant
  module Views
    # Extends the normal Active Admin header to include broadcast
    # messages.
    class HeaderWithBroadcastMessages < Arbre::Component
      builder_method :krant_header_with_broadcast_messages

      def build(*args)
        insert_tag(ActiveAdmin::Views::Header, *args)
        insert_tag(BroadcastMessageList)
      end
    end
  end
end
