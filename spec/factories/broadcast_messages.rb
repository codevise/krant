FactoryBot.define do
  factory(:broadcast_message, class: Krant::BroadcastMessage) do
    trait :active do
      active true
    end

    transient do
      text_translations({})
    end

    after(:create) do |broadcast_message, evaluator|
      evaluator.text_translations.each do |locale, text|
        create(:broadcast_message_translation,
               broadcast_message: broadcast_message,
               locale: locale,
               text: text )
      end
    end
  end
end
