module AppLab
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = "app_lab_"

    connects_to(**AppLab.connects_to) if AppLab.configuration.separate_database?
  end
end
