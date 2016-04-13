return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.16.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 12,
  height = 8,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "objects",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 1,
      margin = 0,
      image = "../graphics/objects.png",
      imagewidth = 119,
      imageheight = 16,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 7,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 12,
      height = 8,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 7, 0, 7, 0, 7, 0, 7, 0, 2,
        0, 0, 0, 7, 0, 7, 0, 7, 0, 7, 0, 2,
        0, 6, 3, 7, 0, 7, 0, 7, 0, 7, 0, 4,
        0, 3, 0, 7, 0, 7, 3, 7, 0, 7, 0, 2,
        0, 6, 0, 7, 0, 7, 0, 7, 0, 7, 0, 2,
        1, 0, 0, 7, 3, 7, 0, 7, 0, 7, 0, 2,
        0, 0, 3, 7, 0, 7, 0, 7, 3, 7, 0, 2,
        0, 0, 3, 7, 0, 7, 0, 7, 0, 7, 0, 2
      }
    }
  }
}
