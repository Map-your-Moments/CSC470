class AddLongitudeColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :longitude, :decimal, :precision => 15, :scale => 10
  end
end
