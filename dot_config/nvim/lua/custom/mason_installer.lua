-- Automatically install listed packages from Mason
local M = {}
local registry = require("mason-registry")
local Optional = require("mason-core.optional")
local Package = require("mason-core.package")

local function resolve_package(pkg_name)
  return Optional.of_nilable(pkg_name):map(function (package_name)
    local ok, pkg = pcall(registry.get_package, package_name)
    if ok then
      return pkg
    end
  end)
end

function M:install(package)
  local pkg_name, version = Package.Parse(package)
  local resolved_pkg = resolve_package(pkg_name)
  resolved_pkg:if_present(
    function (pkg)
      if not pkg:is_installed() then
        vim.notify(("[mason-auto-installer] Installing %s"):format(pkg.name))
        pkg:install({
          version = version,
        }):once(
          "closed",
          vim.schedule_wrap(function ()
            if pkg:is_installed() then
              vim.notify(("[mason-auto-installer] %s installed"):format(pkg.name))
            end
          end)
        )
      end
    end
  )
  return registry.get_package(package):get_install_path()
end

return M
