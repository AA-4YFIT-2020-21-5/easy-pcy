class CreateCourseTables < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :handle
      t.string :title

      t.boolean :filtered
      t.timestamp :last_edit

      t.timestamps
    end

    create_table :chapters do |t|
      # t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :course, null: false, foreign_key: true, index: true
      t.string :handle
      t.string :title

      t.text :content
      t.jsonb :quiz
      t.string :image
      t.string :external_video

      t.boolean :filtered
      t.timestamp :last_edit

      t.timestamps
    end
  end
end
