PB_UTIL.Sleeve {
  key       = 'commander',
  deck_buff = 'b_paperback_commander',
  atlas     = 'card_sleeves_atlas',
  pos       = { x = 9, y = 0 },
  unlocked = false,
  unlock_condition = { deck = "b_paperback_commander", stake = "stake_black" },

  calculate = function(self, sleeve, context)
    if not self:is_buffed() then
      return SMODS.Back.obj_table[self.deck_buff].calculate(self, sleeve, context)
    end
    if context.retrigger_joker_check and PB_UTIL.is_card(context.other_card) then
      if next(G.jokers.cards) and context.other_card == G.jokers.cards[1] then
        return { repetitions = 1 }
      end
    end
  end

}
local move_ref = Moveable.drag
function Moveable.drag(self, offset)
  if self.is and type(self.is) == "function" and self:is(Card) and self.ability.set == "Joker" then
    if G and G.GAME and G.GAME.blind and G.GAME.blind.in_blind and G.GAME.selected_sleeve == "sleeve_paperback_commander" then
      return
    end
  end
  return move_ref(self, offset)
end
