require 'rails_helper'

require 'support/dominos'

RSpec.feature 'displaying header with broadcast messages' do
  scenario 'displays active broadcast messages' do
    create(:broadcast_message, :active, text_translations: { en: 'Some text', de: 'Etwas Text' })

    visit(admin_dashboard_path)

    broadcast_message_bars = Dom::BroadcastMessageBar.find_all
    expect(broadcast_message_bars.map(&:text)).to eq(['Some text'])
  end

  scenario 'does not display inactive broadcast messages' do
    create(:broadcast_message, text_translations: { en: 'Some text', de: 'Etwas Text' })

    visit(admin_dashboard_path)

    expect(Dom::BroadcastMessageBar.find_all.to_a).to be_empty
  end

  scenario 'renders markdown in broadcast messages' do
    create(:broadcast_message, :active, text_translations: {
      en: 'Some **fat text** and a [link](http://google.com)',
      de: 'Etwas **fetter Text** und ein [Link](http://google.com)'
    })

    visit(admin_dashboard_path)

    broadcast_message_bars = Dom::BroadcastMessageBar.find_all
    expect(broadcast_message_bars.map(&:html).first).to include('<strong>fat text</strong> and a <a href')
  end
end
