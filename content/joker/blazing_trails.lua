SMODS.Joker {
  key = "blazing_trails",
  config = {
    extra = {
      required_cards = 5,
    }
  },
  attributes = {
    'discard',
    'destroy_cards',
    'red'
  },

  rarity = 2,
  pos = { x = 4, y = 12 },
  atlas = "jokers_atlas",
  cost = 6,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  unlocked = false,

  paperback_credit = {
    coder = { 'dowfrin' }
  },

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.required_cards,
      }
    }
  end,

  check_for_unlock = function(self, args)
    if G.GAME.paperback.destroyed_stars >= 1 then
      return true
    end
  end,

  calculate = function(self, card, context)
    if context.pre_discard and #context.full_hand == card.ability.extra.required_cards then
      local to_destroy = nil

      -- Collect the rightmost card already not destroyed by blazing trails
      for _, v in ipairs(context.full_hand) do
        if not v.paperback_blazing_destroyed then
          to_destroy = v
        end
      end

      if to_destroy then
        to_destroy.paperback_blazing_destroyed = true
        to_destroy:juice_up()
        SMODS.destroy_cards(to_destroy, { delay = 0.1 })

        return nil, true
      end
    end
  end
}
