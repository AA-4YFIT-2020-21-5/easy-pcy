class AddColumnsToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :visits, :bigint, null: false, default: 0
  end
end