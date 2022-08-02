ActiveAdmin::Views::Pages::Base.prepend(Krant::BasePagePatch)

ActiveAdmin.application.load_paths = [
  Krant.active_admin_load_path,
  Rails.root.join('app/admin').to_s
]

ActiveAdmin.setup do |config|
  config.view_factory.header = Krant::Views::HeaderWithBroadcastMessages

  config.namespace :admin do |admin|
    admin.build_menu :utility_navigation do |menu|
      Krant.add_active_admin_news_menu_item_to(menu,
                                               news: TestNews.news,
                                               url: -> { admin_news_path })
    end
  end

  config.current_user_method = :current_user
end
