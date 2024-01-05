local vert_tile = {}

vert_tile.name = "vertical"
function vert_tile.arrange(p)
    local area = p.workarea
    local i = 0
    for i, c in ipairs(p.clients) do
            local g = {
                    x = area.x + (i-1) * (area.width / #p.clients),
                    y = area.y,
                    width  = area.width / #p.clients,
                    height = area.height
            }
            p.geometries[c] = g
    end
end

return vert_tile
