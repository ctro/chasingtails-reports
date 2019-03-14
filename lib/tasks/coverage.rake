namespace :test do
  desc 'Run tests AND Simplecov'
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task['test'].execute
  end
end
