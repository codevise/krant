require 'rails_helper'

require 'support/dominos'

RSpec.feature 'displaying custom location broadcast messages' do
  scenario 'displays active broadcast messages for location' do
    create(:broadcast_message,
           :active,
           location: 'custom',
           text_translations: { en: 'Some text', de: 'Etwas Text' })

    visit(admin_custom_broadcast_message_location_path)

    broadcast_message_bars = Dom::BroadcastMessageBar.find_all
    expect(broadcast_message_bars.map(&:text)).to eq(['Some text'])
  end

  scenario 'does not display inactive broadcast messages' do
    create(:broadcast_message,
           location: 'custom',
           text_translations: { en: 'Some text', de: 'Etwas Text' })

    visit(admin_custom_broadcast_message_location_path)

    expect(Dom::BroadcastMessageBar.find_all.to_a).to be_empty
  end

  scenario 'renders markdown in broadcast messages' do
    create(:broadcast_message,
           :active,
           location: 'custom',
           text_translations: {
             en: 'Some **fat text** and a [link](http://google.com)',
             de: 'Etwas **fetter Text** und ein [Link](http://google.com)'
           })

    visit(admin_custom_broadcast_message_location_path)

    broadcast_message_bars = Dom::BroadcastMessageBar.find_all
    expect(broadcast_message_bars.map(&:html).first)
      .to include('<strong>fat text</strong> and a <a href')
  end

  describe 'with custom wrapper' do
    scenario 'renders wrapper' do
      create(:broadcast_message,
             :active,
             location: 'custom',
             text_translations: {
               en: 'Message',
               de: 'Nachricht'
             })

      visit(admin_custom_broadcast_message_location_with_custom_wrapper_path)

      expect(page).to have_selector('.custom_wrapper .custom_item_class')
    end

    scenario 'does not render wrapper if no messages' do
      visit(admin_custom_broadcast_message_location_with_custom_wrapper_path)

      expect(page).not_to have_selector('.custom_wrapper')
    end
  end
end
