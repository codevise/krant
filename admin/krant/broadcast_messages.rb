module Krant
  ActiveAdmin.register BroadcastMessage, as: 'BroadcastMessage' do
    menu priority: 100

    actions :index, :new, :create, :edit, :update, :destroy

    config.batch_actions = false
    config.filters = false

    index do
      column :text do |broadcast_message|
        div do
          broadcast_message.translations.each do |t|
            div class: 'krant-broadcast-messages-table-text' do
              span "#{t.locale}:", class: 'krant-broadcast-messages-table-text-locale'
              span t.text, class: 'krant-broadcast-messages-table-text-translation'
            end
          end
        end
      end
      column :active
      column :updated_at
      column :created_at
      actions
    end

    form do |f|
      f.inputs do
        f.input :active

        f.semantic_fields_for :translations do |t|
          t.input(:text,
                  as: :string,
                  label: I18n.t('krant.admin.broadcast_messages.text_translation_label',
                                locale_name: t.object.locale))
          t.input :locale, as: :hidden
        end
      end
      f.actions
    end

    after_build do |broadcast_message|
      Krant.broadcast_message_locales.each do |locale|
        broadcast_message.translations.detect do |t|
          t.locale == locale.to_s
        end || broadcast_message.translations.build(locale: locale)
      end
    end

    controller do
      def permitted_params
        params.permit(broadcast_message: [:active, translations_attributes: [:id, :text, :locale]])
      end
    end
  end
end
