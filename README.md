# splice.vim

Make it simple to talk to tmux.

Initial motivation: Get vim-spec-runner sending commands to another tmux session.

```
function! Splice()
  let sessions = system("tmux list-sessions -F '#{session_name}'")
  let target   = input('Enter target: ')
  let target_session = matchstr(target, '[[:alnum:]_-]\+')

  if (sessions =~ target_session) && (target_session != '')
    let g:spec_runner_dispatcher = "call system(\"tmux send -t "
          \                        . target .
          \                        " C-L '{command}' ENTER\")"
  else
    let g:spec_runner_dispatcher = "VtrSendCommand! {command}"
  endif
endfunction
```

Concept
Provide a flexible interface for setting a tmux target.
Use target to build a command that communicates with tmux.
Set a configurable global variable to that command.

Ideas for improvement
- Tab completion: given a running session 'my-session' with window 7
                  named 'tests', set the target to my-session:7.1
  Enter target:
  'my-se<Tab>'              -> 'my-session'
  'my-session:tes<Tab>'     -> 'my-session:7'
  'my-session:7.<Tab><Tab>' -> 'my-session:7.1'

  'my-se<Tab>:tes<Tab>.<Tab><Tab>' -> 'my-session:7.1'

  Completing a window name inserts the number of the first matching window.
  If multiple windows match, cycle through them.

  Omitting window or window-and-pane allows the default tmux behavior,
  targetting the active window and/or pane in the targeted session.

Inspiration from tslime
- Allow use of paste-buffer as well as send-keys
  - paste-buffer would be nice to do what tslime does
  - send-keys might still be necessary for use with vim-spec-runner

API commands:
:Target
:SendKeys
:PasteBuffer
