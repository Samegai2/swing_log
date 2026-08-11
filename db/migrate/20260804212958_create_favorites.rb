class CreateFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :favorites do |t|
      t.bigint :user_id, null: false
      t.bigint :post_id, null: false

      t.timestamps
    end

    add_index :favorites, :user_id
    add_index :favorites, :post_id
    add_index :favorites, [:user_id, :post_id], unique: true

    add_foreign_key :favorites, :users
    add_foreign_key :favorites, :posts
  end
end
