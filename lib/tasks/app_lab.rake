namespace :app_lab do
  namespace :db do
    desc "Setup App Lab database tables (via migrations)"
    task setup: :environment do
      Rake::Task["db:migrate"].invoke
      Rake::Task["app_lab:db:seed"].invoke
      puts "App Lab database setup complete."
    end

    desc "Seed default best practice categories and items"
    task seed: :environment do
      Rake::Task["app_lab:db:seed_practices"].invoke
      Rake::Task["app_lab:db:seed_insight_rules"].invoke
      puts "App Lab seed data loaded."
    end

    desc "Seed best practice categories and items"
    task seed_practices: :environment do
      AppLab::Services::Practices::Seeder.seed!
    end

    desc "Seed insight rules"
    task seed_insight_rules: :environment do
      AppLab::Services::Insights::RuleSeeder.seed!
    end
  end

  desc "Run daily commit scan"
  task scan_commits: :environment do
    AppLab::DailyCommitScanJob.perform_now
  end

  desc "Run security scan"
  task security_scan: :environment do
    AppLab::SecurityScanJob.perform_now
  end

  desc "Run best practice verification"
  task verify_practices: :environment do
    AppLab::BestPracticeVerificationJob.perform_now
  end

  desc "Run insight scan"
  task insight_scan: :environment do
    AppLab::InsightScanJob.perform_now
  end

  desc "Run all daily tasks"
  task daily: :environment do
    Rake::Task["app_lab:scan_commits"].invoke
    Rake::Task["app_lab:verify_practices"].invoke
    Rake::Task["app_lab:insight_scan"].invoke
  end
end
