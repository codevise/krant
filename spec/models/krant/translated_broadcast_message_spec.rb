require 'rails_helper'

module Krant
  RSpec.describe TranslatedBroadcastMessage, type: :model do
    describe '.active' do
      it 'returns active translated broadcast message in default locale' do
        create(:broadcast_message, :active,
               text_translations: {
                 de: 'Wichtige Nachricht',
                 en: 'Important message'
               })

        texts = TranslatedBroadcastMessage.active.map(&:text)

        expect(texts).to include('Important message')
      end

      it 'returns active translated broadcast message in current locale' do
        create(:broadcast_message, :active,
               text_translations: {
                 en: 'Important message',
                 de: 'Wichtige Nachricht'
               })

        texts = I18n.with_locale(:de) do
          TranslatedBroadcastMessage.active.map(&:text)
        end

        expect(texts).to include('Wichtige Nachricht')
      end

      it 'falls back to default locale if translation is missing' do
        create(:broadcast_message, :active,
               text_translations: {
                 en: 'Important message'
               })

        texts = I18n.with_locale(:de) do
          TranslatedBroadcastMessage.active.map(&:text)
        end

        expect(texts).to include('Important message')
      end

      it 'falls back to default locale if translation has blank text' do
        create(:broadcast_message, :active,
               text_translations: {
                 de: ' ',
                 en: 'Important message'
               })

        texts = I18n.with_locale(:de) do
          TranslatedBroadcastMessage.active.map(&:text)
        end

        expect(texts).to include('Important message')
      end

      it 'does not include inactive broadcast messages' do
        create(:broadcast_message,
               text_translations: {
                 de: 'Wichtige Nachricht',
                 en: 'Important message'
               })

        expect(TranslatedBroadcastMessage.active).to be_empty
      end
    end
  end
end
