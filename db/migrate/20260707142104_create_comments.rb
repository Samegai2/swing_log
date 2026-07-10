class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false

      t.bigint :user_id, null: false
      t.bigint :post_id, null: false

      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :post_id

    add_foreign_key :comments, :users
    add_foreign_key :comments, :posts

  end
end
