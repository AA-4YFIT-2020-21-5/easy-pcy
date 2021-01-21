class RemoveUnusedColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :allow_profile_comments
    remove_column :users, :restricted
    remove_column :roles, :badge
    remove_column :posts, :filtered
    remove_column :posts, :deleted_at
    remove_column :comments, :filtered
    remove_column :comments, :deleted_at
    remove_column :replies, :filtered
    remove_column :replies, :deleted_at
    remove_column :courses, :filtered
    remove_column :courses, :last_edit
    remove_column :chapters, :filtered
    remove_column :chapters, :last_edit
  end
end