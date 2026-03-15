module AppLab
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = "app_lab_"

    # connects_to is called by the app_lab.db_connection engine initializer
    # when config.database = :separate is set. This avoids class-load-time
    # issues where configuration may not yet be available.
  end
end
