module Krant
  # @api private
  class NewsItem < ActiveRecord::Base
    attr_accessor :template
    attr_accessor :seen

    def title
      translated_attribute('title')
    end

    def text
      translated_attribute('text')
    end

    def unseen?
      !seen
    end

    def seen?
      seen
    end

    private

    def translated_attribute(name)
      attribute_translations(name).fetch(I18n.locale.to_sym) do
        attribute_translations(name).fetch(I18n.default_locale.to_sym, '')
      end
    end

    def attribute_translations(name)
      template.fetch(name.to_sym, {})
    end
  end
end
