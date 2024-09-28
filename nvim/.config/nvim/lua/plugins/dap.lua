return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
          runType = "runOrTestFile",
          --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
          runType = "testTarget",
        },
      },
    }

    dap.adapters.delve = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
        -- add this if on windows, otherwise server won't open successfully
        -- detached = false
      }
    }

    -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
    dap.configurations.go = {
      {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}"
      },
      {
        type = "delve",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}"
      },
      -- works with go.mod packages and sub packages
      {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
      }
    }

    -- set custom icons
    --		for name, sign in pairs(debugging_signs) do
    --			sign = type(sign) == "table" and sign or { sign }
    --			vim.fn.sign_define(
    --				"Dap" .. name,
    --				{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
    --			)
    --		end

    -- setup dap
    dapui.setup()

    -- add event listeners
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
      vim.cmd("Hardtime disable")
      vim.cmd("NvimTreeClose")
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
      vim.cmd("Hardtime enable")
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
      vim.cmd("Hardtime enable")
    end
  end,
  dependencies = "rcarriga/nvim-dap-ui",
}
