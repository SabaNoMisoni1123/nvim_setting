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
nnoremap ss   <Cmd>call <SID>split('h')<CR>
nnoremap sv   <Cmd>call <SID>split('v')<CR>
nnoremap sj   <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
nnoremap sk   <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
nnoremap sl   <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
nnoremap sh   <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
nnoremap sJ   <Cmd>call VSCodeNotify('workbench.action.moveEditorToBelowGroup')<CR>
nnoremap sK   <Cmd>call VSCodeNotify('workbench.action.moveEditorToAboveGroup')<CR>
nnoremap sL   <Cmd>call VSCodeNotify('workbench.action.moveEditorToRightGroup')<CR>
nnoremap sH   <Cmd>call VSCodeNotify('workbench.action.moveEditorToLeftGroup')<CR>
nnoremap sz   <Cmd>call VSCodeNotify('workbench.action.createTerminalEditorSide')<CR>
nnoremap sx   <Cmd>call VSCodeNotify('workbench.action.createTerminalEditor')<CR>
nnoremap s=   <Cmd>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>
nnoremap s_   <Cmd>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
nnoremap s+   <Cmd>call VSCodeNotify('workbench.action.increaseViewHeight')<CR>
nnoremap s-   <Cmd>call VSCodeNotify('workbench.action.decreaseViewHeight')<CR>
nnoremap s>   <Cmd>call VSCodeNotify('workbench.action.increaseViewWidth')<CR>
nnoremap s<   <Cmd>call VSCodeNotify('workbench.action.decreaseViewWidth')<CR>
nnoremap sn   <Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>
nnoremap sp   <Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>


"space commands
noremap   <leader>h ^
noremap   <leader>l $
noremap   <leader>k gg
noremap   <leader>j G

nnoremap  <leader>q   <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap  <leader>s   <Cmd>call VSCodeNotify('workbench.action.files.save')<CR>
nnoremap  <leader>n   <Cmd>call VSCodeNotify('workbench.files.action.focusFilesExplorer')<CR>
nnoremap  <leader>x   <Cmd>call VSCodeNotify('workbench.action.debug.run')<CR>

nnoremap  <leader>r   <Cmd>call VSCodeNotify('workbench.action.reloadWindow')<CR>


" lsp
nnoremap <leader>lc   <Cmd>call VSCodeNotify('editor.action.revealDeclaration')<CR>
nnoremap <leader>ld   <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
nnoremap <leader>lh   <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
nnoremap <leader>li   <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
nnoremap <leader>lt   <Cmd>call VSCodeNotify('editor.action.toggleEditorType')<CR>
nnoremap <leader>lr   <Cmd>call VSCodeNotify('editor.action.rename')<CR>
nnoremap <leader>ls   <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap <leader>lf   <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>

nnoremap <leader>lS   <Cmd>call VSCodeNotify('editor.action.triggerParameterHints')<CR>

" comment
xnoremap c<Space>c    <Cmd>call VSCodeNotify('editor.action.blockComment')<CR>
nnoremap c<Space>c    <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>

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
