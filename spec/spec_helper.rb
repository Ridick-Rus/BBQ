require 'simplecov'
require 'database_cleaner/active_record'

SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/'

  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Libraries', 'lib/'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction # Используется для большинства тестов
    DatabaseCleaner.clean_with(:truncation) # Полная очистка перед запуском
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction # Используется для большинства тестов
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.mock_with :rspec do |mocks|

    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
