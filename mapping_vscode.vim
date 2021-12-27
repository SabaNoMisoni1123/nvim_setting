" mapping for vscode

function! s:split(...) abort
    let direction = a:1
    let file = exists('a:2') ? a:2 : ''
    call VSCodeCall(direction ==# 'h' ? 'workbench.action.splitEditorDown' : 'workbench.action.splitEditorRight')
    if !empty(file)
        call VSCodeExtensionNotify('open-file', expand(file), 'all')
    endif
endfunction

"s commands
nnoremap s <Nop>
nnoremap <Space> <Nop>
" window control
nnoremap ss <Cmd>call <SID>split('h')<CR>
nnoremap sv <Cmd>call <SID>split('v')<CR>
" st is used by defx
nnoremap sj <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
nnoremap sk <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
nnoremap sl <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
nnoremap sh <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
nnoremap sJ <Cmd>call VSCodeNotify('workbench.action.moveEditorToBelowGroup')<CR>
nnoremap sK <Cmd>call VSCodeNotify('workbench.action.moveEditorToAboveGroup')<CR>
nnoremap sL <Cmd>call VSCodeNotify('workbench.action.moveEditorToRightGroup')<CR>
nnoremap sH <Cmd>call VSCodeNotify('workbench.action.moveEditorToLeftGroup')<CR>
nnoremap sn <Cmd>call <SID>switchEditor(v:count, 'next')<CR>
nnoremap sp <Cmd>call <SID>switchEditor(v:count, 'prev')<CR>

nnoremap s= <Cmd>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>
nnoremap s_ <Cmd>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

nnoremap s+ <Cmd>call <SID>manageEditorHeight(v:count, 'increase')<CR>
nnoremap s- <Cmd>call <SID>manageEditorHeight(v:count, 'decrease')<CR>
nnoremap s> <Cmd>call <SID>manageEditorWidth(v:count,  'increase')<CR>
nnoremap s< <Cmd>call <SID>manageEditorWidth(v:count,  'decrease')<CR>


"space commands
noremap <leader>h ^
noremap <leader>l $
noremap <leader>k gg
noremap <leader>j G

nnoremap <leader>q  <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <leader>s  <Cmd>call VSCodeNotify('workbench.action.files.save')<CR>

nnoremap <leader>n  <Cmd>call VSCodeNotify('workbench.files.action.refreshFilesExplorer')<CR>
nnoremap <leader>x  <Cmd>call VSCodeNotify('workbench.action.debug.run')<CR>


" lsp
nnoremap <leader>lh   <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
nnoremap <leader>lc   <SID>vscodeGoToDefinition('revealDeclaration')<CR>
nnoremap <leader>ld   <SID>vscodeGoToDefinition('revealDefinition')<CR>
nnoremap <leader>ls   <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap <leader>li   <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
nnoremap <leader>lf   <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>

" comment
xnoremap c<Space>c <SID>vscodeCommentary()
nnoremap c<Space>c <SID>vscodeCommentary() . '_'

" one push to add/remove tabs
nnoremap > >>
nnoremap < <<

" increase and decrease by plus/minus
nnoremap +  <C-a>
nnoremap -  <C-x>
xnoremap g+ g<C-a>
xnoremap g- g<C-x>

" other
nnoremap O O<ESC>0D

echo("vscode mapping")
