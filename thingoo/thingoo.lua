--- STEAMODDED HEADER
--- MOD_NAME: thingoo
--- MOD_ID: thingoo
--- MOD_AUTHOR: [RTXT25]
--- MOD_DESCRIPTION: stupidthing.
----------------------------------------------
------------MOD CODE -------------------------
SMODS.Atlas {
  key = "rtxtmod",
  path = "ass.png",
  px = 71,
  py = 95
}

SMODS.Joker {
  key = 'funnyjk',
  loc_txt = {
    name = 'Funny Number Joker',
    text = {
      "{C:mult}+#1#{} Mult"
    }
  },
  config = { extra = { mult = 69 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  rarity = 3,
  atlas = 'rtxtmod',
  pos = { x = 0, y = 0 },
  cost = 2,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
  end
}

SMODS.Joker {
  key = 'gayjoker',
  loc_txt = {
    name = 'Gay Joker',
    text = {
      "gain {C:mult}+#1#{} Mult",
      "every pair of kings or jacks",
    }
  },
  config = { extra = { mult = 0 , mult_gain = 4 } },
  rarity = 1,
  atlas = 'rtxtmod',
  pos = { x = 1, y = 0 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
    local kings = 0
    local jacks = 0
    if context.before then
      if context.scoring_hand[i]:get_id() == 13 then kings = kings + 1 end
      if context.scoring_hand[i]:get_id() == 11 then jacks = jacks + 1 end
    end
    if context.before and kings > 1 then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
    end
    --[[if context.individual and context.cardarea == G.play then  
      if context.before and next(context.poker_hands['Pair']) and not context.blueprint then
        if context.other_card:get_id() == 11 or context.other_card:get_id() == 13 and context.other_card:get_id() == 13 then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
       card = context.other_card 
        end
      end
    end]]
  end
}

SMODS.Joker {
  key = 'negajk',
  loc_txt = {
    name = 'Nigg-Nagg',
    text = {
      "When Blind is selected,",
      "create a {C:dark_edition}Negative{}",
      "Common Joker"
    }
  },
  config = { extra = {} },
  rarity = 2,
  atlas = 'rtxtmod',
  pos = { x = 2, y = 0 },
  cost = 10,
  calculate = function(self, card, context)
    if context.blind then
      G.E_MANAGER:add_event(Event({
        func = function()
          local card = create_card('Joker', G.jokers, nil, 0, nil, nil, nil, 'neg')
          card:set_edition('e_negative', true)
          card:set_rental(true)
          card:set_perishable(true)
          card:add_to_deck()
          G.jokers:emplace(card)
          card:start_materialize()
          G.GAME.joker_buffer = 0
          return true
        end
      }))
      card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
        { message = localize('k_duplicated_ex') })
    end
  end
}

SMODS.Joker {
  key = 'spjk',
  loc_txt = {
    name = 'Extremely Specific Joker',
    text = {
      "Add a {X:mult,C:white}X100{} Mult",
      "when hand contains",
      "a 2 hearts 2 gold club queen glass spade queen steel diamond",
    }
  },
  config = { extra = { Xmult = 100 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,
  rarity = 3,
  atlas = 'rtxtmod',
  pos = { x = 0, y = 0 },
  cost = 2,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
  end
  }
  SMODS.Joker {
    key = 'dmr',
    loc_txt = {
      name = 'Diamond Minning Rig',
      text = {
        "{X:mult,C:white} X#1# {} Mult",
        "{C:green}#2# in #3#{} chance this",
        "runs out of diamonds"
      }
    },
    config = { extra = { Xmult = 10, odds = 5 } },
    rarity = 1,
    atlas = 'rtxtmod',
    pos = { x = 0, y = 1 },
    cost = 4,
    eternal_compat = false,
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.Xmult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
      if context.joker_main then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
        }
      end
      if context.end_of_round and not context.game_over and not context.repetition and not context.blueprint then
        if pseudorandom('dmr') < G.GAME.probabilities.normal / card.ability.extra.odds then
          G.E_MANAGER:add_event(Event({
            func = function()
              play_sound('tarot1')
              card.T.r = -0.2
              card:juice_up(0.3, 0.4)
              card.states.drag.is = true
              card.children.center.pinch.x = true
              G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                  G.jokers:remove_card(card)
                  card:remove()
                  card = nil
                  return true;
                end
              }))
              return true
            end
          }))
          G.E_MANAGER:add_event(Event({
            func = function()
              --local card = create_card('Joker', thingoo.jokers.rock, rock, 0, rock, rock, rock, 'rock')
              local makerock = SMODS.create_card{key = "j_rtxtmod_rock"}
              G.jokers:emplace(makerock)
              makerock:add_to_deck()
              return true
            end
          }))
          return {
            message = 'Diamonds!'
          }
        else
          return {
            message = 'Empty!'
          }
        end
      end
    end
  }
  SMODS.Joker {
    key = 'rock',
    loc_txt = {
      name = 'Empty Rock',
      text = {
        "You ran out of Diamonds",
      }
    },
    config = { extra = {} },
    rarity = 1,
    atlas = 'rtxtmod',
    pos = { x = 4, y = 0 },
    cost = 0,
  }
SMODS.Joker {
  key = 'moneyjk',
  loc_txt = {
    name = 'devcash',
    text = {
      "gives me money",
    }
  },
  config = { extra = {} },
  rarity = 1,
  atlas = 'rtxtmod',
  pos = { x = 4, y = 1 },
  cost = 9999999999999999999999999999999999999999,
}
SMODS.Joker {
  key = 'opdev',
  loc_txt = {
    name = 'devtestjoker',
    text = {
      "{C:mult}+#1#{} Mult"
    }
  },
  config = { extra = { mult = 9999999999999999999999999999999999999999999999999999999999999 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  rarity = 3,
  atlas = 'rtxtmod',
  pos = { x = 3, y = 1 },
  cost = 2,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
  end
}

----------------------------------------------
------------MOD CODE END----------------------
