" Vim syntax file
" Language:         android bugreport file
" Maintainer:       Lucha Chen<lucha.chen@gmail.com>
" Latest Revision:  2017-07-27

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

"syn sync minlines=5

com! -nargs=* BugFoldFunctions <args> fold

" Functions: {{{1
if !exists("g:is_posix")
 syn keyword bugFunctionKey function	skipwhite skipnl nextgroup=bugFunctionmap contained
 syn keyword bugMEMINFOPIDKey  function	skipwhite skipnl nextgroup=bugMEMINFOPID contained
 syn keyword bugVMTRACESKey function	skipwhite skipnl nextgroup=bugVMTRACES  contained
 syn keyword bugTotalPSSbyOOMOneKey function	skipwhite skipnl
             \ nextgroup=bugTotalPSSbyOOMOne contained
 syn keyword bugFunctionAMSKey function	 skipwhite skipnl nextgroup=bugFunctionAMSOne contained
endif

"syn cluster bugFunctionList	contains=@

"------ CHECKIN USAGESTATS (dumpsys -t 30 usagestats -c) ------
"------ BLOCKED PROCESS WAIT-CHANNELS ------
"------ SYSTEM PROPERTIES ------
"------ IPv4 ADDRESSES (ip -4 addr show) ------
BugFoldFunctions syn region bugFunctionThree
                       \ matchgroup=bugFunction start="^-\{6}\s\z([-A-Z46v_& ]\+\)\s\(.*\s\)\?-\{6}$" 
                       \ matchgroup=bugFunction end=+\(-\{6}\s.*s was the duration of\s'\z1'\s-\{6}$\)+
                       \ matchgroup=bugFunction end="^-\{6}\s\([-A-Z46v_& ]\+\)\s\(.*\s\)\?-\{6}$"me=s-1 skipwhite skipnl 
                       \ nextgroup=bugFunction*

"------ PROCESS TIMES (pid cmd user system iowait+percentage) ------
"not end was the duration
BugFoldFunctions syn region bugFunctionProcessTimes
                       \ matchgroup=bugFunction start="^-\{6}\sPROCESS TIMES (pid cmd user system iowait+percentage)\s-\{6}" 
                       \ matchgroup=bugFunction end="\(^-\{6}\s\([-A-Z46v_&]\+\s\)\+\((.*)\)\=\s-\{6}$\)"me=s-1 skipwhite skipnl 
                       \ nextgroup=bugFunction*

"------ DUMPSYS MEMINFO (dumpsys -t 30 meminfo -a) ------
"not end was the duration
BugFoldFunctions syn region bugFunctionMEMINFO
                       \ matchgroup=bugFunction start="^-\{6}\sDUMPSYS MEMINFO (dumpsys -t 30 meminfo -a)\s-\{6}"
                       \ matchgroup=bugFunction keepend end=+\(-\{6}\s.*s was the duration of\s'DUMPSYS MEMINFO'\s-\{6}$\)+ skipwhite skipnl 
                       \ contains=bugMEMINFOPID,bugTotalPSSbyOne,bugTotalPSSbyOOM,bugTotalPSSbyOOMOne
                       \ nextgroup=bugFunction*

BugFoldFunctions syn region bugMEMINFOPID
                       \ matchgroup=bugFunction start="^\*\*\sMEMINFO in pid \d\+ \[.*\]\s\*\*"
                       \ matchgroup=bugFunction end="^\*\*\sMEMINFO in pid \d\+ \[.*\]\s\*\*"me=s-1
                       \ end='^Total PSS by process:'me=s-1
                       \ contains=bugMEMINFOPIDKey contained skipwhite skipnl
                       \ nextgroup=bugTotalPSSbyOne


BugFoldFunctions syn region bugTotalPSSbyOne
                       \ matchgroup=bugFunction start="^Total PSS by .*:$"
                       \ matchgroup=bugFunction end=+\(^$\)+
                       \ contains=NONE contained skipwhite skipnl
                       \ nextgroup=bugTotalPSSbyOne,bugTotalPSSbyOOM

BugFoldFunctions syn region bugTotalPSSbyOOM
                       \ matchgroup=bugFunction start="^Total PSS by OOM adjustment:$"
                       \ matchgroup=bugFunction end=+\(^$\)+
                       \ contains=bugTotalPSSbyOOMOne contained skipwhite skipnl
                       \ nextgroup=NONE

