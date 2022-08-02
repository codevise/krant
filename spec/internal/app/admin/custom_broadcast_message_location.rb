ActiveAdmin.register_page 'custom broadcast message location' do
  content title: 'Custom Messages' do
    krant_broadcast_message_list(location: 'custom')
  end
end
