Name = "Task Manager"
Description = "A plugin to manage task files"

require("shared.utils")

local M = {}

local task_status = {
  todo = "- [ ] ",
  done = "- [x] ",
}

local task_pattern = "^(%s*)-%s%[(.)]%s(.*)$"

local toggle_task = function (input)
  local prefix, checkbox, content = input:match(task_pattern)
  local status = task_status.done

  print(input)

  if prefix and checkbox and content then
    if checkbox == "x" then
      status = task_status.todo
    end

    print("is task")
    return prefix .. status .. content
  end

  -- not a task, make it one
  status = task_status.todo

  local content_pattern = "^(%s+)(.*)$"
  prefix, content = input:match(content_pattern)

  if prefix and content then
    return prefix .. status .. content
  end

  return status .. input
end

local delete_task = function (input)
  local prefix, checkbox, content = input:match(task_pattern)

  if prefix and checkbox and content then
    return prefix .. content
  end

  return input
end

local modes = {
  toggle = 'toggle',
  remove = 'remove'
}

local mode_handler = {
  [modes.toggle] = toggle_task,
  [modes.remove] = delete_task,
}

local command = function (opts)
  local mode = opts.mode or modes.toggle

  return function ()
    local handler = mode_handler[mode]
    if handler == nil then
      return
    end

    local content = vim.api.nvim_get_current_line()
    local line = handler(content)

    vim.api.nvim_set_current_line(line)
  end
end

function M.setup()
  print("configuring tasks")

  vim.keymap.set("n", "<leader><leader>t", command({ mode = modes.toggle }))
  vim.keymap.set("n", "<leader><leader>T", command({ mode = modes.remove }))

  -- reload setup
  vim.keymap.set("n", "<leader><leader>r", function ()
    R('tasks').setup()
  end)
end

return M
