class CreateForumTables < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.text :content
      t.jsonb :votes
      t.boolean :filtered
      t.timestamp :last_edit
      t.timestamp :deleted_at

      t.timestamps
    end

    create_table :comments do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :post, null: false, foreign_key: true, index: true
      t.text :content
      t.jsonb :votes
      t.boolean :filtered
      t.timestamp :last_edit
      t.timestamp :deleted_at

      t.timestamps
    end

    create_table :replies do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :comment, null: false, foreign_key: true, index: true
      t.text :content
      t.jsonb :votes
      t.boolean :filtered
      t.timestamp :last_edit
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
