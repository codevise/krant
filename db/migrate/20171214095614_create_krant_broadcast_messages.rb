class CreateKrantBroadcastMessages < ActiveRecord::Migration
  def change
    create_table :krant_broadcast_messages do |t|
      t.boolean :active

      t.timestamps null: false
    end
  end
end
