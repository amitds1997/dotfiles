local H = {}

H.is_windows = package.config:sub(1, 1) == "\\" and true or false
H.path_sep = H.is_windows and "\\" or "/"

-- Join paths correctly using the correct path separator
function H.path_join(...)
  return table.concat({ ... }, H.path_sep)
end

-- Generic logging function
local function log(level, text)
  print(level:upper() .. " " .. text)
end

-- Logging functions
function H.log_info(msg)
  log("INFO", msg)
end

function H.log_warn(msg)
  log("WARN", msg)
end

function H.log_error(msg)
  log("ERROR", msg)
end

function H.log_success(msg)
  log("INFO", msg)
end

return H
