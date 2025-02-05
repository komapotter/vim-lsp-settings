function! s:get_current_ts_path() abort
  let ts_path = '/node_modules/typescript/lib/tsserverlibrary.js'

  let project_dir = lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json')
  let tsserverlibrary_path = project_dir . ts_path

  let server_dir = lsp_settings#servers_dir() . '/volar'
  let fallback_path = server_dir . ts_path

  let path = filereadable(tsserverlibrary_path) ? tsserverlibrary_path : fallback_path
  return {
  \   'serverPath': path
  \ }
endfunction

function! Vim_lsp_settings_volar_initialization_options() abort
  let initialization_options = deepcopy(g:vim_lsp_settings_volar_options)
  let initialization_options['typescript'] = s:get_current_ts_path()
  return initialization_options
endfunction

let g:vim_lsp_settings_volar_options = {
\   'typescript': {
\     'serverPath': "",
\   },
\   'languageFeatures': {
\     'references': { 'enabledInTsScript': v:true },
\     'definition': v:true,
\     'typeDefinition': v:true,
\     'callHierarchy': v:true,
\     'hover': v:true,
\     'rename': v:true,
\     'renameFileRefactoring': v:true,
\     'signatureHelp': v:true,
\     'completion': {
\       'defaultTagNameCase': 'both',
\       'defaultAttrNameCase': 'kebabCase',
\       'getDocumentNameCasesRequest': v:false,
\       'getDocumentSelectionRequest': v:false,
\     },
\     'documentHighlight': v:true,
\     'documentLink': v:true,
\     'codeLens': {
\       'showReferencesNotification': v:false,
\     },
\     'semanticTokens': v:true,
\     'codeAction': v:true,
\     'diagnostics': v:true,
\     'schemaRequestService': v:true,
\   },
\   'documentFeatures': {
\     'selectionRange': v:true,
\     'foldingRange': v:true,
\     'linkedEditingRange': v:true,
\     'documentSymbol': v:true,
\     'documentColor': v:true,
\     'documentFormatting': {
\       'defaultPrintWidth': 100,
\       'getDocumentPrintWidthRequest': v:false,
\     },
\   }
\ }

let g:vim_lsp_settings_volar_config = {
\   'volar-api': {
\     'trace': { 'server': "off" },
\   },
\   'volar-document': {
\     'trace': { 'server': "off" },
\   },
\   'volar-html': {
\     'trace': { 'server': "off" },
\   },
\   'volar': {
\     'codeLens': {
\       'references': v:false,
\       'pugTools': v:false,
\       'scriptSetupTools': v:false,
\     },
\     'formatting': {
\       'printWidth': 100,
\     },
\     'icon': {
\       'splitEditors': v:true,
\       'preview': v:false,
\       'finder': v:false,
\     },
\     'lowPowerMode': v:false,
\     'autoCompleteRefs': v:true,
\     'tsPluginStatus': v:false,
\     'checkVueTscVersion': v:false,
\     'preferredTagNameCase': "auto",
\     'preferredAttrNameCase': "auto",
\     'preview': {
\       'port': 3333,
\       'backgroundColor': "fff",
\       'transparentGrid': v:false,
\     }
\   }
\ }

augroup vim_lsp_settings_volar
  au!
  LspRegisterServer {
  \ 'name': 'volar',
  \ 'cmd': {server_info->lsp_settings#get('volar', 'cmd', [lsp_settings#exec_path('volar'), '--stdio'])},
  \ 'root_uri':{server_info->lsp_settings#get('volar', 'root_uri', lsp_settings#root_uri('volar'))},
  \ 'initialization_options': lsp_settings#get('volar', 'initialization_options', Vim_lsp_settings_volar_initialization_options()),
  \ 'allowlist': lsp_settings#get('volar', 'allowlist', ['vue']),
  \ 'blocklist': lsp_settings#get('volar', 'blocklist', []),
  \ 'config': lsp_settings#get('volar', 'config', lsp_settings#server_config('volar')),
  \ 'workspace_config': lsp_settings#get('volar', 'workspace_config', g:vim_lsp_settings_volar_config),
  \ }
augroup END
