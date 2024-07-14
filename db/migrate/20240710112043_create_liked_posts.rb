class CreateLikedPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :liked_posts do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end
end
