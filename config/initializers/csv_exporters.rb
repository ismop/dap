require 'fileutils'

csv_export_dir = File.join(Dir.tmpdir, "dap_csv_exports")
Dir.mkdir(csv_export_dir) unless File.exists?(csv_export_dir)

Rails.application.config.csv_export_dir = csv_export_dir