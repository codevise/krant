class AddLocationToBroadcastMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :krant_broadcast_messages, :location, :string
  end
end
