class AddDataFileToSales < ActiveRecord::Migration[7.0]
  def change
    add_column :sales, :data_file, :binary
  end
end
