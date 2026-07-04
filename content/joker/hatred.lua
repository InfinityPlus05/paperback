SMODS.Joker {
  key = "hatred",
  config = {
    extra = {
      xmult = 1.5
    }
  },
  attributes = {
    'xmult',
    'destroy_cards'
  },
  rarity = 2,
  pos = { x = 10, y = 12 },
  atlas = "jokers_atlas",
  cost = 5,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  paperback = {

  },
  paperback_credit = {
    coder = { 'dowfrin' }
  },

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.xmult
      }
    }
  end,

  calculate = function(self, card, context)
    if context.hand_drawn then
      -- Mark a random card that isn't already marked
      local targets = {}
      for _, _card in ipairs(G.hand.cards) do
        if not card.ability.paperback_hatred_mark then
          targets[#targets + 1] = _card
        end
      end

      local marked = pseudorandom_element(G.hand.cards, 'hatred_mark')

      if marked then
        marked.ability.paperback_hatred_mark = true
        juice_card_until(marked, function() return marked.ability.paperback_hatred_mark end, true)
      end
    end

    if context.individual and context.cardarea == G.play then
      if context.other_card.ability.paperback_hatred_mark then
        return {
          xmult = card.ability.extra.xmult
        }
      end
    end

    -- Checks for destroying the marked card
    if not context.blueprint then
      if context.discard then
        for i, v in ipairs(context.full_hand) do
          if v.ability.paperback_hatred_mark then
            SMODS.destroy_cards { v }
          end
        end
      end

      if context.destroy_card and context.cardarea == 'unscored' and context.destroy_card.ability.paperback_hatred_mark then
        return {
          remove = true
        }
      end

      if context.after then
        for i, v in ipairs(G.hand.cards) do
          if v.ability.paperback_hatred_mark then
            SMODS.destroy_cards { v }
          end
        end
        for i, v in ipairs(context.scoring_hand) do
          v.ability.paperback_hatred_mark = nil
        end
      end
    end
  end,

  remove_from_deck = function(self, card, from_debuff)
    for i, v in ipairs(G.playing_cards) do
      v.ability.paperback_hatred_mark = nil
    end
  end
}
