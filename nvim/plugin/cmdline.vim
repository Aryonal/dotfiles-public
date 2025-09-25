command WQ wq
command Wq wq
command W w
command Q q
command Qa qa

cnoreabbrev <expr> tq (getcmdtype() ==# ':' && getcmdline() ==# 'tq') ? 'tabclose' : 'tq'
cnoreabbrev <expr> te (getcmdtype() ==# ':' && getcmdline() ==# 'te') ? 'tabe %' : 'te'
cnoreabbrev <expr> tn (getcmdtype() ==# ':' && getcmdline() ==# 'tn') ? 'tabnew' : 'tn'
cnoreabbrev <expr> tt (getcmdtype() ==# ':' && getcmdline() ==# 'tt') ? 'tabnew +term' : 'tt'

cnoreabbrev <expr> er (getcmdtype() ==# ':' && getcmdline() ==# 'er') ? 'e .' : 'er'
cnoreabbrev <expr> ep (getcmdtype() ==# ':' && getcmdline() ==# 'ep') ? 'e %:~:.:h' : 'ep'

command CopyPathAbs echo 'Copied ' . expand("%:p") . ' to clipboard' | let @+=expand("%:p")
command CopyPath    echo 'Copied ' . expand("%:~:.:p") . ' to clipboard' | let @+=expand("%:~:.:p")
command CopyDirAbs  echo 'Copied ' . expand("%:p:h") . ' to clipboard' | let @+=expand("%:p:h")
command CopyDir     echo 'Copied ' . expand("%:~:.:p:h") . ' to clipboard' | let @+=expand("%:~:.:p:h")
command CopyWorkDir echo 'Copied ' . expand(".:~:.:p:h") . ' to clipboard' | let @+=expand(".:~:.:p:h")
