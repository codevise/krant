require 'domino'

module Dom
  class BroadcastMessagesAdmin < Domino
    selector '.admin_broadcast_messages'

    def new_link
      within(node) do
        find_link(I18n.t('active_admin.new_model',
                         model: I18n.t('activerecord.models.broadcast_message.one')))
      end
    end

    class Form < Domino
      selector 'form.broadcast_message'

      def submit_with(options)
        within(node) do
          fill_in_text_translations(options.fetch(:text, {}))

          if options[:active]
            check 'broadcast_message_active'
          else
            uncheck 'broadcast_message_active'
          end

          find('[name="commit"]').click
        end
      end

      private

      def fill_in_text_translations(texts)
        texts.each do |locale, text|
          fill_in(I18n.t('krant.admin.broadcast_messages.text_translation_label',
                         locale_name: locale),
                  with: text)
        end
      end
    end

    class TableRow < Domino
      selector '.index_table tbody tr'

      def edit_link
        within(node) do
          find('.edit_link')
        end
      end

      def delete_link
        within(node) do
          find('.delete_link')
        end
      end

      def marked_as_active?
        within(node) do
          has_selector?(".col-active .status_tag.yes")
        end
      end
    end

    class TextTranslation < Domino
      selector '.krant-broadcast-messages-table-text'

      attribute :text, '.krant-broadcast-messages-table-text-translation'

      attribute :locale, '.krant-broadcast-messages-table-text-locale' do |label|
        label.tr(':', '').strip
      end
    end
  end

  class BroadcastMessageBar < Domino
    selector '.krant-broadcast-messages-bar'

    def text
      node.text
    end
  end
end
