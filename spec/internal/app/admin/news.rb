require 'krant/views/news_list'

ActiveAdmin.register_page 'news' do
  Krant.active_admin_news_page(self, news: -> { TestNews.news })

  content title: 'News' do
    krant_news_list(TestNews.news)
  end
end
