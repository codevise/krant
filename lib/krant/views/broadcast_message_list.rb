module Krant
  module Views
    # Renders a list of broadcast messages
    class BroadcastMessageList < Arbre::Component
      builder_method :krant_broadcast_message_list

      def build(location: nil,
                item_class: 'krant-broadcast-messages-bar',
                wrapper: ->(block) { div(&block) })
        messages = TranslatedBroadcastMessage.active(location: location)

        render = lambda do
          messages.each do |broadcast_message|
            div class: item_class do
              Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
                .render(broadcast_message.text)
                .html_safe
            end
          end
        end

        if messages.any?
          instance_exec(render, &wrapper)
        end
      end
    end
  end
end
