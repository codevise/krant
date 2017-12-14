ActiveAdmin.application.load_paths.unshift(Krant.active_admin_load_path)
ActiveAdmin.application.load_paths.unshift(Rails.root.join('app', 'admin').to_s)

ActiveAdmin.setup do |config|
  config.view_factory.header = Krant::Views::HeaderWithBroadcastMessages
end
