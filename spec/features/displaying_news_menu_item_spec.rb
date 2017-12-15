require 'rails_helper'

RSpec.feature 'displaying news menu item' do
  scenario 'displays menu item' do
    visit(admin_dashboard_path)

    expect(page.html).to have_selector('.krant-news-menu-item')
  end

  scenario 'sets css class when there are unseen news items' do
    TestNews.news.item('some_item', {})
    TestNews.news.persist

    visit(admin_dashboard_path)

    expect(page.html).to have_selector('.krant-news-menu-item-unseen')
  end

  scenario 'sets css class when there are no unseen news items' do
    visit(admin_dashboard_path)

    expect(page.html).to have_selector('.krant-news-menu-item-no-unseen')
  end

  scenario 'sets seen css class when user has seen all items' do
    TestNews.news.item('some_item', {})
    TestNews.news.persist

    visit(admin_news_path)
    visit(admin_dashboard_path)

    expect(page.html).to have_selector('.krant-news-menu-item-no-unseen')
  end
end
