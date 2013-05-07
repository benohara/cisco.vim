" Vim syntax file
" Language:     Cisco IOS config file
" Last Change:  2008-07-16

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

setlocal iskeyword+=/
setlocal iskeyword+=:
setlocal iskeyword+=.
setlocal iskeyword+=-

syn match ciscoComment  "^\s*!.*$"
hi def link ciscoComment Comment

syn match ciscoIfName /\<\(Loopback\|Tunnel\|Dialer\)[0-9][0-9]*\>/
syn match ciscoIfName +\<\(Ethernet\|FastEthernet\|GigabitEthernet\)[0-9][0-9]*/[0-9][0-9]*\(/[0-9][0-9]*\)\?\(\.[0-9][0-9]*\)\?\>+
syn match ciscoIfName +\<ATM[0-9][0-9]*\(/[0-9][0-9]*\)*\(\.[0-9][0-9]*\)\?\>+
hi def link ciscoIfName Identifier

syn match ciscoWord contained +[a-zA-Z0-9-_]*+
hi def link ciscoWord String


syn region ciscoUsernames start=+^username\s+ skip=+^username\s+ end=+^\S+me=s-1 fold
syn region ciscoIpHosts start=+^ip host\s+ skip=+^ip host\s+ end=+^\S+me=s-1 fold

syn region ciscoInterfaces start=+^interface\s+ skip=+^\(!\n\)\?interface\s+ end=+^\S+me=s-1 fold contains=ciscoInterfaceRegion
syn region ciscoInterfaceRegion contained start=+^interface\s+ end=+^\S+me=s-1 fold contains=ciscoip,ciscoip6,ciscoIfName,ciscoComment,ciscoInterfaceKeywords,ciscoInterfaceOperator,ciscoInterfaceIdentifiers
syn keyword ciscoInterfaceKeywords contained skipwhite ip ipv6 glbp description encapsulation
hi def link ciscoInterfaceKeywords Keyword
syn keyword ciscoInterfaceIdentifiers contained skipwhite access-group traffic-filter priority weighting load-balancing dot1Q ospf address
hi def link ciscoInterfaceIdentifiers Identifier
syn keyword ciscoInterfaceOperator contained skipwhite in out no preempt enable
hi def link ciscoInterfaceOperator Special

syn region ciscoRouters start=+^router\s+ skip=+^\(!\n\)\?router\s+ end=+^\S+me=s-1 fold contains=ciscoRouterRegion
syn region ciscoRouterRegion start=+^router\s+ end=+^\S+me=s-1 contained fold contains=ciscoip,ciscoip6,ciscoIfName,ciscoComment

syn region ciscoIpRoutes start=+^ip route\s+ end=+^\(ip route\)\@!+me=s-1 fold contains=ciscoIpRoute
syn match ciscoIpRoute +^ip route.*$+ contained skipwhite contains=ciscoip,ciscoip6,ciscoNumber,ciscoIfName

syn region ciscoIpAccessLists start=+^ip access-list\s+ skip=+^\(!\n\)\?ip access-list\s+ end=+^\S+me=s-1 fold contains=ciscoIpAccessList
syn region ciscoIpAccessList contained start=+^ip access-list\s+ end=+^\S+me=s-1 fold contains=ciscoIpAccessListNamed,ciscoip,ciscoip6,ciscoIfName,ciscoComment,ciscoAclKeywords,ciscoAclOperator
syn match ciscoIpAccessListNamed +^ip access-list \(standard\|extended\) + contained nextgroup=ciscoWord skipwhite
syn keyword ciscoAclKeywords contained skipwhite host any
syn keyword ciscoAclOperator contained skipwhite eq ne
hi def link ciscoAclKeywords Keyword
hi def link ciscoAclOperator Special

syn region ciscoAccessLists start=+^access-list\s+ skip=+^access-list\s+ end=+^\S+me=s-1 fold contains=ciscoAccessList
syn region ciscoAccessList start=+^access-list \z(\d\+\)\ + skip=+^access-list \z1 + end=+^\S+me=s-1 contained fold contains=ciscoip,ciscoip6,ciscoIfName

syn region ciscoRouteMaps start=+^route-map\s+ skip=+^\(!\n\)\?route-map\s+ end=+^\S+me=s-1 fold contains=ciscoRouteMap
syn region ciscoRouteMap contained start=+^route-map\s+ end=+^\S+me=s-1 fold contains=ciscoip,ciscoip6,ciscoIfName,ciscoComment

syn region ciscoCryptoIsakmp start=+^crypto isakmp\s+ end=+^\S+me=s-1 fold

syn region ciscoCryptoIsakmpKeys start=+^crypto isakmp key\s+ skip=+^crypto isakmp key\s+ end=+^\S+me=s-1 fold

syn region ciscoCryptoIpsecTses start=+^crypto ipsec transform-set\s+ skip=+^crypto ipsec transform-set\s+ end=+^\S+me=s-1 fold contains=ciscoCryptoIpsecTs
syn match ciscoCryptoIpsecTs contained +^crypto ipsec transform-set + nextgroup=ciscoWord skipwhite

