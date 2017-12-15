require 'rails_helper'

module Krant
  RSpec.describe NewsItem, type: :model do
    it 'reads translated attributes from template' do
      news_item_template = {
        title: { en: 'Some title' },
        text: { en: 'Some text' }
      }
      news_item = NewsItem.new(template: news_item_template)

      expect(news_item.title).to eq('Some title')
      expect(news_item.text).to eq('Some text')
    end

    it 'translated attributes based on current translation' do
      news_item_template = {
        title: { de: 'Ein Titel' }
      }
      news_item = NewsItem.new(template: news_item_template)

      I18n.with_locale(:de) do
        expect(news_item.title).to eq('Ein Titel')
      end
    end

    it 'falls back to default locale if translation is missing' do
      news_item_template = {
        title: { en: 'Some title' }
      }
      news_item = NewsItem.new(template: news_item_template)

      I18n.with_locale(:de) do
        expect(news_item.title).to eq('Some title')
      end
    end

    it 'returns empty string if all attribute translations are missing' do
      news_item_template = {}
      news_item = NewsItem.new(template: news_item_template)

      I18n.with_locale(:de) do
        expect(news_item.title).to eq('')
      end
    end
  end
end
