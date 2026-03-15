module AppLab
  class ApplicationJob < ActiveJob::Base
    queue_as :app_lab

    retry_on StandardError, wait: :polynomially_longer, attempts: 3

    around_perform do |_job, block|
      AppLab.logger.info("Starting #{self.class.name}")
      block.call
      AppLab.logger.info("Completed #{self.class.name}")
    rescue => e
      AppLab.logger.error("Failed #{self.class.name}: #{e.message}")
      raise
    end
  end
end
