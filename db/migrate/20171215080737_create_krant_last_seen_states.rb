class CreateKrantLastSeenStates < ActiveRecord::Migration[4.2]
  def change
    create_table :krant_last_seen_states do |t|
      t.string :scope
      t.belongs_to :user, index: true, polymorphic: true

      t.timestamps null: false
    end
  end
end
