require 'spec_helper'

describe "Splice" do
  let(:session_names) { (1..3).map { |i| "splice-test-session-#{i}" } }

  around(:each) do |example|
    refresh_tmux_sessions(session_names, &example)
  end

  describe "setting a target" do
    it "takes user input" do
      target = "#{session_names.first}:0.0"

      vim.feedkeys ":SetTarget\\<CR>"
      vim.feedkeys "#{target}\\<CR>"

      expect(vim.command("ShowTarget")).to match(/#{target}/)
    end

    describe "tab completion" do
      it "lists sessions" do
        completions = vim.command("CompleteSession '' '' 0").split("\n")
        expect(completions).to include(*session_names)
      end
    end
  end
end
