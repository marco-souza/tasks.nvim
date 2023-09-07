Name = "Task Manager"
Description = "A plugin to manage task files"

local M = {}

function M.open()
end
-- -- tasks
-- T1: Buy milk
-- T2: Pick up dry cleaning
-- T3: Call mom

function M.load_tasks()
  local task_file = io.open("task.txt", "r")
  local tasks = {}
  for line in task_file do
    local task = line:sub(1, 1) -- Remove the newline character
    table.insert(tasks, task)
  end
  return tasks
end

function M.show_tasks()
  vim.api.nvim_command("echohlayer")
  for _, task in ipairs(M.load_tasks()) do
    print(task)
    vim.api.nvim_command("echo " .. task)
  end
  vim.api.nvim_command("echohlayer off")
end

function M.mark_task_as_completed(task)
  local task_file = io.open("task.txt", "w")
  if not task_file then
    return print("Can not open task file")
  end

  task_file:write(task .. " has been completed\n")
  task_file:close()
end

function M.add_task(name)
  local task_file = io.open("task.txt", "a")
  if not task_file then
    return print("Can not open task file")
  end

  task_file:write(name .. "\n")
  task_file:close()
end

function M.setup()
  require("shared.utils")

  print("configuring tasks")

  vim.keymap.set("n", "<leader>tt", M.show_tasks)
end

return M
