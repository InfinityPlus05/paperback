SMODS.Sticker {
  key = 'temporary',
  atlas = 'stickers_atlas',
  pos = { x = 1, y = 0 },
  badge_colour = G.C.PAPERBACK_TEMPORARY,
  should_apply = function(self, card, center, area, bypass_roll)
    return bypass_roll
  end,
  discovered = true,
  rate = 0,

  draw = function(self, card)
    -- Don't draw the shine over the sticker
    G.shared_stickers[self.key].role.draw_major = card
    G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
  end,
}

-- Hook end_round to destroy Jokers and Consumables with this sticker
local end_round_ref = end_round
function end_round()
  local to_destroy = {}

  -- Destroy jokers
  for _, v in ipairs(G.jokers and G.jokers.cards or {}) do
    if v.ability.paperback_temporary then
      v.paperback_temporary_removed = true
      to_destroy[#to_destroy + 1] = v
    end
  end

  -- Destroy consumables
  for _, v in ipairs(G.consumeables and G.consumeables.cards or {}) do
    if v.ability.paperback_temporary then
      v.paperback_temporary_removed = true
      to_destroy[#to_destroy + 1] = v
    end
  end

  -- Destroy playing cards
  for _, v in ipairs(G.playing_cards or {}) do
    if v.ability.paperback_temporary then
      v.paperback_temporary_removed = true
      to_destroy[#to_destroy + 1] = v
    end
  end

  if #to_destroy > 0 then
    SMODS.destroy_cards(to_destroy)
  end

  return end_round_ref()
end

-- Removes cards destroyed due to temporary sticker from calculation
local calculate_context_ref = SMODS.calculate_context
function SMODS.calculate_context(context, return_table, no_resolve)
  -- Remove non playing cards
  if context.joker_type_destroyed and context.card.paperback_temporary_removed then
    return not return_table and {}
  end

  -- Remove playing cards
  if context.remove_playing_cards then
    local non_temporary_removed = {}
    for _, card in ipairs(context.removed) do
      if not card.paperback_temporary_removed then
        table.insert(non_temporary_removed, card)
      end
    end

    -- Cancel the context call if there are no removed cards
    if #non_temporary_removed <= 0 then
      return not return_table and {}
    end

    context.removed = non_temporary_removed
  end

  return calculate_context_ref(context, return_table, no_resolve)
end
