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
      "if played hand",
      "contains a {C:attention}Straight{}",
      "lose hand",
      "balls"
    }
  },
  config = { extra = { chips = 0, chip_gain = 15 } },
  rarity = 1,
  atlas = 'rtxtmod',
  pos = { x = 1, y = 0 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chip_mod = card.ability.extra.chips,
        message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
      }
    end

    -- context.before checks if context.before == true, and context.before is true when it's before the current hand is scored.
    -- (context.poker_hands['Straight']) checks if the current hand is a 'Straight'.
    -- The 'next()' part makes sure it goes over every option in the table, which the table is context.poker_hands.
    -- context.poker_hands contains every valid hand type in a played hand.
    -- not context.blueprint ensures that Blueprint or Brainstorm don't copy this upgrading part of the joker, but that it'll still copy the added chips.
    if context.before and next(context.poker_hands['Straight']) and not context.blueprint then
      -- Updated variable is equal to current variable, plus the amount of chips in chip gain.
      -- 15 = 0+15, 30 = 15+15, 75 = 60+15.
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
      return {
        message = 'Fail!',
        colour = G.C.CHIPS,
        -- The return value, "card", is set to the variable "card", which is the joker.
        -- Basically, this tells the return value what it's affecting, which if it's the joker itself, it's usually card.
        -- It can be things like card = context.other_card in some cases, so specifying card (return value) = card (variable from function) is required.
        card = card
      }
    end
  end
}

SMODS.Joker {
  key = 'negajk',
  loc_txt = {
    name = 'Nigg-Nagg',
    text = {
      "When Blind is selected,",
      "create a {C:dark_edition}Negative{} Common Joker"
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
      -- Ask someone who knows eval_status_text better to elaborate on this.
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
      "Add a {X:mult,C:white}X100{} Mult hand is a 2 pair and has a 2 hearts 2 gold club queen glass spade queen steel diamond"
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
