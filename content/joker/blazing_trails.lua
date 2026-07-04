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

  calculate = function(self, card, context)
    if context.discard and (#context.full_hand == card.ability.extra.required_cards and context.full_hand[#context.full_hand]) then
      card:juice_up()
      SMODS.destroy_cards({ context.full_hand[#context.full_hand] })
    end
  end
}
