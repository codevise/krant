require 'rails_helper'

require 'support/dominos'

RSpec.feature 'managing broadcast messages' do
  before do
    Krant.custom_broadcast_message_locations = []
  end

  scenario 'does not show location field by default' do
    visit(admin_broadcast_messages_path)
    Dom::BroadcastMessagesAdmin.find!.new_link.click

    expect(Dom::BroadcastMessagesAdmin::Form.find!).not_to have_location_field
  end

  scenario 'shows location field if custom locations configured' do
    Krant.custom_broadcast_message_locations = ['custom']

    visit(admin_broadcast_messages_path)
    Dom::BroadcastMessagesAdmin.find!.new_link.click

    expect(Dom::BroadcastMessagesAdmin::Form.find!).to have_location_field
  end

  scenario 'creating a broadcast message with custom location' do
    Krant.custom_broadcast_message_locations = ['custom']

    visit(admin_broadcast_messages_path)
    Dom::BroadcastMessagesAdmin.find!.new_link.click
    Dom::BroadcastMessagesAdmin::Form.find!.submit_with(text: {
                                                          en: 'English message',
                                                          de: 'Deutsche Nachricht'
                                                        },
                                                        location: 'custom')

    translations = Dom::BroadcastMessagesAdmin::TableRow.find_all

    expect(translations.map(&:location)).to eql(%w(custom))
  end

  scenario 'creating a broadcast message with default location' do
    Krant.custom_broadcast_message_locations = ['custom']

    visit(admin_broadcast_messages_path)
    Dom::BroadcastMessagesAdmin.find!.new_link.click
    Dom::BroadcastMessagesAdmin::Form.find!.submit_with(text: {
                                                          en: 'English message',
                                                          de: 'Deutsche Nachricht'
                                                        })

    translations = Dom::BroadcastMessagesAdmin::TableRow.find_all

    expect(translations.map(&:location)).to eql(%w((Default)))
  end

  scenario 'creating a broadcast message' do
    visit(admin_broadcast_messages_path)
    Dom::BroadcastMessagesAdmin.find!.new_link.click
    Dom::BroadcastMessagesAdmin::Form.find!.submit_with(text: {
                                                          en: 'English message',
                                                          de: 'Deutsche Nachricht'
                                                        })

    translations = Dom::BroadcastMessagesAdmin::TextTranslation.find_all

    expect(translations.map(&:locale)).to eql(%w(en de))
    expect(translations.map(&:text)).to eql(['English message', 'Deutsche Nachricht'])
  end

  scenario 'rewording a broadcast message' do
    create(:broadcast_message, text_translations: { en: 'Old text', de: 'Alter Text' })

    visit(admin_broadcast_messages_path)
    Dom::BroadcastMessagesAdmin::TableRow.find!.edit_link.click
    Dom::BroadcastMessagesAdmin::Form.find!.submit_with(text: {
                                                          en: 'New text',
                                                          de: 'Neuer Text'
                                                        })

    translations = Dom::BroadcastMessagesAdmin::TextTranslation.find_all

    expect(translations.map(&:locale)).to eql(%w(en de))
    expect(translations.map(&:text)).to eql(['New text', 'Neuer Text'])
  end

  scenario 'marking a broadcast message as active' do
    create(:broadcast_message, text_translations: { en: 'Old text', de: 'Alter Text' })

    visit(admin_broadcast_messages_path)
    Dom::BroadcastMessagesAdmin::TableRow.find!.edit_link.click
    Dom::BroadcastMessagesAdmin::Form.find!.submit_with(active: true)

    expect(Dom::BroadcastMessagesAdmin::TableRow.find!).to be_marked_as_active
  end

  scenario 'deleting a broadcast message' do
    create(:broadcast_message)

    visit(admin_broadcast_messages_path)
    Dom::BroadcastMessagesAdmin::TableRow.find!.delete_link.click

    expect(Dom::BroadcastMessagesAdmin::TableRow.find_all.to_a).to be_empty
  end
end
