vim.cmd[[execute "compiler python"]]


vim.api.nvim_buf_create_user_command(0, 'ModernizeTypeHints', function()
  local view = vim.fn.winsaveview()

  -- 1. Modernize Collections (unchanged)
  vim.cmd([=[silent! %s/\<\(List\|Dict\|Tuple\|Set\|FrozenSet\|Type\|Deque\)\>\ze\[/\L\1/ge]=])

  -- 2. Modernize Optional (UPGRADED)
  -- Old: Optional\[\([^\[\]]*\)\]
  -- New: Optional\[\(\%([^\[\]]\|\[[^\[\]]*\]\)*\)\]
  --
  -- Explanation:
  -- \%( ... \)* -> Repeat a group of...
  -- [^\[\]]          -> Any character that ISN'T a bracket
  -- \|               -> OR
  -- \[[^\[\]]*\]     -> A [...] block that contains no brackets (handles the nested [Any])
  vim.cmd([=[silent! %s/Optional\[\(\%([^\[\]]\|\[[^\[\]]*\]\)*\)\]/\1 | None/ge]=])

  -- 3. Modernize Union (unchanged)
  -- Note: Nested Unions (Union[List[int], str]) are much harder to regex safely 
  -- because simply swapping commas would break the inner List[int, int].
  vim.cmd([=[silent! %s/Union\[\([^\[\]]*\)\]/\=substitute(submatch(1), ',\s*', ' | ', 'g')/ge]=])

  vim.fn.winrestview(view)
  print("Type hints modernized!")
end, {})
