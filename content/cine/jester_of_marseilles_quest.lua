SMODS.Consumable {
  key = "jester_of_marseilles_quest",
  set = 'Cine',
  atlas = "reverie_atlas",
  pos = { x = 0, y = 0 },
  reward = "c_paperback_jester_of_marseilles",
  config = {
    extra = {
      goal = 3
    }
  },
  loc_vars = function(self, info_queue, card)
    local vars = nil
    local reward_card = self.reward

    info_queue[#info_queue + 1] = G.P_CENTERS.c_paperback_jester_of_marseilles

    vars = { card.ability.extra.goal, card.ability.progress }

    return { vars = vars }
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        if G.consumeables.config.card_limit > #G.consumeables.cards then
          play_sound('timpani')
          SMODS.add_card({ key = G.GAME.last_tarot_planet })
          card:juice_up(0.3, 0.5)
        end
        return true
      end
    }))
    delay(0.6)
  end,
  can_use = function(self, card)
    return (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables) and
        G.GAME.last_tarot_planet and
        G.GAME.last_tarot_planet ~= 'c_fool'
  end
}

--[[
key = "jester_of_marseilles_quest",
  atlas = "reverie_atlas",
  order = 50,
  name = "Jester of Marseilles Exchange Coupon",
  reward = "c_paperback_jester_of_marseilles",
  config = {
    extra = {
      goal = 3
    }
  },
  cost = 4,
  pos = {
    x = 0,
    y = 0
  }

Hook into Reverie's progression system
Card.calculate_joker_reverie_ref = Card.calculate_joker
function Card:calculate_joker(context)
  if self.debuff then
    return nil
  end

  if self.ability.set == "Cine" and self.ability.progress then
    if (self.config.center.reward == "c_paperback_jester_of_marseilles" and context.using_consumeable
      and context.consumeable.ability.set == "paperback_minor_arcana") then
      return Reverie.progress_cine_quest(self)
    end

    local result = self:calculate_joker_reverie_ref(context)

    return result
  end
end
]]