BugFoldFunctions syn region bugTotalPSSbyOOMOne
                       \ matchgroup=bugFunction start="^\([0-9, ]\{11}K:\s[A-Z].*\)"
                       \ matchgroup=bugFunction  end="^\([0-9, ]\{11}K:\s[A-Z].*\)"me=s-1
                       \ end="^$"me=s-1
                       \ contains=bugTotalPSSbyOOMOneKey contained skipwhite skipnl
                       \ nextgroup=bugTotalPSSbyOOMOne

"------ VM TRACES JUST NOW (/data/anr/traces.txt.bugreport: 2017-07-28 "09:40:30) ------
BugFoldFunctions syn region bugFunctionVMTRACES
                       \ matchgroup=bugFunction start="^-\{6}\sVM TRACES JUST NOW (.*)\s-\{6}"
                       \ matchgroup=bugFunction keepend end=+\(-\{6}\s.*s was the duration of\s'VM TRACES JUST NOW'\s-\{6}$\)+ skipwhite skipnl 
                       \ contains=bugVMTRACES
                       \ nextgroup=bugFunction*

BugFoldFunctions syn region bugVMTRACES
                       \ matchgroup=bugFunction start="^\-\{5}\spid \(\d\+\) at .*\s-\{5}"
                       \ matchgroup=bugFunction end="^.*\ze-\{5}\spid \(\d\+\) at .*\s-\{5}"
                       \ contains=bugVMTRACESTwo,bugVMTRACESOne contained skipwhite skipnl
                       \ nextgroup=bugVMTRACES

BugFoldFunctions syn region bugVMTRACESOne
                       \ matchgroup=bugFunction start=+^".*"+
                       \ matchgroup=bugFunction end=+^.*\ze\_^".*"+
                       \ end=+^-\{5} end \d\+ -\{5}+
                       \ contained skipwhite skipnl containedin=bugVMTRACES
                       \ nextgroup=bugVMTRACESOne

BugFoldFunctions syn region bugVMTRACESTwo
                       \ matchgroup=bugFunction start=+^Cmd line:+
                       \ matchgroup=bugFunction end=+^suspend all histogram:+
                       \ end=+\ze\_^"+
                       \ contained skipwhite skipnl containedin=bugVMTRACES
                       \ nextgroup=bugVMTRACESOne



"------ KERNEL LOG (dmesg) ------
BugFoldFunctions syn region bugFunctionKernelLog
                       \ matchgroup=bugFunction start="^-\{6}\s\z(KERNEL LOG (dmesg)\)\s-\{6}" 
                       \ matchgroup=bugFunction end=+\(-\{6}\s.*s was the duration of\s'\z1'\s-\{6}\)+
                       \ nextgroup=bugFunction*

"------ SMAPS OF ALL PROCESSES ------
"------ SHOW MAP 2 ([kthreadd]) (/system/xbin/su root showmap -q 2) ------
BugFoldFunctions syn region bugFunctionsmaps   
                       \ matchgroup=bugFunction start="^-\{6}\sSMAPS OF ALL PROCESSES\s-\{6}" 
                       \ matchgroup=bugFunction  end="^$" skipwhite skipnl 
                       \ contains=bugFunctionmap
                       \ nextgroup=bugFunction*

BugFoldFunctions syn region bugFunctionmap   
                       \ matchgroup=bugFunction start="^-\{6}\s\z(SHOW MAP \([0-9]\+\)\s(.*)\)\s(.*)\s-\{6}"
                       \ matchgroup=bugFunction  end=+^-\{6}\s.*s was the duration of\s'\z1'\s-\{6}$+
                       \ contains=bugFunctionKey,@bugFunctionList contained skipwhite skipnl
                       \ nextgroup=NONE


"========================================================                                                                                  
"== Android Framework Services
"========================================================
BugFoldFunctions syn region bugFunctionAFS
                       \ matchgroup=bugFunction start="^==\sAndroid Framework Services$"
                       \ matchgroup=bugFunction  end="^==\s.*\n=\{56}" skipwhite skipnl 
                       \ contains=bugFunctionAFSAMS,bugFunctionAFSTwo,bugFunctionAFSOne
                       \ nextgroup=bugFunction*

BugFoldFunctions syn region bugFunctionAFSOne
                       \ matchgroup=bugFunction start="^DUMP OF SERVICE\s\z(.*\):"
                       \ matchgroup=bugFunction  end="^DUMP OF SERVICE"me=s-1 skipwhite skipnl
                       \ matchgroup=bugFunction  end=+^-\{6}\s.*s was the duration of 'DUMPSYS'+me=s-1 skipwhite skipnl
                       \ contains=NONE nextgroup=NONE contained

