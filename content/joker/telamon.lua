SMODS.Joker {
  key = 'telamon',
  config = {
    extra = {
      hand = "Pair",
      active = false
    }
  },
  rarity = 2,
  pos = { x = 18, y = 10 },
  atlas = 'jokers_atlas',
  cost = 6,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  paperback = {
    requires_minor_arcana = true
  },

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.hand, 'poker_hands'),
      }
    }
  end,

  calculate = function(self, card, context)
    if context.after then
      if next(context.poker_hands[card.ability.extra.hand]) then
        card.ability.extra.active = true
      else
        card.ability.extra.active = false
      end
    end


    if context.end_of_round and card.ability.extra.active and context.main_eval then
      local index = pseudorandom("telamon_minor_arcana", 29, 42)
      PB_UTIL.try_spawn_card { key = "c_paperback_" .. PB_UTIL.ENABLED_MINOR_ARCANA[index], func = function()
        SMODS.calculate_effect {
          message = localize('paperback_plus_minor_arcana'),
          colour = G.C.PAPERBACK_MINOR_ARCANA,
          card = context.blueprint_card or card
        }
        return nil, true
      end }
    end
  end
}
