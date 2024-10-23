--- STEAMODDED HEADER
--- MOD_NAME: thingoo
--- MOD_ID: thingoo
--- MOD_AUTHOR: [RTXT25]
--- MOD_DESCRIPTION: stupidthing.
----------------------------------------------
------------MOD CODE -------------------------
--Creates an atlas for cards to use
SMODS.Atlas {
  -- Key for code to find it with
  key = "rtxtmod",
  -- The name of the file, for the code to pull the atlas from
  path = "ass.png",
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}

--69
SMODS.Joker {
  -- How the code refers to the joker.
  key = 'funnyjk',
  -- loc_text is the actual name and description that show in-game for the card.
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
  -- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
  calculate = function(self, card, context)
    -- Tests if context.joker_main == true.
    -- joker_main is a SMODS specific thing, and is where the effects of jokers that just give +stuff in the joker area area triggered, like Joker giving +Mult, Cavendish giving XMult, and Bull giving +Chips.
    if context.joker_main then
      -- Tells the joker what to do. In this case, it pulls the value of mult from the config, and tells the joker to use that variable as the "mult_mod".
      return {
        mult_mod = card.ability.extra.mult,
        -- This is a localize function. Localize looks through the localization files, and translates it. It ensures your mod is able to be translated. I've left it out in most cases for clarity reasons, but this one is required, because it has a variable.
        -- This specifically looks in the localization table for the 'variable' category, specifically under 'v_dictionary' in 'localization/en-us.lua', and searches that table for 'a_mult', which is short for add mult.
        -- In the localization file, a_mult = "+#1#". Like with loc_vars, the vars in this message variable replace the #1#.
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
        -- Without this, the mult will stil be added, but it'll just show as a blank red square that doesn't have any text.
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

----------------------------------------------
------------MOD CODE END----------------------
