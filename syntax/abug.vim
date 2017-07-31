" Vim syntax file
" Language:         android bugreport file
" Maintainer:       Lucha Chen<lucha.chen@gmail.com>
" Latest Revision:  2017-07-27

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

com! -nargs=* BugFoldFunctions <args> fold

" Functions: {{{1
if !exists("g:is_posix")
 syn keyword bugFunctionKey function	skipwhite skipnl nextgroup=bugFunctionmap
 syn keyword bugFunctionAMSKey function	 skipwhite skipnl nextgroup=bugFunctionAMSOne
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
                       \ contains=bugFunctionmap nextgroup=bugFunction*

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
                       \ contains=bugFunctionAFSAMS,bugFunctionAFSTwo,bugFunctionAFSOne nextgroup=bugFunction*

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

hi def link bugFunction	         Function


delc BugFoldFunctions
let b:current_syntax = "abug"

let &cpo = s:cpo_save
unlet s:cpo_save
