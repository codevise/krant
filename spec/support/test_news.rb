module TestNews
  mattr_accessor :news
  self.news = Krant::News.about(TestNews)
end

RSpec.configure do |config|
  config.before(:each) do
    TestNews.news = Krant::News.about(TestNews)
  end
end
