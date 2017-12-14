class CreateKrantBroadcastMessageTranslations < ActiveRecord::Migration
  def change
    create_table :krant_broadcast_message_translations do |t|
      t.belongs_to(:broadcast_message,
                   index: { name: 'index_krant_broadcast_message_translations_on_message_id' },
                   foreign_key: true)
      t.string :locale
      t.text :text

      t.timestamps null: false
    end
  end
end
