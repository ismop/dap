require 'importers/scenarios_importer'

namespace :scenarios do
  desc 'Load experiment scenarios from CSV file'
  task :load, [:levee_id,
               :context_id,
               :scenarios_file_path] => :environment do |t, args|
    if_scenario_path_exist!(args[:scenarios_file_path]) do |path|
      Importers::ScenariosImporter.
        new(levee!(args[:levee_id]),
            context!(args[:context_id]), path).import
      puts "Import was finished without any errors"
    end
  end

  private

  def levee!(id)
    Levee.find(id)
  rescue
    puts "ERROR: Levee with id eq #{id} is not found"
    exit 1
  end

  def context!(id)
    Context.find(id)
  rescue
    puts "ERROR: Context with id eq #{id} is not found"
    exit 1
  end

  def if_scenario_path_exist!(path)
    if File.exist?(path)
      yield path
    else
      puts "ERROR: Scenarios file (#{path}) does not exist"
      exit 1
    end
  end
end