BugFoldFunctions syn region bugFunctionAFSTwo
                       \ matchgroup=bugFunction start="^Currently running services:"
                       \ matchgroup=bugFunction  end="^-\{79}$" skipwhite skipnl
                       \ contains=NONE nextgroup=NONE contained

BugFoldFunctions syn region bugFunctionAFSAMS
                       \ matchgroup=bugFunction start="^DUMP OF SERVICE activity:"
                       \ matchgroup=bugFunction  end="^DUMP OF SERVICE"me=s-1 skipwhite skipnl
                       \ contains=bugFunctionAMSOne nextgroup=NONE contained

BugFoldFunctions syn region bugFunctionAMSOne
                       \ matchgroup=bugFunction start="^ACTIVITY MANAGER\s"
                       \ matchgroup=bugFunction  end="^-\{79}$"
                       \ end="^-\{9} .*s was the duration of dumpsys activity"me=s-1  skipwhite skipnl
                       \ contains=bugFunctionAMSKey nextgroup=NONE contained

" Sync at the beginning of class, function, or method definition.
"syn sync match bugSync grouphere NONE "^-\{6}\s.*\s-\{6}"



hi def link bugreportDate        Constant
hi def link bugreportHour        Type
hi def link bugreportDateRFC3339 Constant
hi def link bugreportHourRFC3339 Type
hi def link bugreportRFC3339T    Normal
hi def link bugreportHost        Identifier
hi def link bugreportLabel       Operator
hi def link bugreportPID         Constant
hi def link bugreportKernel      Special
hi def link bugreportError       ErrorMsg
hi def link bugreportIP          Constant
hi def link bugreportURL         Underlined
hi def link bugreportText        Normal
hi def link bugreportNumber      Number

hi def link bugFunction	         ErrorMsg


delc BugFoldFunctions


set foldtext=BugFoldText()
if exists('*BugFoldText')
  "comment for debug
  "finish
endif

function! BugFoldText()
  let l:start_num = nextnonblank(v:foldstart)
  let l:end_num = prevnonblank(v:foldend)

  if l:end_num <= l:start_num + 1
    " If the fold is empty, don't print anything for the contents.
    let l:content = 'EMPTY'
  else
    " Otherwise look for something matching the content regex.
    " And if nothing matches, print an ellipsis.
    let l:content = '...'
    let l:line = getline(l:start_num)
    if l:line =~ '^-\{5}\spid \(\d\+\) at .*\s-\{5}$'
      let l:content = substitute(getline(l:start_num+1), 'Cmd line:', '', '')
      let l:end_num = 0
    elseif l:line =~ "^\""
      let l:end_num = 0
      for l:line in getline(l:start_num + 1, l:end_num - 1)
        let l:content_match = matchlist(l:line, '^\s\s| \(state=.\)')[1]
        if !empty(l:content_match)
          let l:content = l:content_match
          break
        endif
      endfor
    end
    "for l:line in getline(l:start_num + 1, l:end_num - 1)
    "  let l:content_match = matchstr(l:line, '^-\{5}\spid \(\d\+\) at .*\s-\{5}$')
    "  if !empty(l:content_match)
    "    let l:content = l:content_match
    "    break
    "  endif
    "endfor
  endif

  " Enclose content with start and end
  "let l:start_text = substitute(getline(l:start_num), '-\{2,}','','g')
  let l:start_text = getline(l:start_num)
  let l:end_text = substitute(getline(l:end_num), '^\s*', '', '')
  let l:text = l:start_text . ' ' . l:content . ' ' . l:end_text

  " Compute the available width for the displayed text.
  let l:width = winwidth(0) - &foldcolumn - (&number ? &numberwidth : 0)
  let l:lines_folded = ' ' . string(1 + v:foldend - v:foldstart) . ' lines'

  " Expand tabs, truncate, pad, and concatenate
  let l:text = substitute(l:text, '\t', repeat(' ', &tabstop), 'g')
  let l:text = strpart(l:text, 0, l:width - len(l:lines_folded))
  let l:padding = repeat(' ', l:width - len(l:lines_folded) - len(l:text))
  return l:text . l:padding . l:lines_folded
endfunction

let b:current_syntax = "abug"

let &cpo = s:cpo_save
unlet s:cpo_save
