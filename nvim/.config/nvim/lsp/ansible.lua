return {
  cmd = { 'ansible-language-server', '--stdio' },
  settings = {
    ansible = {
      executionEnvironment = {
        enabled = false,
      },
    },
  },
  filetypes = { 'yaml', 'yml', 'ansible' },
  root_markers = { 'ansible.cfg', '.ansible-lint' },
}
