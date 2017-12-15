require 'krant/views/news_list'

ActiveAdmin.register_page 'news' do
  menu false

  content title: 'News' do
    krant_news_list(TestNews.news)
  end
end
