class CreateKrantNewsItems < ActiveRecord::Migration
  def change
    create_table :krant_news_items do |t|
      t.string :scope
      t.string :name

      t.timestamps null: false
    end
  end
end
