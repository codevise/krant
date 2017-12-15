require 'rails_helper'

RSpec.feature 'viewing news list' do
  scenario 'renders persisted items' do
    TestNews.news.item('some_item', title: { en: 'Some Feature' })
    TestNews.news.persist

    visit(admin_news_path)

    expect(page.html).to have_selector('h3', text: 'Some Feature')
  end

  scenario 'renders markdown in text' do
    TestNews.news.item('some_item',
                       title: { en: 'Some Feature' },
                       text: { en: '[Link](https://example.com)' })
    TestNews.news.persist

    visit(admin_news_path)

    expect(page.html).to have_selector('a[href="https://example.com"]')
  end

  scenario 'sets css class on unseen item' do
    TestNews.news.item('some_item', title: { en: 'Some Feature' })
    TestNews.news.persist

    visit(admin_news_path)

    expect(page.html).to have_selector('.krant-news-list-item-unseen')
  end

  scenario 'sets css class on seen items' do
    TestNews.news.item('some_item', title: { en: 'Some Feature' })
    TestNews.news.persist

    page.driver.post(admin_news_seen_path)
    visit(admin_news_path)

    expect(page.html).to have_selector('.krant-news-list-item-seen')
  end
end
