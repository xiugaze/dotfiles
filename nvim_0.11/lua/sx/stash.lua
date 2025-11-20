local M = {}

local function get_repo_url()
    local handle = io.popen("git config --get remote.origin.url")
    local remote_url = handle:read("*a")
    handle:close()
    return remote_url
end



local function get_url()
  local remote_url = "https://stash/projects/"
  local url = get_repo_url()
  local repoPath = url:gsub("^.-/([^/]+)/([^/]+)%.git$", "%1/%2")
end

