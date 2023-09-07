Name = "To Do keys"
Description = "A plugin to manage todo files"


local M = {}

function M.open()
end
-- -- Todos
-- T1: Buy milk
-- T2: Pick up dry cleaning
-- T3: Call mom

function M.load_todos()
  local todo_file = io.open("todo.txt", "r")
  local todos = {}
  for line in todo_file do
    local todo = line:sub(1, 1) -- Remove the newline character
    table.insert(todos, todo)
  end
  return todos
end

function M.show_todos()
  vim.api.nvim_command("echohlayer")
  for _, todo in ipairs(M.load_todos()) do
    print(todo)
    vim.api.nvim_command("echo " .. todo)
  end
  vim.api.nvim_command("echohlayer off")
end

function M.mark_todo_as_completed(todo)
  local todo_file = io.open("todo.txt", "w")
  if not todo_file then
    return print("Can not open todo file")
  end

  todo_file:write(todo .. " has been completed\n")
  todo_file:close()
end

function M.add_todo(name)
  local todo_file = io.open("todo.txt", "a")
  if not todo_file then
    return print("Can not open todo file")
  end

  todo_file:write(name .. "\n")
  todo_file:close()
end

function M.setup()
  vim.keymap.set("n", "<leader>tt", M.show_todos)
end

return M
