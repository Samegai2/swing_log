class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :facility_name
      t.string :address
      t.integer :play_style
      t.integer :score
      t.text :body

      t.timestamps
    end
  end
end
