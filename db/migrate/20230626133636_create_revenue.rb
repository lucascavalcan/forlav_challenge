class CreateRevenue < ActiveRecord::Migration[7.0]
  def change
    create_table :revenues do |t|
      t.decimal :total
      #t.decimal :amount, default: 0.00
      t.timestamps
    end
  end
end
