module Tmux
  def spawn_new_session(session_name)
    sidestep_nested_restriction do
      run_silent_command("new-session -d -s #{session_name}")
    end
  end

  def spawn_new_session!(session_name)
    ensure_tmux_present
    spawned = spawn_new_session(session_name)
    raise SpawnSessionError unless spawned
  end

  def kill_session(session_name)
    run_silent_command("kill-session -t #{session_name}")
  end

  private

  def ensure_tmux_present
    version_present = run_silent_command('-V')
    raise NotPresentError unless version_present
  end

  def run_silent_command(command)
    system("tmux #{command} &>/dev/null")
  end

  def sidestep_nested_restriction
    if ENV.has_key?('TMUX')
      ENV['TMUX_OLD'] = ENV.delete('TMUX')
    end
    yield
    if ENV.has_key?('TMUX_OLD')
      ENV['TMUX'] = ENV.delete('TMUX_OLD')
    end
  end

  class SpawnSessionError < RuntimeError; end
  class NotPresentError < RuntimeError; end
end

