class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :components_users, id: :uuid do |t|
      t.string :friendly_name, unique: true, null: false, index: true

      t.timestamps
    end

    add_index :components_users, :id, unique: true, if_not_exists: true
  end
end
