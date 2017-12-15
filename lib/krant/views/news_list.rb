module Krant
  module Views
    # A list of recent news. Rendering the component marks news as
    # seen.
    class NewsList < Arbre::Component
      builder_method :krant_news_list

      # @param news [Krant::News] News collection to take news from.
      def build(news)
        super(class: 'krant-news-list')

        news.all(for_user: current_active_admin_user).each do |news_item|
          item(news_item)
        end

        script raw('jQuery.post(location.pathname + "/seen")')
      end

      private

      def item(news_item)
        div class: item_css_class(news_item) do
          h3 news_item.title
          text_node Kramdown::Document.new(news_item.text).to_html.html_safe
        end
      end

      def item_css_class(news_item)
        [
          'krant-news-list-item',
          news_item.seen? ? 'krant-news-list-item-seen' : 'krant-news-list-item-unseen'
        ].compact.join(' ')
      end
    end
  end
end
