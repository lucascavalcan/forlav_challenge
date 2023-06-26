class CreateRevenues < ActiveRecord::Migration[7.0]
  def change
    create_table :revenues, if_not_exists: true do |t|
      t.decimal :total

      t.timestamps
    end
  end
end
