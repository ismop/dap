class AddNameToProfiles < ActiveRecord::Migration
  def up
    add_column :profiles, :name, :string, null: false, default: 'unnamed profile'

    Profile.all.each do |p|
      if p.devices.present?
        mfg = p.devices.first.device_type.split('-').first
      else
        mfg = ''
      end

      p_id = p.custom_id.split('_'),last
      if p_id == 'unknown ID'
        p_id = p.id.to_s
      end

      p.name = "Profil #{mfg}: #{p_id}"
      p.save
    end

  end

  def down
    remove_column :profiles, :name
  end
end
