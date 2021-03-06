require 'vimrunner'
require 'vimrunner/rspec'
require 'support/tmux'

include Tmux

ROOT = File.expand_path('../..', __FILE__)

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  config.start_vim do
    vim = Vimrunner.start
    vim.add_plugin(ROOT, 'plugin/splice.vim')
    vim
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.warnings = true

  config.order = :random
end

def refresh_tmux_sessions(session_names, &block)
  session_names.each { |name| spawn_new_session!(name) }
  yield
  session_names.each { |name| kill_session(name) }
end
