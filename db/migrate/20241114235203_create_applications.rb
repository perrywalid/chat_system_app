class CreateApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :token
      t.integer :chats_count

      t.timestamps
    end
    add_index :applications, :token, unique: true
  end
end
