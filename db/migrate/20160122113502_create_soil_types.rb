class CreateSoilTypes < ActiveRecord::Migration
  def up
    remove_reference :sections, :ground_type
    drop_table :ground_types

    create_table :soil_types do |t|
      t.string :label
      t.string :name
      t.float :bulk_density_min
      t.float :bulk_density_max
      t.float :bulk_density_avg
      t.float :granular_density_min
      t.float :granular_density_max
      t.float :granular_density_avg
      t.float :filtration_coefficient_min
      t.float :filtration_coefficient_max
      t.float :filtration_coefficient_avg
    end

    add_reference :sections, :soil_type, index: true

    [
      ['A', 'szary', 1.79, 2.00, 1.90, 1.62, 1.75, 1.67, 0.00000331, 0.0000264, 0.0000122],
      ['B', 'żółty', 1.95, 2.18, 2.07, 1.81, 1.95, 1.87, 0.00000103, 0.00000916, 0.00000357],
      ['C', 'mix', 1.89, 2.04, 1.96, 1.77, 1.86, 1.80, 0.0000321, 0.0000725, 0.0000524],
      ['D', 'kłokoczyn', 1.86, 2.01, 1.94, 1.74, 1.83, 1.79, 0.0000225, 0.0000725, 0.0000386],
      ['E', 'zakole', 1.80, 1.99, 1.95, 1.51, 1.66, 1.58, 0.000000526, 0.000000556, 0.000000541]
    ].each do |s|
      execute("INSERT INTO soil_types (label, name, bulk_density_min, bulk_density_max, bulk_density_avg,\
        granular_density_min, granular_density_max, granular_density_avg,\
        filtration_coefficient_min, filtration_coefficient_max, filtration_coefficient_avg)
        VALUES
        ('#{s[0]}', '#{s[1]}', #{s[2]}, #{s[3]}, #{s[4]}, #{s[5]}, #{s[6]}, #{s[7]}, #{s[8]}, #{s[9]}, #{s[10]})")
    end
  end

  def down
    remove_reference :sections, :soil_type
    drop_table :soil_types

    create_table :ground_types do |t|
      t.string :label,             null: false, default: 'unknown ground type'
      t.string :description
    end

    add_reference :sections, :ground_type, references: :ground_types, index: true, null: true
  end
end