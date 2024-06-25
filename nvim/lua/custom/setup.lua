local function async_install_python_support()
  vim.notify('Installing Neovim Python support packages...', vim.log.levels.INFO)

  -- Use pip to install the required Python packages. If they are already installed, return 1.
  -- The command is run asynchronously, so the user can continue using Neovim while the packages are installed.
  local packages = { 'pynvim', 'python-lsp-server', 'matplotlib', 'ipykernel' }
  local packages_str = table.concat(packages, ' ')
  local command = '(pip show -q ' .. packages_str .. ' 2>&1 >/dev/null) | grep -q . || exit 0; pip install ' .. packages_str .. ' && exit 1; exit 2'

  vim.fn.jobstart(command, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
      elseif exit_code == 1 then
        vim.notify('Neovim Python support packages installed successfully!', vim.log.levels.INFO)
      elseif exit_code == 2 then
        vim.notify('Failed to install Neovim Python support packages.', vim.log.levels.ERROR)
      else
        vim.notify('Got unexpected exit code: ' .. exit_code, vim.log.levels.ERROR)
      end
    end,
  })
end

-- Run the installation function when Neovim starts
vim.api.nvim_create_autocmd('VimEnter', {
  callback = async_install_python_support,
})
