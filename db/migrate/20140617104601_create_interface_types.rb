class CreateInterfaceTypes < ActiveRecord::Migration
  def change
    create_table :interface_types do |t|
      t.string :name,               null:false, default:"unnamed interface type"
      t.timestamps
    end

  end
end
