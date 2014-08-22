let s:plugin_path = expand("<sfile>:p:h:h")

if !exists("g:rspec_runner")
  let g:rspec_runner = "os_x_terminal"
endif

if !exists("g:rspec_command")
  let s:cmd = "bin/rspec {spec}"

  if has("gui_running") && has("gui_macvim")
    let g:rspec_command = "silent !" . s:plugin_path . "/bin/" . g:rspec_runner . " '" . s:cmd . "'"
  else
    let g:rspec_command = "!clear && echo " . s:cmd . " && " . s:cmd
  endif
endif

if !exists("g:cucumber_command")
  let s:cmd = "cucumber {spec}"
  let g:cucumber_command = "!clear && echo " . s:cmd . " && " . s:cmd
endif

function! RunAllSpecs()
  let l:spec = "spec"
  call SetLastSpecCommand(l:spec)
  call RunSpecs(l:spec)
endfunction

function! RunCurrentSpecFile()
  if InSpecFile()
    let l:spec = @%
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
  else
    call RunLastSpec()
  endif
endfunction

function! RunNearestSpec()
  if InSpecFile()
    let l:spec = @% . ":" . line(".")
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
  else
    call RunLastSpec()
  endif
endfunction

function! RunLastSpec()
  if exists("s:last_spec_command")
    call RunSpecs(s:last_spec_command)
  endif
endfunction

function! InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1 || match(expand("%"), ".feature$") != -1
endfunction

function! InCucumberFile()
  return match(expand("%"), ".feature$") != -1
endfunction

function! SetLastSpecCommand(spec)
  let s:last_spec_command = a:spec
endfunction

function! RunSpecs(spec)
  if InCucumberFile()
    execute substitute(g:cucumber_command, "{spec}", a:spec, "g")
  else
    execute substitute(g:rspec_command, "{spec}", a:spec, "g")
  endif
endfunction
