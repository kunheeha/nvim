let wiki_1 = {}
let wiki_1.path = '~/.vimwiki/'

let wiki_2 = {}
let wiki_2.path = '~/.lifewiki/'

let wiki_3 = {}
let wiki_3.path = '~/.gowiki/'

let wiki_4 = {}
let wiki_4.path = '~/.javawiki/'

let g:vimwiki_list = [wiki_1, wiki_2, wiki_3, wiki_4]

call vimwiki#vars#init()
