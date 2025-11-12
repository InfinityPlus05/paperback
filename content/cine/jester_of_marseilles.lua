SMODS.Consumable {
  key = 'jester_of_marseilles',
  set = 'Cine',
  atlas = "reverie_atlas",
  pos = {
    x = 1,
    y = 0
  },
  name = "Jester of Marseilles",
  config = { extra = { planets = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.planets } }
  end,
  use = function(self, card, area, copier)
    for i = 1, math.min(card.ability.extra.planets, G.consumeables.config.card_limit - #G.consumeables.cards) do
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('timpani')
            SMODS.add_card({ set = 'Planet' })
            card:juice_up(0.3, 0.5)
          end
          return true
        end
      }))
    end
    delay(0.6)
  end,
  can_use = function(self, card)
    return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit or
        (card.area == G.consumeables)
  end
}
--[[
key = "jester_of_marseilles",
    atlas = "reverie_atlas",
    order = 51,
    name = "Jester of Marseilles",
    pos = {
      x = 1,
      y = 0
    },
    config = {
      extra = {
      }
    },
    cost = 4,
    ]]
