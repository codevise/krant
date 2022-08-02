module Krant
  module Views
    # Renders a list of broadcast messages
    class BroadcastMessageList < Arbre::Component
      builder_method :krant_broadcast_message_list

      def build(location: nil)
        messages = TranslatedBroadcastMessage.active(location: location)

        div do
          messages.each do |broadcast_message|
            div class: 'krant-broadcast-messages-bar' do
              Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
                .render(broadcast_message.text)
                .html_safe
            end
          end
        end
      end
    end
  end
end