syn region ciscoCryptoMaps start=+^crypto map\s+ skip=+^crypto map\s+ end=+^\S+me=s-1 fold contains=ciscoCryptoMap
syn region ciscoCryptoMap start=+^crypto map \z(\S\+\)\ + skip=+^crypto map \z1 + end=+^\S+me=s-1 contained fold contains=ciscoCryptoMapEntry
syn region ciscoCryptoMapEntry contained start=+^crypto map\s+ end=+^\S+me=s-1 fold contains=ciscoCryptoMapName,ciscoip,ciscoip6
syn match ciscoCryptoMapName contained +^crypto map + nextgroup=ciscoWord skipwhite

" syntax case ignore
setlocal foldmethod=syntax
syn sync fromstart

" keywords
syntax keyword  aclCmd          permit
syntax keyword  aclDeny         deny
syntax keyword  aclHost         host
syntax keyword  aclPort         bgp chargen cmd daytime discard domain
syntax keyword  aclPort         echo exec finger ftp ftp-data gopher
syntax keyword  aclPort         hostname ident irc klogin kshell login
syntax keyword  aclPort         lpd nntp pim-auto-rp pop2 pop3 smtp sunrpc
syntax keyword  aclPort         syslog tacacs talk telnet time uucp whois
syntax keyword  aclPort         www biff bootpc bootps dnsix echo isakmp
syntax keyword  aclPort         mobile-ip nameserver netbios-dgm netbios-ns
syntax keyword  aclPort         netbios-ss ntp rip snmp snmptrap sunrpc
syntax keyword  aclPort         syslog talk tftp time who xdmcp

" protocols
syntax keyword aclProto         icmp ip tcp udp ipv6
syntax keyword aclSrcDst        any
syntax keyword aclLog           log logging

" regexps
syntax match    aclACL          /^access-list\s+/
" TODO: differentiate network address/mask
syntax match    ciscoip         /\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}/
"   Plain IPv6 address          IPv6-embedded-IPv4 address
"   1111:2:3:4:5:6:7:8          1111:2:3:4:5:6:127.0.0.1
syn match       ciscoip6        /\<\(\x\{1,4}:\)\{6}\(\x\{1,4}:\x\{1,4}\|\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   ::[...:]8                   ::[...:]127.0.0.1
syn match       ciscoip6        /\s\@<=::\(\(\x\{1,4}:\)\{,6}\x\{1,4}\|\(\x\{1,4}:\)\{,5}\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111::[...:]8               1111::[...:]127.0.0.1
syn match       ciscoip6        /\<\(\x\{1,4}:\)\{1}:\(\(\x\{1,4}:\)\{,5}\x\{1,4}\|\(\x\{1,4}:\)\{,4}\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111:2::[...:]8             1111:2::[...:]127.0.0.1
syn match       ciscoip6        /\<\(\x\{1,4}:\)\{2}:\(\(\x\{1,4}:\)\{,4}\x\{1,4}\|\(\x\{1,4}:\)\{,3}\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111:2:3::[...:]8           1111:2:3::[...:]127.0.0.1
syn match       ciscoip6        /\<\(\x\{1,4}:\)\{3}:\(\(\x\{1,4}:\)\{,3}\x\{1,4}\|\(\x\{1,4}:\)\{,2}\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111:2:3:4::[...:]8         1111:2:3:4::[...:]127.0.0.1
syn match       ciscoip6        /\<\(\x\{1,4}:\)\{4}:\(\(\x\{1,4}:\)\{,2}\x\{1,4}\|\(\x\{1,4}:\)\{,1}\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111:2:3:4:5::[...:]8       1111:2:3:4:5::127.0.0.1
syn match       ciscoip6        /\<\(\x\{1,4}:\)\{5}:\(\(\x\{1,4}:\)\{,1}\x\{1,4}\|\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111:2:3:4:5:6::8           -
syn match       ciscoip6        /\<\(\x\{1,4}:\)\{6}:\x\{1,4}\>/
"   1111[:...]::                -
syn match       ciscoip6        /\<\(\x\{1,4}:\)\{1,7}:\(\s\|;\|$\)\@=/
syn match       ciscoip6        /\<\(\x\{1,4}:\)\{1,7}:\/\(\x\{1,3}\)\(\s\|;\|$\)\@=/


"
" syntax match ciscocomment /^!.*/
""syntax keyword  aclTodo   eon   remark          start="^access-list.*remark" end="$" contains=aclACL,aclDefine
syntax region   remark          start="remark " end="$"

"syntax region  portspec        start="eq" end="\s*[a-z0-9]*"
"syntax region  portspec        start="range" end="\s*[a-z0-9]*\s*[a-z0-9]*"

syntax match    aclGenericNum   /\<\d\+\>/



" Define the default hightlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_cisco_syn_inits")
    if version < 508
       let did_cisco_syn_inits = 1
       command -nargs=+ HiLink hi link <args>
    else
       command -nargs=+ HiLink hi def link <args>
    endif

    " special highlighting for deny keyword
    hi Deny guifg=LightRed ctermfg=White ctermbg=Red term=underline

    HiLink aclDeny          Deny
    HiLink aclCmd           Statement
    HiLink ciscoip          Type
    HiLink ciscoip6         Type
    HiLink remark           String
    HiLink ciscocomment     Comment
    HiLink portspec         Type
    HiLink aclDefine        Identifier
    HiLink aclGenericNum    Constant
    HiLink aclPort          Constant
    HiLink aclSrcDst        Type
    HiLink aclTodo          Todo

    HiLink aclProto         Identifier
    HiLink aclLog           Identifier

    delcommand HiLink
endif

let b:current_syntax = "cisco"

" vim: set ts=4
