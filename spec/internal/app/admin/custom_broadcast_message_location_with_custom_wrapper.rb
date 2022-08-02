ActiveAdmin.register_page 'custom broadcast message location with custom wrapper' do
  content title: 'Custom Messages' do
    krant_broadcast_message_list(
      location: 'custom',
      wrapper: ->(render) { div(class: 'custom_wrapper', &render) },
      item_class: 'custom_item_class'
    )
  end
end
