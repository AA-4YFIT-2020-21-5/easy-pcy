class CreateGeneralTables < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name, index: { unique: true }
      t.boolean :badge
      t.boolean :moderation_privileges
      t.boolean :administration_privileges
    end

    create_table :users do |t|
      t.string :email, index: { unique: true }

      t.references :role, foreign_key: true

      t.string :display_name
      t.string :password_digest
      t.text :description
      t.boolean :allow_profile_comments
      t.boolean :hide_forum_activity
      t.boolean :hide_course_activity
      t.boolean :restricted
      t.jsonb :progress

      t.timestamps
    end
  end
end
