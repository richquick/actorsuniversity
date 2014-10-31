class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :follower_id
      t.integer :pursued_id

      t.timestamps
    end

    add_index :followings, :follower_id
    add_index :followings, :pursued_id
  end
end
