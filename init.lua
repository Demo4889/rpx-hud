---
--- RPX HUD
--- The RPX framework and its resources are still under heavy development.
--- Bugs and missing features are expected.
---

do
    require 'shared.config'

    if IsDuplicityVersion() then
        -- Server Modules
        require 'server.main'
    else
        -- Client Modules
        require 'client.main'
        require 'client.modules.money'
        require 'client.modules.stress'
    end
end