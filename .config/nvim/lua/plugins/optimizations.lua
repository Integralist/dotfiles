local function init(use)
  use { "lewis6991/impatient.nvim",
    config = function()
      require("impatient")
    end
  }
end

return { init = init }
