namespace :import do
  task remove_f_cv: :environment do
    Parameter.where("custom_id LIKE 'ASP%.F_CV'").find_each do |old_parameter|
      new_parameter = Parameter.
                      find_by(custom_id: old_parameter.custom_id[0..-6])

      new_parameter.
        update_attributes(parameter_name: old_parameter.parameter_name,
                          device: old_parameter.device,
                          measurement_type: old_parameter.measurement_type)

      old_parameter.destroy!
    end
  end
end
