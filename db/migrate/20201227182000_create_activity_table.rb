class CreateActivityTable < ActiveRecord::Migration[6.0]
  def change
    create_table :activity do |t|
      t.references :user, null: false
      t.string :type
      t.bigint :object_id
      t.string :action
      t.timestamp :timestamp, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
