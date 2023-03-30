--[[Global variables--]]

convertingPlayerColor = ''

lastCollectTime = 0

quickConvertPlayerChips = false

quickConvertPlayerTime = nil

quickConvertPlayersPlayer = nil

quickConvertPlayersObject = nil

createSidepotPl = nil

createSidepotOb = nil

convertfailcountlimit = 50 -- when bets are converted to pot, the number of failed attempts allowed before it falls back to move bets (it makes one attempt every two frames)

sidepotfailcountlimit = 50 --

sidepotfailcount = 0

splitPotPlayers = 0 -- Numbers of Players where the split pot should be created

splitPotZone = {} -- Contains the Zone for splitpotaction

splitPotObject = {}



--[[ Customizable variables --]]

options = {



  ["dealdelay1"] = 0.1, -- delay (in seconds) used when dealing players their hands

  ["dealdelay2"] = 0.4, -- delay (in seconds) used when dealing community cards

  ["blindsskipafk"] = false, -- If false, afk players still pay blindss when it's their time. Change to true if you want blinds to skip afk players.

  ["actiontoggle"] = true, -- toggle whether the game displays actiontext. set this to false if you want to have it off by default

  ["playerclickaction"] = true, -- toggle whether action button stays in place (false) or moves from player to player (true)

  ["gamemode"] = 'texas', -- Game mode (currently supports Texas Hold'em ('texas'), Pineapple ('pineapple'), and Omaha Hold'em ('omaha'))

  ["collectmethod"] = 'move', -- method used by collect bets. options: 'move': moves bets; 'convert': converts bets up, 'hybrid': starts with move, changes to convert when pot>hybridthreshold

  ["hybridthreshold"] = 10000, -- used with hybrid collection, the point above which collection switches from move to convert

  ["convertstackheight"] = 1, -- contains the height of the stacks for the convert method

  ["enforcedoubleraise"] = true, -- if true, does not let a player pass action if their raise is less than double the current bet and they are not all in.

  ["enforcepotlimit"] = false, -- if true, does not let a player pass action if they bet too much for pot limit. the bet limit is calculated as: pot + currentbet + (currentbet - action player's bet)

  ["enforcedfoldinturn"] = false, -- if true, players may not use the fold hand buttons to fold out of turn

  ["clocktime"] = 30,

  ["autoclock"] = false,

  ["autofold"] = false,

  ["autoclocktime"] = 10,

  ["clockpausebutton"] = false,

  ["currencies"] = 'default_10', -- contains the index of different currencies

  ["stacklayout"] = 'default_10', -- contains the index of different currencies template

  ["chatoptions"] =

  {

    ["actionmessage"] = true, -- print "Action on player" message in chat

    ["actionbroadcast"] = true, -- broadcast "Action on you!" to the current player

    ["currentbetmessage"] = true, -- broadcast when the current bet changes

    ["better"] = true, -- include the player who made or raised in the above message

    ["potmessage"] = 2, -- 0 = never, 1 = on collect bets only, 2 = any time it changes as well as on collection

    ["allinbroadcast"] = true, -- broadcast when a player is all in

    ["stage"] = true -- flop, turn, river broadcasts

  },



  ["displayplayerbet"] = true, --

  ["displayplayermoney"] = true,

  ["playerbuttons"] =

  {

    ["sortchips"] = true,

    ["convert"] = true,

    ["allin"] = true,

    ["afk"] = true,

    ["loadsavebag"] = false,

  },

  ["changemachine"] = true,

}

--[[starteramount = 10000

autosaveandload = true

chips = {} --]]

--[[ other variables and tables --]]

onecard = false -- used when dealing one card from options menu (for determining starting dealer, etc)

handsshown = {} -- table of hands that have been shown and evaluated by the script this round

handinprogress = false -- used to prevent change of gamemode during a hand

convertfailcount = 0

holedealt = false -- whether or not players have been dealt their hole cards

holecards = {['White'] = {}, ['Red'] = {}, ['Orange'] = {}, ['Yellow'] = {}, ['Green'] = {}, ['Teal'] = {}, ['Blue'] = {}, ['Purple'] = {}} -- table of players' hole cards, used for hand evaluations

revealedcards = {['White'] = {}, ['Red'] = {}, ['Orange'] = {}, ['Yellow'] = {}, ['Green'] = {}, ['Teal'] = {}, ['Blue'] = {}, ['Purple'] = {}} -- table of players' hole cards which have been revealed

dealing = false -- set to true while cards are being dealt to prevent double-clicking

players = {} -- table of seated players used for dealing cards and actions

actionon = nil -- Player whose turn it is to act

playerbets = {} -- Table of players' bets

currentbet = 0 -- highest bet from the playerbets table

mainpotchips = {} -- table containing information regarding stacks of chips in the main pot(initialized in initializePot() function)

printstring = '' -- string referenced by printMessages function to know which messages to print.

pot = 0 -- total amount in pot (including current players' bets)

cardtint = 1 -- used anti-grouping measure

sidepotcalculatet = false -- contains information if sidepot was calculated, stops all actions except dealing

themeindex = 1

subthemeindex = 1

chiptints = {['White'] = {1, 1, 0.99}, ['Red'] = {1, 0.99, 0.99}, ['Orange'] = {0.99, 1, 1}, ['Yellow'] = {0.99, 1, 0.99}, ['Green'] = {0.99, 0.99, 1}, ['Teal'] = {0.99, 0.99, 0.99}, ['Blue'] = {1, 1, 0.98}, ['Purple'] = {1, 0.98, 1}, }

betzonechiptints = {['White'] = {1, 0.98, 0.98}, ['Red'] = {0.98, 0.98, 0.99}, ['Orange'] = {0.98, 0.98, 0.98}, ['Yellow'] = {1, 1, 0.97}, ['Green'] = {1, 0.97, 1}, ['Teal'] = {1, 0.97, 0.99}, ['Blue'] = {1, 0.97, 0.98}, ['Purple'] = {1, 0.97, 0.97}}







--[[ Object references and GUIDs --]]

afkClock = {}

potsplitter = {}

actionbutton = {}

actionbuttonGUID = '08f4c2'

backtablezones = {}

backtablezoneGUIDs = {'1904be', 'ee0d04', 'b131a2', 'bb2a9a', 'b9938f', '144824', 'b0eda0', 'a17f45'}

betzones = {} -- scripting zones for the betting areas for each player. Order must correspond to colors table

betzoneGUIDs = {'420cfb', '7d419f', '332aa4', '0377d5', '8a2729', 'db2d03', 'b93bb7', 'c43aea'}

boardobject = {} -- 3d model used for the board

boardobjectGUID = '48721b'

boardzone = {} -- scripting zone on the board where community cards are dealt

boardzoneGUID = '5a1d5c'

collectbutton = {} -- button to collect bets

collectbuttonGUID = 'e801e4'

clock = null

dealbutton = {} -- button to deal cards

dealbuttonGUID = '1745d7'

deck = {} -- deck

deckGUID = '1b1565' -- the deck's GUID which is saved on the table

muck = {} -- the muck object that is used to determine where burn cards are dealt

muckGUID = 'be42ca'

newdeckbutton = {} -- button to spawn a new deck

newdeckbuttonGUID = 'ea1c95'

potobject = {}

potobjectGUID = '6a79c6'

resetbutton = {} -- button to reset the game

resetbuttonGUID = 'c3b0f3'

sidepotbutton = {}

sidepotbuttonGUID = 'f1421a'

tablezones = {}

tablezoneGUIDs = {'fe7624', 'f33c02', 'a96804', '08e7a3', 'e2ff95', '92c6c4', 'd03a42', 'd1cf88'}



infiniteMoneyBag = {}







colors = {"White", "Red", "Orange", "Yellow", "Green", "Teal", "Blue", "Purple"} --list of all colors, in order

fontcolors = {}



for i, v in ipairs (colors) do

  fontcolors[v] = {}

end



fontcolors.White.r = 1

fontcolors.White.g = 1

fontcolors.White.b = 1

fontcolors.White.bbcode = '[ffffff]'



fontcolors.Red.r = 0.856

fontcolors.Red.g = 0.1

fontcolors.Red.b = 0.094

fontcolors.Red.bbcode = '[da1918]'



fontcolors.Orange.r = 0.956

fontcolors.Orange.g = 0.392

fontcolors.Orange.b = 0.113

fontcolors.Orange.bbcode = '[f4641d]'



fontcolors.Yellow.r = 0.905

fontcolors.Yellow.g = 0.898

fontcolors.Yellow.b = 0.172

fontcolors.Yellow.bbcode = '[e7e52c]'



fontcolors.Green.r = 0.192

fontcolors.Green.g = 0.701

fontcolors.Green.b = 0.168

fontcolors.Green.bbcode = '[31b32b]'



fontcolors.Teal.r = 0.129

fontcolors.Teal.g = 0.694

fontcolors.Teal.b = 0.607

fontcolors.Teal.bbcode = '[21b19b]'



fontcolors.Blue.r = 0.118

fontcolors.Blue.g = 0.53

fontcolors.Blue.b = 1

fontcolors.Blue.bbcode = '[1f87ff]'



fontcolors.Purple.r = 0.627

fontcolors.Purple.g = 0.125

fontcolors.Purple.b = 0.941

fontcolors.Purple.bbcode = '[a020f0]'



potzones = {}

mainpotzoneGUID = 'a20d35'

sidepotzoneGUIDs = {'c9aaae'}

pottext = {}

pottextGUID = 'a5130f'

mainpottext = {}

mainpottextGUID = '476499'

bettext = {} --  textes for current player bets

bettextGUIDs = {'8133a5', '433f14', 'b57079', '86e377', '9d612a', 'da0c91', '8a8de0', '121b10', '75e4c3', 'f7f532'}

tablezonetext = {}



sidepottext = {} --  textes for current player bets

sidepottextGUIDs = {}

currenbettext = {}

currentbettextGUID = 'ed7b0b'

colorball = null

overlay = {}

overlayGUID = '290051'

actiontext = {}

actiontextGUID = '20e11d'

optionspanel = nil

optionsbutton = {}

optionsbuttonGUID = '6e1caf'

scripts = {} -- Scripts copied from objects in onload, used when 'Reset Objects' is clicked.

activeplayers = {['White'] = nil, ['Red'] = nil, ['Orange'] = nil, ['Yellow'] = nil, ['Green'] = nil, ['Teal'] = nil, ['Blue'] = nil, ['Purple'] = nil}



savebag = {}

savebagGUID = '6215eb'

newsavebagbutton = {}

newsavebagbuttonGUID = '6aa67a'



saves = {['White'] = nil, ['Red'] = nil, ['Orange'] = nil, ['Yellow'] = nil, ['Green'] = nil, ['Teal'] = nil, ['Blue'] = nil, ['Purple'] = nil}





-- Currencies

currenciesSelection = -- Includes all different type of chips, last entry will be used as dummy entry for unknown chips

{

  ['default - $100'] =

  {

    {

      ["value"] = 100000, -- Value of the Chip

      ["name"] = "$100,000", -- Name of the chip

      ["label"] = "$100k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.06,

      ["custom"] =

      {

        ["mesh"] = "http://pastebin.com/raw.php?i=ruZEQex3", -- obj file

        ["diffuse"] = "  http://i.imgur.com/hJIzRFn.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 90, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {0.75, 0.75, 0.75} -- the scale at which to spawn the object

      },

      ["stack"] = "10" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 50000, -- Value of the Chip

      ["name"] = "$50,000", -- Name of the chip

      ["label"] = "$50k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.06,

      ["custom"] =

      {

        ["mesh"] = "http://pastebin.com/raw.php?i=ruZEQex3", -- obj file

        ["diffuse"] = "http://i.imgur.com/m4pRnEa.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 90, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {0.75, 0.75, 0.75} -- the scale at which to spawn the object

      },

      ["stack"] = "9" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 25000, -- Value of the Chip

      ["name"] = "$25,000", -- Name of the chip

      ["label"] = "$25k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.06,

      ["custom"] =

      {

        ["mesh"] = "http://pastebin.com/raw.php?i=ruZEQex3", -- obj file

        ["diffuse"] = "http://i.imgur.com/mIZ9NXm.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 90, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {0.75, 0.75, 0.75} -- the scale at which to spawn the object

      },

      ["stack"] = "8" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },



    {

      ["value"] = 10000, -- Value of the Chip

      ["name"] = "$10,000", -- Name of the chip

      ["label"] = "$10k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.35,

      ["custom"] =

      {

        ["mesh"] = "http://pastebin.com/raw/QqdA0six", -- obj file

        ["diffuse"] = "http://i.imgur.com/kp8fFK0.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {0.75, 0.75, 0.75} -- the scale at which to spawn the object

      },

      ["stack"] = "7" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 5000, -- Value of the Chip

      ["name"] = "$5,000", -- Name of the chip

      ["label"] = "$5k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.35,

      ["custom"] =

      {

        ["mesh"] = "http://pastebin.com/raw/QqdA0six", -- obj file

        ["diffuse"] = "http://i.imgur.com/QQhHmVP.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {0.75, 0.75, 0.75} -- the scale at which to spawn the object

      },

      ["stack"] = "6" -- spot position for collecting/spawning (potzone and betting zone on sidepot)



    },

    {

      ["value"] = 1000, -- Value of the Chip

      ["name"] = "$1000", -- Name of the chip

      ["label"] = "$1000", -- Label used for converting machine

      ["standard"] = true, -- Standard tabletop chips true/false

      ["height"] = 0.15,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "3" -- stack where the chips are put in

    },

    {

      ["value"] = 500, -- Value of the Chip

      ["name"] = "$500", -- Name of the chip

      ["label"] = "$500", -- Label used for converting machine

      ["standard"] = true, -- Standard tabletop chips true/false

      ["height"] = 0.15,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "2" -- stack where the chips are put in

    },

    {

      ["value"] = 100, -- Value of the Chip

      ["name"] = "$100", -- Name of the chip

      ["label"] = "$100", -- Label used for converting machine

      ["standard"] = true, -- Standard tabletop chips true/false

      ["height"] = 0.15,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "1" -- stack where the chips are put in

    }

    , -- dummy for unknown chips

    {

      ["value"] = -1, -- Value of the Chip

      ["name"] = "unknown", -- Name of the chip

      ["standard"] = false, -- Standard tabletop chips true/false

      ["label"] = "dummy", -- Label used for converting machine

      ["height"] = 0.3,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "10" -- stack where the chips are put in

    }

  },



  ['default - $10'] =

  {

    {

      ["value"] = 100000, -- Value of the Chip

      ["name"] = "$100,000", -- Name of the chip

      ["label"] = "$100k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.05,

      ["custom"] =

      {

        ["mesh"] = "http://pastebin.com/raw.php?i=ruZEQex3", -- obj file

        ["diffuse"] = "http://i.imgur.com/hJIzRFn.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 90, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {0.75, 0.75, 0.75} -- the scale at which to spawn the object

      },

      ["stack"] = "9" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 50000, -- Value of the Chip

      ["name"] = "$50,000", -- Name of the chip

      ["label"] = "$50k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.05,

      ["custom"] =

      {

        ["mesh"] = "http://pastebin.com/raw.php?i=ruZEQex3", -- obj file

        ["diffuse"] = "http://i.imgur.com/m4pRnEa.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 90, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {0.75, 0.75, 0.75} -- the scale at which to spawn the object

      },

      ["stack"] = "8" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 10000, -- Value of the Chip

      ["name"] = "$10,000", -- Name of the chip

      ["label"] = "$10k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.35,

      ["custom"] =

      {

        ["mesh"] = "http://pastebin.com/raw/QqdA0six", -- obj file

        ["diffuse"] = "http://i.imgur.com/kp8fFK0.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {0.75, 0.75, 0.75} -- the scale at which to spawn the object

      },

      ["stack"] = "7" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 5000, -- Value of the Chip

      ["name"] = "$5,000", -- Name of the chip

      ["label"] = "$5k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.35,

      ["custom"] =

      {

        ["mesh"] = "http://pastebin.com/raw/QqdA0six", -- obj file

        ["diffuse"] = "http://i.imgur.com/QQhHmVP.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {0.75, 0.75, 0.75} -- the scale at which to spawn the object

      },

      ["stack"] = "6" -- spot position for collecting/spawning (potzone and betting zone on sidepot)



    },

    {

      ["value"] = 1000, -- Value of the Chip

      ["name"] = "$1000", -- Name of the chip

      ["label"] = "$1000", -- Label used for converting machine

      ["standard"] = true, -- Standard tabletop chips true/false

      ["height"] = 0.15,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "5" -- stack where the chips are put in

    },

    {

      ["value"] = 500, -- Value of the Chip

      ["name"] = "$500", -- Name of the chip

      ["label"] = "$500", -- Label used for converting machine

      ["standard"] = true, -- Standard tabletop chips true/false

      ["height"] = 0.15,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "4" -- stack where the chips are put in

    },

    {

      ["value"] = 100, -- Value of the Chip

      ["name"] = "$100", -- Name of the chip

      ["label"] = "$100", -- Label used for converting machine

      ["standard"] = true, -- Standard tabletop chips true/false

      ["height"] = 0.15,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "3" -- stack where the chips are put in

    },

    {

      ["value"] = 50, -- Value of the Chip

      ["name"] = "$50", -- Name of the chip

      ["label"] = "$50", -- Label used for converting machine

      ["standard"] = true, -- Standard tabletop chips true/false

      ["height"] = 0.15,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "2" -- stack where the chips are put in

    },

    {

      ["value"] = 10, -- Value of the Chip

      ["name"] = "$10", -- Name of the chip

      ["label"] = "$10", -- Label used for converting machine

      ["standard"] = true, -- Standard tabletop chips true/false

      ["height"] = 0.15,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "1" -- stack where the chips are put in

    }

    , -- dummy for unknown chips

    {

      ["value"] = -1, -- Value of the Chip

      ["name"] = "unknown", -- Name of the chip

      ["standard"] = false, -- Standard tabletop chips true/false

      ["label"] = "dummy", -- Label used for converting machine

      ["height"] = 0.3,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "10" -- stack where the chips are put in

    }

  },



  ['World Series Of Poker - $500'] =

  {

    {

      ["value"] = 1000000, -- Value of the Chip

      ["name"] = "$1,000,000", -- Name of the chip

      ["label"] = "$1m", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/CJC9YS9.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "11" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 500000, -- Value of the Chip

      ["name"] = "$500,000", -- Name of the chip

      ["label"] = "$500k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/i28Myqn.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "10" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 250000, -- Value of the Chip

      ["name"] = "$250,000", -- Name of the chip

      ["label"] = "$250k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/LHrlLDb.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "9" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 100000, -- Value of the Chip

      ["name"] = "$100,000", -- Name of the chip

      ["label"] = "$100k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/E9gcjqL.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "8" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 50000, -- Value of the Chip

      ["name"] = "$50,000", -- Name of the chip

      ["label"] = "$50k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/kiUBfn5.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "7" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    }

    ,

    {

      ["value"] = 25000, -- Value of the Chip

      ["name"] = "$25,000", -- Name of the chip

      ["label"] = "$25k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/4R6mQkk.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "6" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 10000, -- Value of the Chip

      ["name"] = "$10,000", -- Name of the chip

      ["label"] = "$10k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/oVDeVyt.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "5" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },



    {

      ["value"] = 5000, -- Value of the Chip

      ["name"] = "$5,000", -- Name of the chip

      ["label"] = "$5000", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/g5ss9fH.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "4" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },



    {

      ["value"] = 2500, -- Value of the Chip

      ["name"] = "$2,500", -- Name of the chip

      ["label"] = "$2500", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/noppTnL.png", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "3" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 1000, -- Value of the Chip

      ["name"] = "$1,000", -- Name of the chip

      ["label"] = "$1000", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/IEAM8Fh.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "2" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 500, -- Value of the Chip

      ["name"] = "$500", -- Name of the chip

      ["label"] = "$500", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/nOxPst2.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "1" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    -- dummy for unknown chips

    {

      ["value"] = -1, -- Value of the Chip

      ["name"] = "unknown", -- Name of the chip

      ["standard"] = false, -- Standard tabletop chips true/false

      ["label"] = "dummy", -- Label used for converting machine

      ["height"] = 0.3,

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "13" -- stack where the chips are put in

    }

  },



  ['World Series Of Poker - $100'] =

  {

    {

      ["value"] = 1000000, -- Value of the Chip

      ["name"] = "$1,000,000", -- Name of the chip

      ["label"] = "$1m", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/CJC9YS9.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "12" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 500000, -- Value of the Chip

      ["name"] = "$500,000", -- Name of the chip

      ["label"] = "$500k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/i28Myqn.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "11" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 250000, -- Value of the Chip

      ["name"] = "$250,000", -- Name of the chip

      ["label"] = "$250k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/LHrlLDb.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "10" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 100000, -- Value of the Chip

      ["name"] = "$100,000", -- Name of the chip

      ["label"] = "$100k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/E9gcjqL.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "9" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 50000, -- Value of the Chip

      ["name"] = "$50,000", -- Name of the chip

      ["label"] = "$50k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/kiUBfn5.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "8" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    }

    ,

    {

      ["value"] = 25000, -- Value of the Chip

      ["name"] = "$25,000", -- Name of the chip

      ["label"] = "$25k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/4R6mQkk.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "7" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 10000, -- Value of the Chip

      ["name"] = "$10,000", -- Name of the chip

      ["label"] = "$10k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/oVDeVyt.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "6" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },



    {

      ["value"] = 5000, -- Value of the Chip

      ["name"] = "$5,000", -- Name of the chip

      ["label"] = "$5000", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/g5ss9fH.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "5" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },



    {

      ["value"] = 2500, -- Value of the Chip

      ["name"] = "$2,500", -- Name of the chip

      ["label"] = "$2500", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/noppTnL.png", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "4" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 1000, -- Value of the Chip

      ["name"] = "$1,000", -- Name of the chip

      ["label"] = "$1000", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/IEAM8Fh.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "3" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 500, -- Value of the Chip

      ["name"] = "$500", -- Name of the chip

      ["label"] = "$500", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/nOxPst2.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "2" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },



    {

      ["value"] = 100, -- Value of the Chip

      ["name"] = "$100", -- Name of the chip

      ["label"] = "$100", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/RHmy71O.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "1" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    }

    , -- dummy for unknown chips

    {

      ["value"] = -1, -- Value of the Chip

      ["name"] = "unknown", -- Name of the chip

      ["standard"] = false, -- Standard tabletop chips true/false

      ["label"] = "dummy", -- Label used for converting machine

      ["height"] = 0.3,

      ["params"] =

      {

        ["rotation"] = {0, 270, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "13" -- stack where the chips are put in

    }

  },



  ['World Series Of Poker - $25'] =

  {

    {

      ["value"] = 1000000, -- Value of the Chip

      ["name"] = "$1,000,000", -- Name of the chip

      ["label"] = "$1m", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/CJC9YS9.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "14" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 500000, -- Value of the Chip

      ["name"] = "$500,000", -- Name of the chip

      ["label"] = "$500k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/i28Myqn.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "13" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 250000, -- Value of the Chip

      ["name"] = "$250,000", -- Name of the chip

      ["label"] = "$250k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/LHrlLDb.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "12" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 100000, -- Value of the Chip

      ["name"] = "$100,000", -- Name of the chip

      ["label"] = "$100k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/E9gcjqL.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "11" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 50000, -- Value of the Chip

      ["name"] = "$50,000", -- Name of the chip

      ["label"] = "$50k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/kiUBfn5.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "10" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    }

    ,

    {

      ["value"] = 25000, -- Value of the Chip

      ["name"] = "$25,000", -- Name of the chip

      ["label"] = "$25k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/4R6mQkk.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "9" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 10000, -- Value of the Chip

      ["name"] = "$10,000", -- Name of the chip

      ["label"] = "$10k", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/oVDeVyt.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "8" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },



    {

      ["value"] = 5000, -- Value of the Chip

      ["name"] = "$5,000", -- Name of the chip

      ["label"] = "$5000", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/g5ss9fH.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "7" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },



    {

      ["value"] = 2500, -- Value of the Chip

      ["name"] = "$2,500", -- Name of the chip

      ["label"] = "$2500", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/noppTnL.png", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "6" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 1000, -- Value of the Chip

      ["name"] = "$1,000", -- Name of the chip

      ["label"] = "$1000", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/IEAM8Fh.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "5" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },

    {

      ["value"] = 500, -- Value of the Chip

      ["name"] = "$500", -- Name of the chip

      ["label"] = "$500", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/nOxPst2.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "4" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },



    {

      ["value"] = 100, -- Value of the Chip

      ["name"] = "$100", -- Name of the chip

      ["label"] = "$100", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/RHmy71O.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "3" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    },



    {

      ["value"] = 50, -- Value of the Chip

      ["name"] = "$50", -- Name of the chip

      ["label"] = "$50", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/6SgDPma.png", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "2" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    }

    ,



    {

      ["value"] = 25, -- Value of the Chip

      ["name"] = "$25", -- Name of the chip

      ["label"] = "$25", -- Label used for converting machine

      ["standard"] = false, -- Standard tabletop chips (1000, 500, 100, 50, 10)

      ["height"] = 0.15,

      ["custom"] =

      {

        ["mesh"] = "https://www.dropbox.com/s/xtrjnjilifnjvsw/Chip.obj?dl=1", -- obj file

        ["diffuse"] = "http://i.imgur.com/BFGnKIK.jpg", -- diffuse image

        ["type"] = 5, -- 5 is a 'chip'

        ["material"] = 1 -- 0: plastic, 1: wood, 2: metal, 3: cardboard

      },

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "1" -- spot position for collecting/spawning (potzone and betting zone on sidepot)

    }

    , -- dummy for unknown chips

    {

      ["value"] = -1, -- Value of the Chip

      ["name"] = "unknown", -- Name of the chip

      ["standard"] = false, -- Standard tabletop chips true/false

      ["label"] = "dummy", -- Label used for converting machine

      ["height"] = 0.3,

      ["params"] =

      {

        ["rotation"] = {0, 0, 0}, -- rotation of the object (in relation to the machine) when it spawns

        ["scale"] = {1, 1, 1} -- the scale at which to spawn the object

      },

      ["stack"] = "15" -- stack where the chips are put in

    }

  },

}









stacklayout =

{

  ['5-5-5'] =

  {

    ["1"] =

    {

      ["xoffset"] = 3.75,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = -2,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["2"] =

    {

      ["xoffset"] = 2,

      ["yoffset"] = 0.0825,

      ["zoffset"] = -2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["3"] =

    {

      ["xoffset"] = 0.25,

      ["yoffset"] = 0.0825,

      ["zoffset"] = -2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["4"] =

    {

      ["xoffset"] = -1.5,

      ["yoffset"] = 0.2,

      ["zoffset"] = -2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["5"] =

    {

      ["xoffset"] = -3.25,

      ["yoffset"] = 0.2,

      ["zoffset"] = -2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    }

    ,

    ["6"] =

    {

      ["xoffset"] = 3.75,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = 0,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["7"] =

    {

      ["xoffset"] = 2,

      ["yoffset"] = 0.0825,

      ["zoffset"] = 0,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["8"] =

    {

      ["xoffset"] = 0.25,

      ["yoffset"] = 0.0825,

      ["zoffset"] = 0,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["9"] =

    {

      ["xoffset"] = -1.5,

      ["yoffset"] = 0.2,

      ["zoffset"] = 0,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["10"] =

    {

      ["xoffset"] = -3.25,

      ["yoffset"] = 0.2,

      ["zoffset"] = 0,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },



    ["11"] =

    {

      ["xoffset"] = 3.75,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = 2,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["12"] =

    {

      ["xoffset"] = 2,

      ["yoffset"] = 0.0825,

      ["zoffset"] = 2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["13"] =

    {

      ["xoffset"] = 0.25,

      ["yoffset"] = 0.0825,

      ["zoffset"] = 2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["14"] =

    {

      ["xoffset"] = -1.5,

      ["yoffset"] = 0.2,

      ["zoffset"] = 2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["misc"] =

    {

      ["xoffset"] = -3.25,

      ["yoffset"] = 0.2,

      ["zoffset"] = 2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

  },



  ['5-2-3'] =

  {

    ["1"] =

    {

      ["xoffset"] = 3.75,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = -2,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["2"] =

    {

      ["xoffset"] = 2,

      ["yoffset"] = 0.0825,

      ["zoffset"] = -2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["3"] =

    {

      ["xoffset"] = 0.25,

      ["yoffset"] = 0.0825,

      ["zoffset"] = -2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["4"] =

    {

      ["xoffset"] = -1.5,

      ["yoffset"] = 0.2,

      ["zoffset"] = -2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["5"] =

    {

      ["xoffset"] = -3.25,

      ["yoffset"] = 0.2,

      ["zoffset"] = -2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    }

    ,

    ["6"] =

    {

      ["xoffset"] = 2,

      ["yoffset"] = 0.2,

      ["zoffset"] = 0,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    }

    ,

    ["7"] =

    {

      ["xoffset"] = -2.5,

      ["yoffset"] = 0.2,

      ["zoffset"] = 0,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    }

    ,



    ["8"] =

    {

      ["xoffset"] = 3,

      ["yoffset"] = 0.2,

      ["zoffset"] = 2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    }

    ,

    ["misc"] =

    {

      ["xoffset"] = -3,

      ["yoffset"] = 0.2,

      ["zoffset"] = 2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    }

    ,

  },



  ['Half Circle'] =

  {

    ["1"] =

    {

      ["xoffset"] = 4,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = -2,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["2"] =

    {

      ["xoffset"] = 3.58,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = -0.34,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["3"] =

    {

      ["xoffset"] = 2.45,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = 1.15,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["4"] =

    {

      ["xoffset"] = 0.81,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = 1.89,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["5"] =

    {

      ["xoffset"] = -0.81,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = 1.89,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["6"] =

    {

      ["xoffset"] = -2.45,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = 1.15,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["7"] =

    {

      ["xoffset"] = -3.58,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = -0.34,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["misc"] =

    {

      ["xoffset"] = -4,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = -2,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

  },



  -- For Cash Stacks

  ['2-2-2'] =

  {

    ["1"] =

    {

      ["xoffset"] = 2,

      ["yoffset"] = 0.0825, -- half of the object's height to put its bottom on the surface

      ["zoffset"] = -2,

      ["height"] = 0, -- height of current stack

      ["x"] = 0, -- coordinates of stack relative to the spawned objects

      ["y"] = 0,

      ["z"] = 0

    },

    ["2"] =

    {

      ["xoffset"] = -2.5,

      ["yoffset"] = 0.0825,

      ["zoffset"] = -2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    },

    ["3"] =

    {

      ["xoffset"] = 2,

      ["yoffset"] = 0.2,

      ["zoffset"] = 0,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    }

    ,

    ["4"] =

    {

      ["xoffset"] = -2.5,

      ["yoffset"] = 0.2,

      ["zoffset"] = 0,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    }

    ,

    ["5"] =

    {

      ["xoffset"] = 2,

      ["yoffset"] = 0.2,

      ["zoffset"] = 2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    }

    ,



    ["misc"] =

    {

      ["xoffset"] = -2.5,

      ["yoffset"] = 0.2,

      ["zoffset"] = 2,

      ["height"] = 0,

      ["x"] = 0,

      ["y"] = 0,

      ["z"] = 0

    }

    ,

  },



}



currenciesSelectionStacklayout =

{

  ["default - $100"] = { "5-2-3" },

  ["default - $10"] = { "5-2-3" },

  ["World Series Of Poker - $500"] = { "5-5-5", "Honeycomb", "Half Circle" },

  ["World Series Of Poker - $100"] = { "5-5-5", "Honeycomb", "Half Circle" },

  ["World Series Of Poker - $25"] = { "5-5-5", "Honeycomb", "Half Circle" },



}



currencies = {}



--[[ Overlay images --]]

themes =

{

  { -- themeindex 1

    ["label"] = 'Poker',

    { -- subthemeindex 1

      ["label"] = 'Felt',

      {

        ["label"] = 'Plain Felt',

        ["diffuse"] = 'http://i.imgur.com/jPnTE9e.png'

      },

      {

        ["label"] = 'MGM Grant',

        ["diffuse"] = 'http://i.imgur.com/phQrMs9.jpg'

      }

    }

  }

}



--[[ onLoad function --]]



function onload(save_state)

  local saveddata = JSON.decode(save_state)



  --[[ Get object references --]]

  boardzone = getObjectFromGUID(boardzoneGUID)

  newdeckbutton = getObjectFromGUID(newdeckbuttonGUID)

  newsavebagbutton = getObjectFromGUID(newsavebagbuttonGUID)

  dealbutton = getObjectFromGUID(dealbuttonGUID)

  resetbutton = getObjectFromGUID(resetbuttonGUID)

  sidepotbutton = getObjectFromGUID(sidepotbuttonGUID)

  muckzone = getObjectFromGUID(muckzoneGUID)

  collectbutton = getObjectFromGUID(collectbuttonGUID)



  for i, v in ipairs (colors) do

    local playerhand = getPlayerHandPositionAndRotation(v)



    betzones[v] = getObjectFromGUID(betzoneGUIDs[i])

    tablezones[v] = getObjectFromGUID(tablezoneGUIDs[i])

    backtablezones[v] = getObjectFromGUID(backtablezoneGUIDs[i])

    bettext[v] = getObjectFromGUID(bettextGUIDs[i])

  end

  potzones[1] = getObjectFromGUID(mainpotzoneGUID)

  for i, v in ipairs (sidepotzoneGUIDs) do

    potzones[#potzones + 1] = getObjectFromGUID(v)

  end

  actionbutton = getObjectFromGUID(actionbuttonGUID)

  optionsbutton = getObjectFromGUID(optionsbuttonGUID)

  sidepotbutton = getObjectFromGUID(sidepotbuttonGUID)

  if saveddata == nil then

    --[[ Initialize texts --]]

    hideActionText()

    pottext.setPosition ({0, 1.33, 0})

    pottext.setRotation ({90, 180, 0})

    currentbettext.setPosition ({0, 1.33, 1})

    currentbettext.setRotation({90, 180, 0})

    mainpotchips = initializePot()

  else

    if saveddata.options ~= nil then options = saveddata.options end



    if saveddata.holedealt ~= nil then holedealt = saveddata.holedealt end

    if saveddata.dealing ~= nil then dealing = saveddata.dealing end

    if saveddata.players ~= nil then players = saveddata.players end

    if saveddata.actionon ~= nil then actionon = saveddata.actionon end

    if saveddata.playerbets ~= nil then playerbets = saveddata.playerbets end

    if saveddata.currentbet ~= nil then currentbet = saveddata.currentbet end

    if saveddata.mainpotchips ~= nil then mainpotchips = saveddata.mainpotchips end

    if saveddata.pot ~= nil then pot = saveddata.pot end

    if saveddata.collecting ~= nil then collecting = saveddata.collecting end

    if saveddata.collectmethod ~= nil then collectmethod = saveddata.collectmethod end

    if saveddata.convertstackheight ~= nil then convertstackheight = saveddata.convertstackheight end

    if saveddata.hybridthreshold ~= nil then hybridthreshold = saveddata.hybridthreshold end

    if saveddata.handinprogress ~= nil then handinprogress = saveddata.handinprogress end



    if saveddata.savebagGUID ~= nil then savebagGUID = saveddata.savebagGUID end

    if saveddata.deckGUID ~= nil then deckGUID = saveddata.deckGUID end

    if saveddata.muckGUID ~= nil then muckGUID = saveddata.muckGUID end

    if saveddata.potobjectGUID ~= nil then potobjectGUID = saveddata.potobjectGUID end

    if saveddata.boardobjectGUID ~= nil then boardobjectGUID = saveddata.boardobjectGUID end

    if saveddata.overlayGUID ~= nil then overlayGUID = saveddata.overlayGUID end

    if saveddata.pottextGUID ~= nil then pottextGUID = saveddata.pottextGUID end

    if saveddata.currentbettextGUID ~= nil then currentbettextGUID = saveddata.currentbettextGUID end

    if saveddata.actiontextGUID ~= nil then actiontextGUID = saveddata.actiontextGUID end

    if saveddata.revealedcards ~= nil then revealedcards = saveddata.revealedcards end

    if saveddata.holecards ~= nil then holecards = saveddata.holecards end

    if saveddata.handsshown ~= nil then handsshown = saveddata.handsshown end



    if saveddata.bettext ~= nil then

      bettext = JSON.decode(saveddata.bettext)

      if saveddata.bettext ~= nil then

        for i, v in ipairs(colors) do

          bettext[v] = getObjectFromGUID(bettext[v])

        end

      end

    end

    if saveddata.sidepottext ~= nil then

      sidepottext = JSON.decode(saveddata.sidepottext)

      for i, v in ipairs(colors) do

        sidepottext[v] = getObjectFromGUID(sidepottext[v])

      end

    end

    if saveddata.tablezonetext ~= nil then

      tablezonetext = JSON.decode(saveddata.tablezonetext)

      for i, v in ipairs(colors) do

        tablezonetext[v] = getObjectFromGUID(tablezonetext[v])

      end

    end



  end



  deck = getObjectFromGUID(deckGUID)

  muck = getObjectFromGUID(muckGUID)

  boardobject = getObjectFromGUID(boardobjectGUID)

  potobject = getObjectFromGUID(potobjectGUID)

  pottext = getObjectFromGUID(pottextGUID)

  currentbettext = getObjectFromGUID(currentbettextGUID)

  actiontext = getObjectFromGUID(actiontextGUID)

  savebag = getObjectFromGUID(savebagGUID)

  if options.displayplayerbet == nil then

    options.displayplayerbet = true

  end

  if options.displayplayermoney == nil then

    options.displayplayermoney = true

  end

  if options.playerbuttons == nil then

    options["playerbuttons"] =

    {

      ["sortchips"] = true,

      ["convert"] = true,

      ["allin"] = true,

      ["afk"] = true,

      ["loadsavebag"] = false

    }

  end

  if options.playerbuttons == nil then

    options.playerbuttons = {}

  end

  if options.playerbuttons.sortchips == nil then

    options.playerbuttons.sortchips = true

  end

  if options.playerbuttons.convert == nil then

    options.playerbuttons.convert = true

  end

  if options.playerbuttons.allin == nil then

    options.playerbuttons.allin = true

  end

  if options.playerbuttons.afk == nil then

    options.playerbuttons.afk = true

  end

  if options.playerbuttons.loadsavebag == nil then

    options.playerbuttons.loadsavebag = false

  end



  if options.autoclocktime == nil then

    options.autoclocktime = 5

    options.autoclock = false

    options.autofold = false

    options.clockpausebutton = true

  end

  if options.convertstackheight == nil then

    options.convertstackheight = 0

  end

  if options.currencies == nil or options.stacklayout == nil then

    options.currencies = "default"

    options.stacklayout = "default"

    currencies = currenciesSelection[options.currencies]

  else

    currencies = currenciesSelection[options.currencies]



    if currencies == nil then

      options.currencies = "default"

      options.stacklayout = "default"

      currencies = currenciesSelection[options.currencies]

    end

  end







  --[[ Create buttons --]]

  local button = {}



  --[[ use this button to assign a new deck --]]

  button.label = 'New\nDeck'

  button.click_function = "newDeck"

  button.function_owner = nil

  button.position = {0, 0.08, 0}

  button.rotation = {0, 180, 0}

  button.width = 525

  button.height = 525

  button.font_size = 150

  newdeckbutton.createButton(button)



  --[[ This button deals cards for each stage of the hand --]]

  button.label = 'Deal'

  button.click_function = "deal"

  button.font_size = 150

  dealbutton.createButton(button)





  --[[ Resets deck and variables --]]

  button.label = 'Reset'

  button.click_function = "resetGame"

  button.rotation = {0, 0, 0}

  resetbutton.createButton(button)



  --[[ Move bets to pot --]]

  button.label = 'Collect\nBets'

  button.click_function = "collectBets"

  button.font_size = 150

  collectbutton.createButton(button)



  --[[ Move action text --]]

  button.label = 'Done'

  button.font_size = 150

  button.click_function = "action"

  actionbutton.createButton(button)



  --[[ Open options menu --]]

  button.label = 'Options'

  button.font_size = 150

  button.click_function = "spawnOptionsPanel"

  optionsbutton.createButton(button)



  --[[ Create Side Pots --]]

  button.label = 'Create\nSidepot'

  button.font_size = 150

  button.click_function = "createSidepot"

  sidepotbutton.createButton(button)





  --[[ assign new savebag --]]

  button.label = 'New\nSavebag'

  button.font_size = 150

  button.click_function = "newSavebag"

  newsavebagbutton.createButton(button)



  createPlayerButtons()





  for i, v in ipairs(getAllObjects()) do

    if v.getName() == 'Pot Splitter' then

      button.rotation = {0, 0, 0}

      button.width = 45

      button.height = 45

      button.font_size = 42

      potsplitter[#potsplitter + 1] = v

      p = v.getPosition()

      button.position = { - 0.40, 0.3, - 0.95}

      i = 2

      while i < 11 do

        button.click_function = "splitPot" .. i

        button.label = tostring(i)

        button.position[1] = button.position[1] + 0.08

        v.createButton(button)

        i = i + 1

      end

    end



    if v.getName() == 'Back Table' and options.changemachine then

      local offsetx = 2 / #currencies

      local button = {}

      v.clearButtons()

      local offsetx = 2 / #currencies

      local button = {}



      if #currencies <= 10 then

        offsetx = 1.65 / (#currencies - 2)

      else

        offsetx = 1.65 / 8

      end

      local offsety = 2 / #currencies

      button.font_size = 150

      button.width = 450

      button.height = 250

      button.scale = {1 / 5, 1 / 5, 1 / 7.5}

      button.position = {0.83, - 0.1, - 0.9}

      button.rotation = {180, 0, 0}



      for j, w in ipairs(currencies) do

        if w.value ~= -1 then

          button.label = w.label

          button.click_function = 'changeMachineButton' .. j

          v.createButton(button)

          button.position[1] = button.position[1] - offsetx

        end

        if j == 9 then

          if #currencies - 11 > 0 then

            offsetx = 1.65 / (#currencies - 11)

            button.position = {0.83, - 0.1, - 0.8} -- spawn 1 button in the center

          else

            button.position = {0, - 0.1, - 0.8} -- spawn 1 button in the center

          end

        end

      end

    end

  end

  --[[ Make non-interactable parts to non-interactable --]]

  local custom = {}







  for i, v in ipairs (getAllObjects()) do

    if v.getName() == 'Bet Square' or v.getName() == 'Front Table' or v.getName() == 'Back Table' or v.getName() == 'Dealer Table' or v.getName() == 'Change Box' then

      v.interactable = false

    elseif v.getName() == 'Table Overlay' then

      overlay = v

      v.interactable = false

    end

  end



  muck.setColorTint(pottext.TextTool.getFontColor())

  boardobject.setColorTint(pottext.TextTool.getFontColor())



  --[[ Copy scripts from objects. These are used when objects are respawned with 'Reset Objects' button on the options menu --]]

  scripts[1] = muck.getLuaScript()

  scripts[2] = boardobject.getLuaScript()

  scripts[3] = potobject.getLuaScript()

  scripts[4] = actiontext.getLuaScript()





end



function onSave()

  --print ('saved')

  local savebettext = {}

  local savesidepottext = {}

  local savetablezonetext = {}

  for i, v in pairs (colors) do

    savebettext[v] = bettext[v].getGUID()

    savesidepottext[v] = sidepottext[v].getGUID()

    savetablezonetext[v] = tablezonetext[v].getGUID()

  end



  if savebag ~= nil then

    savebagGUID = savebag.getGUID()

  end



  local tosave = {

    options = options,



    holedealt = holedealt,

    dealing = false,

    players = players,

    actionon = actionon,

    playerbets = playerbets,

    currentbet = currentbet,

    mainpotchips = mainpotchips,

    pot = pot,

    collecting = false,

    handinprogress = handinprogress,



    deckGUID = deck.getGUID(),

    muckGUID = muck.getGUID(),

    potobjectGUID = potobject.getGUID(),

    boardobjectGUID = boardobject.getGUID(),

    overlayGUID = overlay.getGUID(),

    pottextGUID = pottext.getGUID(),

    currentbettextGUID = currentbettext.getGUID(),

    actiontextGUID = actiontext.getGUID(),

    holecards = holecards,

    revealedcards = revealedcards,

    handsshown = handsshown,

    savebagGUID = savebagGUID,

    bettext = JSON.encode(savebettext),

    sidepottext = JSON.encode(savesidepottext),

    tablezonetext = JSON.encode(savetablezonetext)



  }

  return JSON.encode(tosave)



end



function createPlayerButtons()

  --[[ Create sort Chips onPlayers --]]



  button = {}



  button.rotation = {0, 180, 180}

  button.width = 250

  button.height = 15

  button.font_size = 50



  for i, v in ipairs(getAllObjects()) do



    posy = 0.75

    if v.getName() == 'Front Table' then

      v.clearButtons()



      if options.playerbuttons.sortchips then

        posy = posy - 0.3

        button.font_size = 50

        button.height = 25

        p = v.getPosition()

        button.label = 'SortChips'

        button.position = {0.75, - 0.1, posy}

        button.click_function = 'sortPlayerChips'

        v.createButton(button)

      end



      if options.playerbuttons.convert then

        posy = posy - 0.3

        p = v.getPosition()

        button.label = 'Convert'

        button.position = {0.75, - 0.1, posy}

        button.font_size = 50

        button.height = 25

        button.click_function = 'quickConvertPlayerChips10_5'

        v.createButton(button)

      end





      if options.playerbuttons.allin then

        posy = posy - 0.3

        p = v.getPosition()

        button.height = 15

        button.font_size = 50

        button.label = 'All In'

        button.position = {0.75, - 0.1, posy}

        button.click_function = 'goAllIn'

        v.createButton(button)

      end



      if options.playerbuttons.afk then

        posy = posy - 0.3

        button.height = 15

        button.font_size = 50

        button.label = 'AFK'

        button.position = {0.75, - 0.1, posy}

        button.click_function = 'goAFK'

        v.createButton(button)

      end



      if options.playerbuttons.loadsavebag then

        posy = posy - 0.3

        button.height = 15

        button.font_size = 50

        button.label = 'load save'

        button.position = {0.75, - 0.1, posy}

        button.click_function = 'loadSaveBag'

        v.createButton(button)

      end

    end

  end

end

--[[ deal function: determines whether to deal players' hands, flop, turn, or river --]]



function deal(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  sidepotcalculated = false;



  if deck == nil or deck == null then

    for i, v in ipairs (getSeatedPlayers()) do

      if Player[v].admin then

        broadcastToColor('No deck assigned. Please assign a deck with the \'New Deck\' button.', v, {1, 0.3, 0.3})

      end

    end

    return 1

  end



  if boardobject == nil or boardobject == null then

    print ('The board object has been lost. Please click the \'Reset Objects\' button on the options panel to reassign.')

    --return 1

    checkAndRespawnObjects()

  end



  if muck == nil or muck == null then

    print ('The muck object has been lost. Please click the \'Reset Objects\' button on the options panel to reassign.')

    --return 1

    checkAndRespawnObjects()

  end



  if pottext == nil or pottext == null then

    print ('The pot text has been deleted. Please click the \'Reset Objects\' button on the options panel to respawn.')

    --return 1

    checkAndRespawnObjects()

  end



  if currentbettext == nil or currentbettext == null then

    print ('The current bet text has been deleted. Please click the \'Reset Objects\' button on the options panel to respawn.')

    --return 1

    checkAndRespawnObjects()

  end



  if actiontext == nil or actiontext == null then

    print ('The action text has been deleted. Please click the \'Reset Objects\' button on the options panel to respawn.')

    --return 1

    checkAndRespawnObjects()

  end



  for i, v in ipairs(colors) do

    if bettext[v] == nil or bettext[v] == null then

      print ('bettext of color ' .. v .. ' has been deleted')

      checkAndRespawnObjects()

    end

    if sidepottext[v] == nil or sidepottext[v] == null then

      print ('sidepottext of color ' .. v .. ' has been deleted')

      checkAndRespawnObjects()

    end

    if tablezonetext[v] == nil or tablezonetext[v] == null then

      print ('tablezonetext of color ' .. v .. ' has been deleted')

      checkAndRespawnObjects()

    end









  end



  if not dealing then

    if not holedealt then

      hole(pl)

    else

      local cards = boardzone.getObjects()

      local x = 0

      for i, v in ipairs (cards) do

        if v.tag == "Card" then

          x = x + 1

        end

      end



      if x == 0 then

        flop ()

      elseif x == 3 then

        turn ()

      elseif x == 4 then

        river ()

      elseif x == 5 then

        broadcastToAll('Showtime!', {1, 1, 1})

      else

        broadcastToColor("[ff0000]Error:[ffffff] Invalid board", pl, {1, 1, 1})

      end

    end

  end



end



--[[ This function returns an ordered list of seated players who do not have an afk button or busted token.

    The first entry will be the player to the dealers left, and the dealer will be the last entry.

    If the dealer button is not found, returns nil. --]]



function getOrderedListOfPlayers(pl)



  local dealer = nil

  local afk = {} -- list of afk players

  local busted = {} -- list of busted players determined by busted tokens in their bet zones (when a player busts out, I usually make them sit out for a few hands before giving them more money)

  local objects = {} -- list of objects found in the dealerzones

  local dealerafk = false

  local bustedbombs = {}



  -- First, look for the dealer button. Also, make list of afk players.

  for i, v in ipairs (colors) do

    objects = betzones[v].getObjects()

    for j, w in ipairs (objects) do

      if w.getName() == "Dealer" then

        dealer = v

      elseif w.getName() == "suffering" or w.getName() == "Busted" then

        if not objectExistsInList (busted, v) then

          busted[#busted + 1] = v

          bustedbombs[#bustedbombs + 1] = w

        end

      elseif w.getName() == 'AFK' then

        afk[#afk + 1] = v

      end

    end

  end



  -- return nil if dealer button not found

  if not dealer then

    broadcastToColor ('[ff0000]Error: [ffffff]Dealer button not found.', pl, {1, 1, 1})

    return nil

  end



  for i, v in ipairs(bustedbombs) do

    v.destruct()

  end



  local seatedplayers = getSeatedPlayers() -- list of seated players, in some random order



  -- make sure dealer button is in front of a seated player

  for i, v in ipairs (seatedplayers) do

    if v == dealer then

      --print ('Dealer: '..dealer)

      break

    end



    if i == #seatedplayers then

      broadcastToColor('[ff0000]Error:[ffffff] Dealer button not in front of a seated player.', pl, {1, 1, 1})

      return nil

    end

  end





  local playersx = {}



  --sort the seatedplayers into playersx list

  for i, v in ipairs (colors) do

    for j, w in ipairs (seatedplayers) do

      if v == w then

        playersx[#playersx + 1] = w

        break

      end

    end

  end





  --rotate the list so the dealer is the last entry

  while playersx[#playersx] ~= dealer do

    playersx[#playersx + 1] = playersx[1] -- copy first entry to end of table

    table.remove(playersx, 1) -- then remove first entry

  end



  -- remove busted players from the table

  for i, v in ipairs (busted) do

    for j, w in ipairs (playersx) do

      if w == v then

        table.remove(playersx, j)

      end

    end

  end



  -- lastly, remove afk players from the table



  local actionoffset = 0



  for i, v in ipairs(afk) do

    for j, w in ipairs (playersx) do

      if w == v then

        if actionoffset == 0 and j <= 2 then

          actionoffset = actionoffset + 1

        elseif actionoffset == 1 and j == 1 then

          actionoffset = actionoffset + 1

        end

        --print ('Removing afk player: '..playersx[j])

        table.remove(playersx, j)

        if w == dealer then

          dealerafk = true

        end

        break

      end

    end

  end



  for i, v in ipairs (playersx) do

    playerbets[i] = 0

  end



  if options.blindsskipafk then

    actionoffset = 0

  end



  if actionoffset < 2 then

    actionon = playersx[2 - actionoffset]

  else

    actionon = playersx[#playersx]

  end



  -- set action on the dealer in a heads-up match

  if #playersx == 2 and not dealerafk then

    actionon = playersx[1]

  end



  --return the final table

  return playersx



end





--[[ deal hole --]]



function hole (pl)



  players = getOrderedListOfPlayers(pl)



  if not players then

    return 1 -- abort if dealer button is not in front of a seat

  else

    dealing = true

    handinprogress = true

    hideActionText()

    calculatePots()

    startLuaCoroutine(nil, 'holeCoroutine')

  end



end



function holeCoroutine()



  local deckpos = deck.getPosition()

  local cards = 0



  if options.gamemode == 'fivestud' or onecard then

    cards = 1

  elseif options.gamemode == 'texas' or options.gamemode == 'sevenstud' then

    cards = 2

  elseif options.gamemode == 'pineapple' then

    cards = 3

  elseif options.gamemode == 'omaha' then

    cards = 4

  elseif options.gamemode == 'fivedraw' then

    cards = 5

  end



  deck.setPosition({ - 0.05, 1.4, - 1.97}) -- set the deck to the center of the table so dealt cards don't get intercepted by unintended hands

  for i = 1, cards do

    for i, v in ipairs (players) do

      local t = os.clock()

      deck.dealToColor(1, players[i])

      while os.clock() < (t + options.dealdelay1) do

        coroutine.yield(0)

      end

    end

  end



  deck.setPosition(deckpos)



  if onecard then

    onecard = false

    dealing = false

    if not handinprogress then

      players = {}

    end

    return 1

  end



  --[[ This loop exists to delay the call of the function action()

        I was having problems with a player (the dealer) being folded due to the cards not reaching the hand

        before the function was called. --]]

  t = os.clock()

  while os.clock() < (t + 1) do

    coroutine.yield(0)

  end



  holedealt = true

  dealing = false



  action()



  for i, v in ipairs (players) do

    local cards = Player[v].getHandObjects()

    for j, w in ipairs (cards) do

      if w.tag == 'Card' then

        w.setColorTint({1, 1, cardtint})

        cardtint = cardtint - 0.01

      end

    end

  end

  getPlayersHoleCards()



  return 1



end





--[[ deal flop --]]



function flop ()



  dealing = true

  actionon = nil

  resetBets()

  hideActionText()



  if options.chatoptions.stage then

    broadcastToAll('Flop', {0, 1, 1})

  end



  startLuaCoroutine(nil, 'flopCoroutine')



end



function flopCoroutine ()



  local muckpos = muck.getPosition()

  local muckrot = muck.getRotation()



  muckpos.y = muckpos.y + 0.5

  muckrot.x = muckrot.x + 180



  local params = {}



  params.position = muckpos

  params.rotation = muckrot

  deck.takeObject(params)



  for i = 1, 3 do

    local t = os.clock()

    while os.clock () < t + options.dealdelay2 do

      coroutine.yield(0)

    end

    params.position = getCardPosition(i)

    params.rotation = boardobject.getRotation()

    local card = deck.takeObject(params)

    card.setColorTint({1, 1, cardtint})

    cardtint = cardtint - 0.01

  end



  t = os.clock()

  while os.clock() < (t + 1) do

    coroutine.yield(0)

  end



  dealing = false



  action()



  return (1)



end



--[[ deal turn --]]



function turn ()



  dealing = true

  actionon = nil

  resetBets()

  calculatePots()

  hideActionText()



  if options.chatoptions.stage then

    broadcastToAll('Turn', {0, 1, 1})

  end



  startLuaCoroutine(nil, 'turnCoroutine')



end



function turnCoroutine ()



  local muckpos = muck.getPosition()

  local muckrot = muck.getRotation()



  muckpos.y = muckpos.y + 0.5

  muckrot.x = muckrot.x + 180



  local params = {}



  params.position = muckpos

  params.rotation = muckrot

  deck.takeObject(params)



  local t = os.clock()

  while os.clock() < (t + options.dealdelay2) do

    coroutine.yield(0)

  end



  params.position = getCardPosition(4)

  params.rotation = boardobject.getRotation()

  local card = deck.takeObject(params)

  card.setColorTint({1, 1, cardtint})

  cardtint = cardtint - 0.01



  t = os.clock()

  while os.clock() < (t + 1) do

    coroutine.yield(0)

  end



  dealing = false



  action()



  return (1)



end



--[[ deal river --]]



function river ()



  dealing = true

  actionon = nil

  resetBets()

  calculatePots()

  hideActionText()



  if options.chatoptions.stage then

    broadcastToAll('River', {0, 1, 1})

  end



  startLuaCoroutine(nil, 'riverCoroutine')



end



function riverCoroutine ()



  local muckpos = muck.getPosition()

  local muckrot = muck.getRotation()



  muckpos.y = muckpos.y + 0.5

  muckrot.x = muckrot.x + 180



  local params = {}



  params.position = muckpos

  params.rotation = muckrot

  deck.takeObject(params)



  local t = os.clock()

  while os.clock() < (t + options.dealdelay2) do

    coroutine.yield(0)

  end



  params.position = getCardPosition(5)

  params.rotation = boardobject.getRotation()

  local card = deck.takeObject(params)

  card.setColorTint({1, 1, cardtint})

  cardtint = cardtint - 0.01



  t = os.clock()

  while os.clock() < (t + 1) do

    coroutine.yield(0)

  end



  dealing = false



  action()



  return (1)



end



--[[ returns the card position based on the position and rotation of the boardobject model--]]



function getCardPosition(n)

  local p = boardobject.getPosition()

  local r = boardobject.getRotation()

  local s = boardobject.getScale()

  n = 3 - n



  p.x = p.x - ((math.cos(math.rad(r.y)) * 2.75) * n) * s.x

  p.z = p.z + ((math.sin(math.rad(r.y)) * 2.75) * n) * s.z

  p.y = p.y + 0.5



  return p

end

--[[ looks for a deck of 52 cards in the specified scripting zone (I used the white player's bet zone) and makes it the new deck object --]]

function newDeck (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  obj = betzones.White.getObjects()

  for i, v in ipairs (obj) do

    if v.tag == "Deck" then

      if v.getQuantity() <= 52 then

        deck = {}

        deck = getObjectFromGUID(v.getGUID())

        print ("New deck assigned.")

        return 1

      end

    end

  end



  broadcastToColor ("Valid deck not found. Please place a 52-card poker deck inside the white player's bet square try again.", pl, {1, 0.3, 0.3}) -- it only gets to this line if a deck isn't found in the above loop





end





function newSavebag (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  obj = betzones.White.getObjects()

  for i, v in ipairs (obj) do

    if v.tag == "Bag" then

      savebag = {}

      savebag = getObjectFromGUID(v.getGUID())

      print ("New savebag assigned.")

      return 1

    end

  end



  broadcastToColor ("No savebag found. Please put a bag inside the white player's bet square try again.", pl, {1, 0.3, 0.3}) -- it only gets to this line if a deck isn't found in the above loop





end



--[[ reset the deck and variables --]]



function resetGame (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  sidepotcalculated = false



  if deck == nil or deck == null then

    broadcastToColor('No deck is currently assigned. Please assign a new deck and try again.', pl, {1, 0.3, 0.3})

    return 0

  end

  if pottext == nil or pottext == null then

    checkAndRespawnObjects()

  end



  if currentbettext == nil or currentbettext == null then

    checkAndRespawnObjects()

  end



  if actiontext == nil or actiontext == null then

    checkAndRespawnObjects()

  end



  mainpotchips = initializePot()

  afk = {}

  dealing = true

  for i, v in ipairs (colors) do

    for j, w in ipairs (Player[v].getHandObjects()) do

      w.setRotation({180, 0, 0})

      w.setColorTint({1, 1, 1})

    end

    bettext[v].setValue(" ")

    sidepottext[v].setValue(" ")

    if options.displayplayermoney then

      local chips = {}

      money = getChipValues(tablezones[v], chips)

      tablezonetext[v].setValue("$" .. money)

    end

  end





  cardtint = 1

  holedealt = false

  handinprogress = false

  players = {}

  actionon = nil

  currentbet = 0

  pot = 0

  pottext.setValue('Pot: $'.. tostring(pot))

  currentbettext.setValue('Current bet: $'..tostring(currentbet))

  handsshown = {}

  playerbets = {}

  hideActionText()

  holecards = {['White'] = {}, ['Red'] = {}, ['Orange'] = {}, ['Yellow'] = {}, ['Green'] = {}, ['Teal'] = {}, ['Blue'] = {}, ['Purple'] = {}}

  revealedcards = {['White'] = {}, ['Red'] = {}, ['Orange'] = {}, ['Yellow'] = {}, ['Green'] = {}, ['Teal'] = {}, ['Blue'] = {}, ['Purple'] = {}}

  if clock ~= nil and clock ~= null then

    clock.destruct()

  end



  -- destroy Sidepotmarke

  for i, v in ipairs(getAllObjects()) do

    if v.getName() == "Sidepotmarker" then

      v.destruct()

    end

  end

  startLuaCoroutine(nil, 'resetGameCoroutine')



end



function resetMuck(zone)



  if not deck then

    return 1

  end



  local obj = zone.getObjects()

  local deck_pos = deck.getPosition()

  local deck_rot = deck.getRotation()



  deck_pos.y = deck_pos.y + 0.5



  for i, v in ipairs (obj) do

    if v.tag == "Card" or v.tag == "Deck" then

      if v ~= deck then

        v.setColorTint({1, 1, 1})

        v.setPositionSmooth(deck_pos)

        v.setRotation(deck_rot)

        deck_pos.y = deck_pos.y + 0.1

      end

    end

  end



  for i, v in ipairs(colors) do

    for j, w in ipairs (Player[v].getHandObjects()) do

      if w.tag == 'Card' then

        deck.putObject(w)

      end

    end

  end

  zone.destruct()

end



function resetGameCoroutine()



  local params = {}

  params.position = {0, 1, 0}

  params.rotation = {0, 0, 0}

  params.scale = {70, 1, 27}

  params.type = "ScriptingTrigger"

  params.callback = "resetMuck"

  params.params = {zone}



  local zone = spawnObject(params)



  local t = os.clock()





  --[[ Print an error and unassign deck if it doesn't have 52 cards after 3 seconds --]]

  while deck.getQuantity() < 52 do

    if os.clock() > (t + 3) then

      for i, v in ipairs (getSeatedPlayers()) do

        if Player[v].admin then

          broadcastToColor('Error: Deck missing cards. Unassigned current deck. Please assign new deck', v, {1, 0.3, 0.3})

        end

      end

      deck = nil

      dealing = false

      return 1

    end

    coroutine.yield(0)

  end



  --[[ Print an error and unassign deck if it has more than 52 cards --]]

  if deck.getQuantity() > 52 then

    for i, v in ipairs (getSeatedPlayers()) do

      if Player[v].admin then

        broadcastToColor('Error: Too many cards in deck. Unassigned current deck. Please assign new deck.', v, {1, 0.3, 0.3})

      end

    end



    deck = nil

    dealing = false

    return 1

  end



  deck.shuffle()



  t = os.clock()

  while os.clock() < (t + 1) do

    coroutine.yield(0)

  end



  dealing = false



  return (1)



end



--[[ move all chips in bet zones into the main pot --]]



function collectBets(ob, pl)



  --[[ Only host and promoted players can click this button --]]

  if not Player[pl].admin then

    return 1

  end



  sidepotcalculated = false

  --[[ Make sure the potobject exists before running function --]]

  if potobject == nil or potobject == null then

    --print ('The pot object has been lost. Please click the \'Reset Objects\' button on the options panel to reassign.')

    checkAndRespawnObjects()

    --return 1

  end



  printstring = printstring..'collect'



  if clock ~= nil and clock ~= null then

    clock.destruct()

  end



  -- prevents button spamming

  if (os.time() - lastCollectTime) < 2 then

    printToColor("You cant collect bets multiple times within 2 seconds", pl, {1, 1, 0} )

    return 1

  else

    lastCollectTime = os.time()

  end



  if options.collectmethod == 'move' then

    startLuaCoroutine(nil, 'moveBetsToPot')

  elseif options.collectmethod == 'convert' then

    startLuaCoroutine(nil, 'convertBetsToPot')

  elseif options.collectmethod == 'hybrid' then

    if pot <= options.hybridthreshold then

      startLuaCoroutine(nil, 'moveBetsToPot')

    else

      startLuaCoroutine(nil, 'convertBetsToPot')

    end

  end

end



function moveBetsToPot()



  local objects = {} -- table of all objects

  local stacks = {}

  local chips = {}

  local h = {}

  bets = getChipValues(potzones[1], chips)

  for i, v in pairs (betzones) do

    bets = bets + getChipValues(v, chips)

  end



  for i, v in ipairs (chips) do

    v.setColorTint({1, 1, 1})

  end



  moveChips(chips, potobject.getPosition(), potobject.getRotation())

  for i = 1, 5 do

    coroutine.yield(0)

  end

  calculatePots()

  return 1

end





function convertBetsToPot()



  if convertfailcount > convertfailcountlimit then

    convertfailcount = 0

    startLuaCoroutine (nil, 'moveBetsToPot')

    return 1

  end



  --[[ Get chip values in bet zones --]]



  local objects = {}

  local chips1 = {}

  local positions1 = {}

  local rotations1 = {}



  objects = {}

  objects = potzones[1].getObjects()

  for j, w in ipairs (objects) do

    if w.tag == 'Chip' then

      if w.getValue() or currencyToNumber(w.getName()) ~= nil then

        chips1[#chips1 + 1] = w

      end

    end

  end





  for i, v in pairs (betzones) do

    objects = {}

    objects = v.getObjects()

    for j, w in ipairs (objects) do

      if w.tag == 'Chip' then

        if w.getValue() or currencyToNumber(w.getName()) ~= nil then

          chips1[#chips1 + 1] = w

        end

      end

    end

  end



  for i, v in ipairs (chips1) do

    positions1[#positions1 + 1] = v.getPosition()

    rotations1[#rotations1 + 1] = v.getRotation()

  end



  for i = 1, 2 do

    coroutine.yield(0)

  end



  objects = {}

  local chips2 = {}

  local positions2 = {}

  local rotations2 = {}



  objects = {}

  objects = potzones[1].getObjects()

  for j, w in ipairs (objects) do

    if w.tag == 'Chip' then

      if w.getValue() or currencyToNumber(w.getName()) ~= nil then

        chips2[#chips2 + 1] = w

      end

    end

  end





  for i, v in pairs (betzones) do

    objects = {}

    objects = v.getObjects()

    for j, w in ipairs (objects) do

      if w.tag == 'Chip' then

        if w.getValue() or currencyToNumber(w.getName()) ~= nil then

          chips2[#chips2 + 1] = w

        end

      end

    end

  end



  if #chips2 ~= #chips1 then

    convertfailcount = convertfailcount + 1

    startLuaCoroutine(nil, 'convertBetsToPot')

    return 1

  end



  for i, v in ipairs (chips2) do

    positions2[#positions2 + 1] = v.getPosition()

    rotations2[#rotations2 + 1] = v.getRotation()

  end



  --[[ Check chip positions --]]

  for i, v in ipairs(positions1) do

    if v.x ~= positions2[i].x or v.y ~= positions2[i].y or v.z ~= positions2[i].z then

      convertfailcount = convertfailcount + 1

      startLuaCoroutine(nil, 'convertBetsToPot')

      return 1

    end

  end



  --[[ Check chip rotations --]]

  for i, v in pairs(rotations1) do

    if v.x ~= rotations2[i].x or v.y ~= rotations2[i].y or v.z ~= rotations2[i].z then

      convertfailcount = convertfailcount + 1

      startLuaCoroutine(nil, 'convertBetsToPot')

      return 1

    end

  end



  local chips = {}

  local bets = 0



  for i, v in pairs (betzones) do

    bets = bets + getChipValues(v, chips)

  end



  bets = bets + getChipValues(potzones[1], chips)



  --[[ Spawn new chips in pot --]]





  --[[ Destroy old chips --]]

  for i, v in ipairs (chips) do

    v.destruct()

  end



  --[[ Wait five frames to allow chips to spawn destruct themself --]]

  for i = 1, 10 do

    coroutine.yield(0)

  end





  spawnChips(bets, potobject.getPosition(), potobject.getRotation(), options.convertstackheight)





  --[[ Wait five frames to allow chips to spawn before updating pot values --]]

  for i = 1, 5 do

    coroutine.yield(0)

  end



  calculatePots()



  convertfailcount = 0



  return 1

end



function objectExistsInList(list, object)

  if list ~= nil then

    for i, v in ipairs(list) do

      if v == object then

        return true

      end

    end

    return false

  end

  return false

end



function action (ob, pl)



  if pl then

    if not Player[pl].admin and pl ~= actionon then

      return 1

    end

  end



  if sidepotcalculated then

    return 1

  end



  if actiontext == nil or actiontext == null then

    checkAndRespawnObjects()

    --print ('The action text has been deleted. Please click the \'Reset Objects\' button on the options panel to respawn.')

    --return 0

  end



  calculatePots()



  -- abort function if action toggled off

  if not options.actiontoggle then

    return 1

  end



  --[[ Check action player's bet to make sure it's greater than or equal to current bet --]]

  if actionon and actionon == pl then

    if getChipValues(betzones[actionon], {}) < currentbet and getChipValues(tablezones[actionon], {}) > 0 and Player[actionon].getHandObjects()[1] then

      broadcastToColor('You must match or raise the current bet of $'..currentbet, actionon, {1, 1, 1})

      if not Player[pl].admin then

        return 1

      end

    end

  end



  --[[ Destroy the clock if it exists --]]



  if clock ~= nil and clock ~= null then

    clock.destruct()

    clock = null

  end



  --[[ abort function and hide text if no players --]]



  if #players == 0 then

    hideActionText()

    return 1

  end



  local cb = currentbet



  --[[ Remove player from list if they don't have cards --]]



  if actionon then

    if not Player[actionon].getHandObjects()[1] then

      for i, v in ipairs (players) do

        if v == actionon then

          table.remove(players, i)

          if i > 1 then

            actionon = players[i - 1]

          else

            actionon = players[#players]

          end

          break

        end

      end

    end



    --[[ or if they have no money (all in) --]]

    if actionon then

      if getChipValues(tablezones[actionon], {}) == 0 then

        printstring = printstring..'allin'..actionon

        if getChipValues(betzones[actionon], {}) > cb then

          cb = getChipValues(betzones[actionon], {})

        end

        for i, v in ipairs (players) do

          if v == actionon then

            table.remove(players, i)

            if i > 1 then

              actionon = players[i - 1]

            else

              actionon = players[#players]

            end

            break

          end

        end

      end

      if not actionon then

        hideActionText()

        return 1

      end

    end

    if #players == 0 then

      return 1

    end

  end



  -- set actionon to next player

  if not actionon then

    actionon = players[1]

  else

    for i, v in ipairs (players) do

      if actionon == v then

        if players[i + 1] then

          actionon = players[i + 1]

        else

          actionon = players[1]

        end

        break

      end

    end

  end



  -- check new player's hand for cards. remove from list if none and run function again.



  if actionon then

    if not Player[actionon].getHandObjects()[1] then

      for i, v in ipairs (players) do

        if v == actionon then

          table.remove(players, i)

          if i > 1 then

            actionon = players[i - 1]

          else

            actionon = players[#players]

          end

          action()

          return 1

        end

      end

    end

  end



  --[[ Hide text and abort if there is one player and no bet to call --]]



  if #players == 1 and getChipValues(betzones[actionon], {}) >= cb then

    hideActionText()

    return 1

  end



  printstring = printstring..'action'



  -- move actiontext to front of player



  local playerhand = getPlayerHandPositionAndRotation(actionon)

  actiontext.setValue('Action') -- set action text to say "Action" in case it gets changed (sometimes it changes to "Type here" for some reason)

  actiontext.TextTool.setFontColor(fontcolors[actionon]) -- change color of "Action" to player's color



  actiontext.setPosition({playerhand['pos_x'] + playerhand['trigger_forward_x'] * 10, 1.33, playerhand['pos_z'] + playerhand['trigger_forward_z'] * 10})

  actiontext.setRotation({90, playerhand['rot_y'], 0})



  -- move action button to player if playerclickaction is toggled

  if options.playerclickaction then

    actionbutton.setPosition({playerhand['pos_x'] + playerhand['trigger_forward_x'] * 12, 1.55, playerhand['pos_z'] + playerhand['trigger_forward_z'] * 12})

    actionbutton.setRotation({0, playerhand['rot_y'] + 180, 0})

  end



  -- spawn clock if autoclock

  if options.autoclock then

    spawnClock()

  end

end



function actionToggle(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  if options.actiontoggle then

    options.actiontoggle = false

    hideActionText()

    print ('Action text toggled off. The button can still be used to update pot and current bet values.')

  else

    options.actiontoggle = true

    print ('Action text toggled on. It will reappear next time action is passed.')

  end



  optionsHost()

end



function hideActionText()

  actiontext.setPosition({0, - 2, 0})

end



function calculatePots()

  if pottext == nil or pottext == null then

    checkAndRespawnObjects()

    return 0

  end

  if sidepotcalculated then

    return 0

  end

  if currentbettext == nil or currentbettext == null then

    checkAndRespawnObjects()

    return 0

  end

  startLuaCoroutine(nil, 'calculatePotsCoroutine')

end



function calculatePotsCoroutine ()



  local p = potobject.getPosition()

  local r = potobject.getRotation()



  p.y = p.y + 10



  potzones[1].setPosition (p)

  potzones[1].setRotation (r)

  potzones[1].setScale({9.5, 20, 6})



  for i = 1, 3 do

    coroutine.yield(0)

  end



  local bets = 0

  local mainpot = 0

  local prevpot = pot

  local prevbet = currentbet

  currentbet = 0

  local chips = {}

  local better = ''

  for i, v in ipairs (colors) do

    playerbets[i] = getChipValues(betzones[v], chips)



    if playerbets[i] > currentbet then

      currentbet = playerbets[i]

      better = v

    end

    if options.displayplayerbet then

      if playerbets[i] > 0 then

        bettext[v].setValue('$' .. tostring(playerbets[i]))

      else

        bettext[v].setValue(' ')

      end

    else

      bettext[v].setValue(' ')

    end

    sidepottext[v].setValue(" ")

    if options.displayplayermoney then

      money = getChipValues(tablezones[v], chips)

      tablezonetext[v].setValue("$" .. money)

      bets = bets + playerbets[i]

    end

  end



  for i, v in ipairs (potzones) do

    mainpot = mainpot + getChipValues(v, chips)

  end

  --mainpot = getChipValues(potzones[1], chips)



  pot = bets + mainpot



  -- print the pot value in chat

  if pot > prevpot then

    printstring = printstring..'pot'

  end



  -- print the current bet in chat

  if currentbet > prevbet then



    if prevbet == 0 then

      printstring = printstring..'bet'..better

    else

      printstring = printstring..'raise'..better

    end



  end



  -- display pot value on 3dtexts



  pottext.setValue('Pot: $'..tostring(pot))

  currentbettext.setValue('Current bet: $'..tostring(currentbet))



  printMessages()



  return 1



end



function getChipValues(zone, chips)



  local objects = zone.getObjects()

  local x = 0



  for j, w in ipairs (objects) do

    if w.tag == 'Chip' and not objectExistsInList(chips, w) then

      if w.getQuantity() < 0 then

        if w.getValue() then

          x = x + w.getValue()

          chips[#chips + 1] = w

        elseif currencyToNumber(w.getName()) then

          x = x + currencyToNumber(w.getName())

          chips[#chips + 1] = w

        end

      else

        if w.getValue() then

          x = x + (w.getValue() * w.getQuantity())

          chips[#chips + 1] = w

        elseif currencyToNumber(w.getName()) then

          x = x + (currencyToNumber(w.getName()) * w.getQuantity())

          chips[#chips + 1] = w

        end

      end

    end

  end



  return x



end



function resetBets()

  playerbets = {}

  for i, v in ipairs (players) do

    playerbets[i] = 0

  end

  currentbet = 0

end



--[[ Spawn panel with host options buttons --]]

function spawnOptionsPanel(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  if optionspanel then

    destroyOptionsPanel()

    return 1

  end



  local params = {}

  params.type = 'Custom_Model'

  params.callback = 'optionsMain'

  params.position = { - 4.5, 4.45, - 25}

  params.scale = {2, 1, 2}

  params.rotation = {0, 180, 0}



  optionspanel = spawnObject(params)



  local custom = {}

  custom.mesh = 'http://pastebin.com/raw/avCFwn0Y'

  custom.collider = 'http://pastebin.com/raw/avCFwn0Y'

  custom.specular_intensity = 0

  custom.type = 4



  optionspanel.setCustomObject(custom)



  optionspanel.lock()

  optionspanel.interactable = false

  optionspanel.setColorTint({0, 0, 0})



  startLuaCoroutine(nil, 'addSelfDestruct')



end



--[[ Add buttons to panel --]]



function optionsMain(ob, pl)



  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  optionspanel.clearButtons()



  if colorball ~= nil and colorball ~= null then

    colorball.destruct()

  end



  local button = {}



  button.width = 150

  button.height = 150

  button.label = '☒'

  button.font_size = 125

  button.click_function = 'destroyOptionsPanel'

  button.position = {1.75, 0.05, - 1.8}

  optionspanel.createButton(button)



  button.width = 1000

  button.height = 200

  button.label = 'Host Settings'

  button.click_function = 'optionsHost'

  button.font_size = 150

  button.position = {0, 0.05, - 1.5}



  optionspanel.createButton(button)



  button.width = 1000

  button.height = 200

  button.label = 'Chat Settings'

  button.click_function = 'optionsChat'

  button.font_size = 150

  button.position = {0, 0.05, - 1}

  optionspanel.createButton(button)



  button.width = 1000

  button.height = 200

  button.label = 'Themes'

  button.click_function = 'optionsThemes'

  button.font_size = 150

  button.position = {0, 0.05, - 0.5}

  optionspanel.createButton(button)



  button.width = 1000

  button.height = 200

  button.label = 'Currencies'

  button.click_function = 'optionsCurrencies'

  button.font_size = 150

  button.position = {0, 0.05, 0}

  optionspanel.createButton(button)







  button.label = 'Deal one card'

  button.width = 800

  button.font_size = 100

  button.position = { - 1, 0.05, 0.5}

  button.click_function = 'dealOneCard'

  optionspanel.createButton(button)



  button.label = 'Clock'

  button.width = 800

  button.font_size = 150

  button.position = {1, 0.05, 0.5}

  button.click_function = 'spawnClock'

  optionspanel.createButton(button)



  button.label = '«'

  button.width = 100

  button.height = 100

  button.font_size = 100

  button.click_function = 'decreaseClockTime5'

  button.position = {0.4, 0.05, 0.85}

  optionspanel.createButton(button)



  button.label = '‹'

  button.click_function = 'decreaseClockTime1'

  button.position = {0.6, 0.05, 0.85}

  optionspanel.createButton(button)



  button.label = tostring(options.clocktime)

  button.width = 300

  button.click_function = 'doNothing'

  button.position = {1, 0.05, 0.85}

  optionspanel.createButton(button)



  button.label = '›'

  button.width = 100

  button.click_function = 'increaseClockTime1'

  button.position = {1.4, 0.05, 0.85}

  optionspanel.createButton(button)



  button.label = '»'

  button.click_function = 'increaseClockTime5'

  button.position = {1.6, 0.05, 0.85}

  optionspanel.createButton(button)



  button.label = 'Fold Player'

  button.width = 800

  button.height = 200

  button.font_size = 150

  button.position = {1, 0.05, 1.5}

  button.click_function = 'foldPlayer'

  optionspanel.createButton(button)



  button.label = 'Set player Afk'

  button.width = 800

  button.font_size = 100

  button.position = { - 1, 0.05, 1}

  button.click_function = 'setPlayerAfk'

  optionspanel.createButton(button)



  button.label = 'Reset Objects'

  button.font_size = 100

  button.click_function = 'checkAndRespawnObjects'

  button.position = { - 1.0, 0.05, 1.5}

  optionspanel.createButton(button)











end



function dealOneCard(ob, pl)

  if pl then

    if not Player[pl].admin and pl ~= actionon then

      return 1

    end

  end



  if deck == nil or deck == null then

    for i, v in ipairs (getSeatedPlayers()) do

      if Player[v].admin then

        broadcastToColor('No deck assigned. Please assign a deck with the \'New Deck\' button.', v, {1, 0.3, 0.3})

      end

    end

    return 1

  end



  if not dealing then

    if not handinprogress then

      players = getOrderedListOfPlayers()

    end



    if not players then

      return 1

    end



    onecard = true

    dealing = true

    startLuaCoroutine(nil, 'holeCoroutine')

  end

end



--[[ If the rewind button is used while the options menu is open, the black square will remain and be non-interactable. This script is added to it so it self-destructs in that event. --]]

function addSelfDestruct()

  for i = 1, 5 do

    coroutine.yield(0)

  end

  if optionspanel ~= nil and optionspanel ~= null then

    optionspanel.setLuaScript('function onload() self.destruct() end')

  end

  return 1

end



function optionsHost(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  optionspanel.clearButtons()



  local button = {}

  local s = ''



  button.width = 150

  button.height = 150

  button.label = '☒'

  button.font_size = 125

  button.click_function = 'destroyOptionsPanel'

  button.position = {1.75, 0.05, - 1.8}

  optionspanel.createButton(button)



  button.width = 150

  button.height = 150

  button.label = '◄'

  button.font_size = 125

  button.click_function = 'optionsMain'

  button.position = { - 1.75, 0.05, - 1.8}

  optionspanel.createButton(button)



  if options.actiontoggle then

    button.label = '☑ Action'

  else

    button.label = '□ Action'

  end

  button.font_size = 75

  button.width = 350

  button.height = 100

  button.click_function = 'actionToggle'

  button.position = { - 1.5, 0.05, - 1.5}

  optionspanel.createButton(button)



  if options.actiontoggle then

    if options.playerclickaction then

      button.label = '+Players'

    else

      button.label = '+Host'

    end

    button.width = 350

    button.font_size = 75

    button.click_function = 'togglePlayerClickAction'

    button.position = { - 1.5, 0.05, - 1.25}

    optionspanel.createButton(button)



    if options.autoclock then

      button.label = '☑ Autoclock'

    else

      button.label = '□ Autoclock'

    end

    button.position = { - 1.35, 0.05, - 1.0}

    button.width = 500

    button.click_function = 'toggleAutoclock'

    optionspanel.createButton(button)



    if options.autoclock then

      button.label = '‹'

      button.width = 100

      button.click_function = 'decreaseAutoclockTime'

      button.position = { - 1.7, 0.05, - 0.75}

      optionspanel.createButton(button)



      button.label = tostring(options.autoclocktime)

      button.width = 200

      button.position = { - 1.35, 0.05, - 0.75}

      button.click_function = 'doNothing'

      optionspanel.createButton(button)



      button.label = '›'

      button.width = 100

      button.click_function = 'increaseAutoclockTime'

      button.position = { - 1.0, 0.05, - 0.75}

      optionspanel.createButton(button)



      if options.clockpausebutton then

        button.label = '☑ Pause button'

      else

        button.label = '□　Pause button'

      end

      button.width = 600

      button.position = { - 1.35, 0.05, - 0.5}

      button.click_function = 'toggleAutoclockPauseButton'

      optionspanel.createButton(button)

    end



    if options.autofold then

      button.label = '☑ Autofold'

    else

      button.label = '□ Autofold'

    end

    button.width = 500

    button.position = { - 0.35, 0.05, - 1.0}

    button.click_function = 'toggleAutofold'

    optionspanel.createButton(button)

  end



  if options.collectmethod == 'move' then

    button.label = 'Collect method: Move'

    button.width = 800

  elseif options.collectmethod == 'convert' then

    button.label = 'Collect method: Convert'

    button.width = 850

  elseif options.collectmethod == 'hybrid' then

    button.label = 'Collect method: Hybrid:'

    button.width = 850

  else

    button.label = options.collectmethod

    button.width = 800

  end

  button.click_function = 'changeCollectMethod'

  button.position = { - 1, 0.05, 0}

  optionspanel.createButton(button)



  if options.collectmethod == 'hybrid' then

    button.label = '«'

    button.width = 100

    button.click_function = 'decreaseHybridThreshold1000'

    button.position = {0.0, 0.05, 0}

    optionspanel.createButton(button)



    button.label = '‹'

    button.click_function = 'decreaseHybridThreshold100'

    button.position = {0.2, 0.05, 0}

    optionspanel.createButton(button)



    button.label = '$'..tostring(options.hybridthreshold)

    button.width = 350

    button.click_function = 'doNothing'

    button.position = {0.65, 0.05, 0}

    optionspanel.createButton(button)



    button.label = '›'

    button.width = 100

    button.click_function = 'increaseHybridThreshold100'

    button.position = {1.1, 0.05, 0}

    optionspanel.createButton(button)



    button.label = '»'

    button.click_function = 'increaseHybridThreshold1000'

    button.position = {1.3, 0.05, 0}

    optionspanel.createButton(button)

  end



  if options.collectmethod == 'convert' or options.collectmethod == 'hybrid' then



    button.label = 'Minimum Stack Height:'

    button.width = 850

    button.click_function = 'doNothing'

    button.position = { - 1, 0.05, 0.25}

    optionspanel.createButton(button)



    button.width = 100

    button.label = '‹'

    button.click_function = 'decreaseConvertStackHeight1'

    button.position = {0.2, 0.05, 0.25}

    optionspanel.createButton(button)



    button.label = tostring(options.convertstackheight)

    button.width = 350

    button.click_function = 'doNothing'

    button.position = {0.65, 0.05, 0.25}

    optionspanel.createButton(button)



    button.label = '›'

    button.width = 100

    button.click_function = 'increaseConvertStackHeight1'

    button.position = {1.1, 0.05, 0.25}

    optionspanel.createButton(button)

  end





  if options.blindsskipafk then

    button.label = '☑ Blinds Skip AFK'

  else

    button.label = '□ Blinds Skip AFK'

  end

  button.width = 650

  button.click_function = 'toggleBlindsSkipAFK'

  button.position = { - 0.375, 0.05, - 1.5}

  optionspanel.createButton(button)



  if options.gamemode == 'omaha' then

    s = '►'

  else

    s = ''

  end

  button.label = s..'Omaha Hold\'em'

  button.width = 650

  button.click_function = 'setGameModeOmaha'

  button.position = {1.0, 0.05, - 1.0}

  optionspanel.createButton(button)



  if options.gamemode == 'pineapple' then

    s = '►'

  else

    s = ''

  end

  button.label = s..'Pineapple'

  button.width = 700

  button.click_function = 'setGameModePineapple'

  button.position = {1.0, 0.05, - 1.25}

  optionspanel.createButton(button)



  if options.gamemode == 'texas' then

    s = '►'

  else

    s = ''

  end

  button.label = s..'Texas Hold\'em'

  button.width = 600

  button.click_function = 'setGameModeTexas'

  button.position = {1.0, 0.05, - 1.5}

  optionspanel.createButton(button)



  if options.displayplayerbet then

    button.label = '☑ Display Player Bets'

  else

    button.label = '□ Display Player Bet'

  end

  button.width = 1000

  button.click_function = 'toggleDisplayPlayerBet'

  button.position = { - 1, 0.05, 0.6}

  optionspanel.createButton(button)



  if options.displayplayermoney then

    button.label = '☑ Display Player Money'

  else

    button.label = '□ Display Player Money'

  end

  button.width = 1000

  button.click_function = 'toggleDisplayPlayerMoney'

  button.position = { - 1, 0.05, 0.8}

  optionspanel.createButton(button)



  if options.changemachine then

    button.label = '☑ change Machine'

  else

    button.label = '□ change Machine'

  end

  button.width = 1000

  button.click_function = 'togglechangeMachine'

  button.position = { - 1, 0.05, 1}

  optionspanel.createButton(button)





  if options.playerbuttons.sortchips then

    button.label = '☑ Display Sort Chips Button'

  else

    button.label = '□ Display Sort Chips Button'

  end

  button.width = 1000

  button.click_function = 'toggleDisplaySortChips'

  button.position = {1, 0.05, 0.6}

  optionspanel.createButton(button)





  if options.playerbuttons.convert then

    button.label = '☑ Display Convert Button'

  else

    button.label = '□ Display Convert Button'

  end

  button.width = 1000

  button.click_function = 'toggleDisplayConvert'

  button.position = {1, 0.05, 0.8}

  optionspanel.createButton(button)



  if options.playerbuttons.allin then

    button.label = '☑ Display AllIn Button'

  else

    button.label = '□ Display AllIn Button'

  end

  button.width = 1000

  button.click_function = 'toggleDisplayAllIn'

  button.position = {1, 0.05, 1}

  optionspanel.createButton(button)



  if options.playerbuttons.afk then

    button.label = '☑ Display AFK Button'

  else

    button.label = '□ Display AFK Button'

  end

  button.width = 1000

  button.click_function = 'toggleDisplayAFK'

  button.position = {1, 0.05, 1.2}

  optionspanel.createButton(button)





  if options.playerbuttons.loadsavebag then

    button.label = '☑ Display Load Save Button'

  else

    button.label = '□ Display Load Save Button'

  end

  button.width = 1000

  button.click_function = 'toggleLoadSaves'

  button.position = {1, 0.05, 1.4}

  optionspanel.createButton(button)



end







function optionsChat(ob, pl)



  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  optionspanel.clearButtons()



  local button = {}



  button.width = 150

  button.height = 150

  button.label = '☒'

  button.font_size = 125

  button.click_function = 'destroyOptionsPanel'

  button.position = {1.75, 0.05, - 1.8}

  optionspanel.createButton(button)



  button.width = 150

  button.height = 150

  button.label = '◄'

  button.font_size = 125

  button.click_function = 'optionsMain'

  button.position = { - 1.75, 0.05, - 1.8}

  optionspanel.createButton(button)



  button.width = 650

  button.height = 150

  button.font_size = 75

  if options.chatoptions.actionmessage then

    button.label = '☑ Action message'

  else

    button.label = '□ Action message'

  end

  button.click_function = 'toggleActionMessage'

  button.position = { - 1.0, 0.05, - 1.5}

  optionspanel.createButton(button)



  button.width = 700

  button.height = 150

  button.font_size = 75

  if options.chatoptions.actionbroadcast then

    button.label = '☑ Action broadcast'

  else

    button.label = '□ Action broadcast'

  end

  button.click_function = 'toggleActionBroadcast'

  button.position = { - 1.0, 0.05, - 1.25}

  optionspanel.createButton(button)



  button.width = 600

  button.height = 150

  button.font_size = 75

  if options.chatoptions.currentbetmessage then

    button.label = '☑ Current bet'

  else

    button.label = '□ Current bet'

  end

  button.click_function = 'toggleCurrentBetMessage'

  button.position = {1.0, 0.05, - 1.5}

  optionspanel.createButton(button)



  button.width = 600

  button.height = 150

  button.font_size = 75

  if options.chatoptions.better then

    button.label = '☑ └Better/raiser'

  else

    button.label = '□ └Better/raiser'

  end

  button.click_function = 'toggleBetter'

  button.position = {1.0, 0.05, - 1.25}

  if options.chatoptions.currentbetmessage then

    optionspanel.createButton(button)

  end



  button.width = 700

  button.height = 150

  button.font_size = 75

  if options.chatoptions.allinbroadcast then

    button.label = '☑ All-in broadcast'

  else

    button.label = '□ All-in broadcast'

  end

  button.click_function = 'toggleAllinBroadcast'

  button.position = {1.0, 0.05, - 1.0}

  optionspanel.createButton(button)



  button.height = 150

  button.font_size = 75

  if options.chatoptions.potmessage == 0 then

    button.width = 700

    button.label = 'Pot message: Off'

  elseif options.chatoptions.potmessage == 1 then

    button.width = 1000

    button.label = 'Pot message: On collect only'

  elseif options.chatoptions.potmessage == 2 then

    button.width = 900

    button.label = 'Pot message: On change'

  end

  button.click_function = 'togglePotMessage'

  button.position = {1.0, 0.05, - 0.75}

  optionspanel.createButton(button)



  button.width = 850

  button.height = 150

  button.font_size = 75

  if options.chatoptions.stage then

    button.label = '☑ Game stage broadcast'

  else

    button.label = '□ Game stage broadcast'

  end

  button.click_function = 'toggleStageBroadcast'

  button.position = { - 1.0, 0.05, - 1.0}

  optionspanel.createButton(button)



end



function optionsThemes(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  optionspanel.clearButtons()



  local button = {}



  button.width = 150

  button.height = 150

  button.label = '☒'

  button.font_size = 125

  button.click_function = 'destroyOptionsPanel'

  button.position = {1.75, 0.05, - 1.8}

  optionspanel.createButton(button)



  button.width = 150

  button.height = 150

  button.label = '◄'

  button.font_size = 125

  button.click_function = 'optionsMain'

  button.position = { - 1.75, 0.05, - 1.8}

  optionspanel.createButton(button)



  button.label = 'Set Font Color'

  button.width = 600

  button.font_size = 75

  button.click_function = 'changeFontColor'

  button.position = { - 0.75, 0.05, - 1.75}

  optionspanel.createButton(button)



  button.label = 'Set Overlay Color'

  button.width = 600

  button.click_function = 'changeTableColor'

  button.position = {0.75, 0.05, - 1.75}

  optionspanel.createButton(button)



  button.label = 'Darken Overlay'

  button.width = 600

  button.click_function = 'darkenOverlay'

  button.position = { - 0.75, 0.05, - 1.5}

  optionspanel.createButton(button)



  button.label = 'Lighten Overlay'

  button.width = 600

  button.click_function = 'lightenOverlay'

  button.position = {0.75, 0.05, - 1.5}

  optionspanel.createButton(button)







  --[[ spawn theme buttons --]]

  for i, v in ipairs (themes) do

    local s = ''

    if i == themeindex then

      s = '►'

    end

    button.width = (((string.len(themes[i].label) + string.len(s)) * 40) + 0 )

    button.height = 100

    button.font_size = 65

    button.label = themes[i].label..s

    button.click_function = 'setTheme'..tostring(i)

    button.position = { - 1.75, 0.05, (-1 + ((i - 1) * 0.25))}

    optionspanel.createButton(button)

  end



  --[[ spawn subtheme buttons --]]

  for i, v in ipairs (themes[themeindex]) do

    local s = ''

    if i == subthemeindex then

      s = '►'

    end

    button.width = (((string.len(themes[themeindex][i].label) + string.len(s)) * 40) + 0)

    button.height = 100

    button.label = themes[themeindex][i].label..s

    button.click_function = 'setSubtheme'..tostring(i)

    button.position = { - 0.75, 0.05, (-1 + ((i - 1) * 0.25))}

    optionspanel.createButton(button)

  end



  --[[ spawn diffuse buttons --]]

  for i, v in ipairs (themes[themeindex][subthemeindex]) do

    button.width = ((string.len(themes[themeindex][subthemeindex][i].label) * 35) + 0)

    button.height = 100

    button.label = themes[themeindex][subthemeindex][i].label

    button.click_function = 'overlay'..tostring(i)

    button.position = {1, 0.05, (-1 + ((i - 1) * 0.25))}

    optionspanel.createButton(button)

  end



  if colorball == nil or colorball == null then

    local params = {}

    local p = optionspanel.getPosition()

    params.position = {p.x, p.y, p.z + 3.5}

    params.type = 'go_game_piece_white'

    params.scale = {0.5, 0.5, 0.5}



    colorball = spawnObject(params)

    local color = pottext.TextTool.getFontColor()

    colorball.lock()

    colorball.setColorTint(color)

    colorball.setDescription('Change my color tint, then click \'Font Color\' button to change color of text fonts.')

  end



end



function toggleDisplayConvert(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.playerbuttons.convert = not options.playerbuttons.convert

  createPlayerButtons()

  optionsHost()

end



function toggleDisplaySortChips(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.playerbuttons.sortchips = not options.playerbuttons.sortchips

  createPlayerButtons()

  optionsHost()

end



function toggleDisplayAllIn(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.playerbuttons.allin = not options.playerbuttons.allin

  createPlayerButtons()

  optionsHost()

end



function toggleDisplayAFK(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.playerbuttons.afk = not options.playerbuttons.afk

  createPlayerButtons()

  optionsHost()

end



function toggleDisplayPlayerBet(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.displayplayerbet = not options.displayplayerbet

  calculatePots()

  optionsHost()

end



function toggleLoadSaves(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.playerbuttons.loadsavebag = not options.playerbuttons.loadsavebag

  createPlayerButtons()

  optionsHost()

end



function togglechangeMachine(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.changemachine = not options.changemachine



  for i, v in ipairs(getAllObjects()) do

    if v.getName() == 'Back Table' then

      v.clearButtons()

      if options.changemachine then

        local offsetx = 2 / #currencies

        local button = {}



        if #currencies <= 10 then

          offsetx = 1.65 / (#currencies - 2)

        else

          offsetx = 1.65 / 8

        end

        local offsety = 2 / #currencies

        button.font_size = 150

        button.width = 450

        button.height = 250

        button.scale = {1 / 5, 1 / 5, 1 / 7.5}

        button.position = {0.83, - 0.1, - 0.9}

        button.rotation = {180, 0, 0}



        for j, w in ipairs(currencies) do

          if w.value ~= -1 then

            button.label = w.label

            button.click_function = 'changeMachineButton' .. j

            v.createButton(button)

            button.position[1] = button.position[1] - offsetx

          end

          if j == 9 then

            if #currencies - 11 > 0 then

              offsetx = 1.65 / (#currencies - 11)

              button.position = {0.83, - 0.1, - 0.8} -- spawn 1 button in the center

            else

              button.position = {0, - 0.1, - 0.8} -- spawn 1 button in the center

            end

          end

        end

      end

    end

  end





  optionsHost()

end



function toggleDisplayPlayerMoney(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.displayplayermoney = not options.displayplayermoney



  if options.displayplayermoney then

    for i, v in ipairs (colors) do

      money = getChipValues(tablezones[v], chips)

      tablezonetext[v].setValue("$" .. money)



    end

  else

    for i, v in ipairs (colors) do

      tablezonetext[v].setValue(" ")

    end

  end

  optionsHost()

end







function optionsCurrencies(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  optionspanel.clearButtons()



  local button = {}



  button.width = 150

  button.height = 150

  button.label = '☒'

  button.font_size = 125

  button.click_function = 'destroyOptionsPanel'

  button.position = {1.75, 0.05, - 1.8}

  optionspanel.createButton(button)



  button.width = 150

  button.height = 150

  button.label = '◄'

  button.font_size = 125

  button.click_function = 'optionsMain'

  button.position = { - 1.75, 0.05, - 1.8}

  optionspanel.createButton(button)



  --[[ spawn currencies buttons --]]



  button.width = 500

  button.height = 100

  button.font_size = 100

  button.label = "Currency"

  button.click_function = 'doNothing'

  button.position = { - 1.25, 0.05, - 1.55 }

  optionspanel.createButton(button)



  button.width = 500

  button.height = 100

  button.font_size = 100

  button.label = "Layout"

  button.click_function = 'doNothing'

  button.position = {1, 0.05, - 1.55 }

  optionspanel.createButton(button)





  button.position = { - 1.25, 0.05, - 1.25 }

  local c = 0

  for i, v in pairs (currenciesSelectionStacklayout ) do

    c = c + 1

    local s = ''

    if i == options.currencies then

      s = '►'

    end

    button.width = (((string.len(i) + string.len(s)) * 30) + 40 )

    button.height = 100

    button.font_size = 65

    button.label = i..s

    button.click_function = 'changeCurrencies' .. c

    button.position[3] = button.position[3] + 0.25

    optionspanel.createButton(button)

    if i == options.currencies then

      for j, w in ipairs (v) do

        local s = ''

        if w == options.stacklayout then

          s = '►'

        end

        local button2 = {}

        button2.width = (((string.len(w) + string.len(s)) * 30) + 40)

        button2.font_size = 65

        button2.height = 100

        button2.label = w..s

        button2.click_function = 'setStacklayout' .. j

        button2.position = {1, 0.05, (-1 + ((j - 1) * 0.25))}

        optionspanel.createButton(button2)

      end

    end

  end

end







function setStacklayout1(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.stacklayout = currenciesSelectionStacklayout[options.currencies][1]

  optionsCurrencies()

end



function setStacklayout2(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.stacklayout = currenciesSelectionStacklayout[options.currencies][2]

  optionsCurrencies()

end



function setStacklayout3(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.stacklayout = currenciesSelectionStacklayout[options.currencies][3]

  optionsCurrencies()

end



function setStacklayout4(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.stacklayout = currenciesSelectionStacklayout[options.currencies][4]

  optionsCurrencies()

end

function setStacklayout5(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.stacklayout = currenciesSelectionStacklayout[options.currencies][5]

  optionsCurrencies()

end

function setStacklayout6(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.stacklayout = currenciesSelectionStacklayout[options.currencies][6]

  optionsCurrencies()

end

function setStacklayout7(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.stacklayout = currenciesSelectionStacklayout[options.currencies][7]

  optionsCurrencies()

end

function setStacklayout8(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.stacklayout = currenciesSelectionStacklayout[options.currencies][8]

  optionsCurrencies()

end



function setStacklayout9(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.stacklayout = currenciesSelectionStacklayout[options.currencies][9]

  optionsCurrencies()

end



function setStacklayout10(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  options.stacklayout = currenciesSelectionStacklayout[options.currencies][10]

  optionsCurrencies()

end





function changeCurrencies1(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  changeCurrenciesCo(1)

end



function changeCurrencies2(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(2)

end





function changeCurrencies3(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(3)

end



function changeCurrencies4(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(4)

end



function changeCurrencies5(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(5)

end



function changeCurrencies6(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(6)

end



function changeCurrencies7(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(7)

end



function changeCurrencies8(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(8)

end



function changeCurrencies9(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(9)

end







function changeCurrencies10(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(10)

end



function changeCurrencies11(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(11)

end



function changeCurrencies12(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(12)

end



function changeCurrencies13(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(13)

end



function changeCurrencies14(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(14)

end



function changeCurrencies15(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(15)

end



function changeCurrencies16(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(16)

end





function changeCurrencies16(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(16)

end





function changeCurrencies17(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(17)

end





function changeCurrencies18(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(18)

end





function changeCurrencies19(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  changeCurrenciesCo(19)

end



function changeCurrenciesCo(number)

  c = 0

  for i, v in pairs (currenciesSelectionStacklayout ) do

    c = c + 1

    if(c == number) then

      options.currencies = i

      options.stacklayout = v[1]

      currencies = currenciesSelection[i]

    end

  end



  for i, v in ipairs(getAllObjects()) do

    -- Update Buttons

    if v.getName() == 'Back Table' then

      v.clearButtons()

      if options.changemachine then

        local offsetx = 2 / #currencies

        local button = {}



        if #currencies <= 10 then

          offsetx = 1.65 / (#currencies - 2)

        else

          offsetx = 1.65 / 8

        end

        local offsety = 2 / #currencies

        button.font_size = 150

        button.width = 450

        button.height = 250

        button.scale = {1 / 5, 1 / 5, 1 / 7.5}

        button.position = {0.83, - 0.1, - 0.9}

        button.rotation = {180, 0, 0}



        for j, w in ipairs(currencies) do

          if w.value ~= -1 then

            button.label = w.label

            button.click_function = 'changeMachineButton' .. j

            v.createButton(button)

            button.position[1] = button.position[1] - offsetx

          end

          if j == 9 then

            if #currencies - 11 > 0 then

              offsetx = 1.65 / (#currencies - 11)

              button.position = {0.83, - 0.1, - 0.8} -- spawn 1 button in the center

            else

              button.position = {0, - 0.1, - 0.8} -- spawn 1 button in the center

            end

          end

        end

      end



    end

    -- Delete Old Infinite Money Bags

    if v.getDescription() == 'Infinite Money Bag' then

      v.destruct()

    end

  end





  -- spawn infinite Bags

  local params = {}

  local posx = 2

  local posy = 2.2

  local posz = -23



  local offsetx = 4

  local offsetz = -1.7





  for i, v in ipairs (currencies) do

    if v.value == -1 then

      break -- no dummy chips spawn

    end

    if not v.standard then

      params.position = {}

      params.position.x = posx + offsetx * ((i - 1) % 2)

      params.position.y = posy

      params.position.z = posz + offsetz * math.floor((i - 1) / 2)

      --rPrint(params.position,100,i .. ": ")

      params.position[1] = params.position.x

      params.position[2] = params.position.y

      params.position[3] = params.position.z





      params.rotation = v.params.rotation

      params.rotation[2] = (params.rotation[2] + 180) % 360

      params.scale = v.params.scale

      params.params = {v.name}

      params.type = 'Custom_Model'

      params.callback = ''

      params.callback_owner = Global

      custom = {}

      custom.mesh = v.custom.mesh

      custom.diffuse = v.custom.diffuse

      custom.type = 7 -- infinite

      custom.material = 1



      obj = spawnObject(params)

      obj.setCustomObject(custom)

      obj.setName(v.name)

      obj.setDescription("Infinite Money Bag")





      -- let chip fall into bag

      params.position.y = posy + 3

      params.position[2] = posy + 3

      custom.type = 5 -- chip

      obj = spawnObject(params)

      obj.setCustomObject(custom)

      obj.setName(v.name)

    end

  end











  optionsCurrencies()

end





function spawnClock(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  if clock ~= nil and clock ~= null then

    if pl then

      clock.Clock.setValue(options.clocktime + 1)

      clock.Clock.pauseStart()

      clock.clearButtons()

    end

    return 1

  end



  local params = {}

  if actionon then

    local playerhand = getPlayerHandPositionAndRotation(actionon)



    params.position = {playerhand['pos_x'] + playerhand['trigger_forward_x'] * 8, 0.5, playerhand['pos_z'] + playerhand['trigger_forward_z'] * 8}

    params.rotation = {90, playerhand['rot_y'], 0}

  else

    params.position = {0, 0.5, - 4}

    params.rotation = {90, 180, 0}

  end



  params.type = 'Digital_Clock'

  params.callback = 'setClockTimer'

  if pl then

    params.params = {pl}

  else

    params.params = nil

  end



  clock = spawnObject(params)



end



function setClockTimer(ob, pl)

  clock.lock()



  if pl then

    clock.Clock.setValue(options.clocktime + 1)

  else

    clock.Clock.setValue(options.autoclocktime + 1)

  end



  clock.Clock.pauseStart()



  if options.autoclock and options.clockpausebutton and not pl then

    local button = {}

    button.rotation = {90, 180, 0}

    button.position = { - 0.3, 0.5, - 0.15}

    button.font_size = 60

    button.width = 200

    button.height = 50

    button.label = 'Pause'

    button.click_function = 'pauseClock'

    clock.createButton(button)

  end

  startLuaCoroutine(nil, 'setClockTimerCoroutine')

end



function setClockTimerCoroutine()



  local clockGUID = clock.getGUID()



  while clock ~= nil and clock ~= null and clock.Clock.getValue() > 0 do

    coroutine.yield(0)

  end



  local t = os.clock()



  while os.clock() < t + 1 do

    coroutine.yield(0)

  end



  if clock ~= nil and clock ~= null then

    if clockGUID ~= clock.getGUID() then

      return 1

    end

  else

    return 1

  end



  if options.autofold then

    foldPlayer()

  end



  clock.destruct()



  return 1

end



function toggleAutoclock(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.autoclock = not options.autoclock

  optionsHost()

end



function toggleAutofold(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.autofold = not options.autofold

  optionsHost()

end



function decreaseAutoclockTime(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  if options.autoclocktime > 1 then

    options.autoclocktime = options.autoclocktime - 1

  end

  optionsHost()

end



function increaseAutoclockTime(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.autoclocktime = options.autoclocktime + 1

  optionsHost()

end



function toggleAutoclockPauseButton(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.clockpausebutton = not options.clockpausebutton

  optionsHost()

end



function pauseClock(ob, pl)

  if not Player[pl].admin and pl ~= actionon then

    return 1

  end



  clock.Clock.pauseStart()

end



function decreaseClockTime5(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  if options.clocktime > 5 then

    options.clocktime = options.clocktime - 5

  else

    return 1

  end



  optionsMain()

end

function decreaseClockTime1(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  if options.clocktime > 1 then

    options.clocktime = options.clocktime - 1

  else

    return 1

  end



  optionsMain()

end

function increaseClockTime1(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.clocktime = options.clocktime + 1



  optionsMain()

end

function increaseClockTime5(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.clocktime = options.clocktime + 5



  optionsMain()

end



function foldPlayer(ob, pl)



  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  if muck == nil or muck == null then

    checkAndRespawnObjects()

    --print ('The muck object has been lost. Please click the \'Reset Objects\' button on the options panel to reassign.')

    --return 1

  end



  if actionon then

    local cards = Player[actionon].getHandObjects()

    local p = muck.getPosition()

    local r = muck.getRotation()

    p.y = p.y + 0.25

    r.x = 180

    r.z = 0



    for i, v in ipairs (cards) do

      v.setRotation(r)

      v.setPosition(p)

      v.translate({0, 0.1, 0})

      p.y = p.y + 0.01

    end

  end



  startLuaCoroutine(nil, 'delayedAction')

end



function delayedAction()

  for i = 1, 2 do

    coroutine.yield(0)

  end



  action()

  return 1

end



function decreaseHybridThreshold1000(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  if options.hybridthreshold > 1000 then

    options.hybridthreshold = options.hybridthreshold - 1000

  end



  optionsHost()

end



function decreaseHybridThreshold100(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  if options.hybridthreshold > 100 then

    options.hybridthreshold = options.hybridthreshold - 100

  end



  optionsHost()

end



function increaseHybridThreshold100(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.hybridthreshold = options.hybridthreshold + 100



  optionsHost()

end



function increaseHybridThreshold1000(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.hybridthreshold = options.hybridthreshold + 1000



  optionsHost()

end





function decreaseConvertStackHeight1(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  if options.convertstackheight > 1 then

    options.convertstackheight = options.convertstackheight - 1

  else

    options.convertstackheight = 0

  end



  optionsHost()

end



function increaseConvertStackHeight1(ob, pl)

  if not Player[pl].admin then

    return 1

  end

  options.convertstackheight = options.convertstackheight + 1



  if options.convertstackheight >= 10 then

    options.convertstackheight = 10

  end

  optionsHost()

end















function doNothing()

end



function changeFontColor(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  local color = colorball.getColorTint()

  pottext.TextTool.setFontColor(color)

  currentbettext.TextTool.setFontColor(color)

  muck.setColorTint(color)

  boardobject.setColorTint(color)

end



function changeTableColor(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  local color = colorball.getColorTint()

  overlay.setColorTint(color)

end



function setGameModeTexas(ob, pl)



  if not Player[pl].admin or options.gamemode == 'texas' then

    return 1

  end



  options.gamemode = 'texas'

  printToAll('Game mode set to Texas Hold\'em. See rules in the notebook if you don\'t know how to play.', {1, 1, 1})



  optionsHost()

end

function setGameModeOmaha(ob, pl)



  if not Player[pl].admin or options.gamemode == 'omaha' then

    return 1

  end



  options.gamemode = 'omaha'

  printToAll('Game mode set to Omaha Hold\'em. See rules in the notebook if you don\'t know how to play.', {1, 1, 1})



  optionsHost()

end

function setGameModePineapple(ob, pl)



  if not Player[pl].admin or options.gamemode == 'pineapple' then

    return 1

  end



  options.gamemode = 'pineapple'

  printToAll('Game mode set to Pineapple. See rules in the notebook if you don\'t know how to play.', {1, 1, 1})



  optionsHost()

end

function setGameModeFiveCard(ob, pl)



  if not Player[pl].admin or options.gamemode == 'fivecard' then

    return 1

  end



  options.gamemode = 'fivedraw'

  printToAll('Game mode set to Five Card Draw. See rules in the notebook if you don\'t know how to play.', {1, 1, 1})



  optionsHost()

end



function getParams(obj)

  local params = {}

  params.position = obj.getPosition()

  params.scale = obj.getScale()

  params.rotation = obj.getRotation()



  return params

end



function setTheme1(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 1

  subthemeindex = 1

  optionsThemes()

end



function setTheme2(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 2

  subthemeindex = 1

  optionsThemes()

end



function setTheme3(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 3

  subthemeindex = 1

  optionsThemes()

end



function setTheme4(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 4

  subthemeindex = 1

  optionsThemes()

end



function setTheme5(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 5

  subthemeindex = 1

  optionsThemes()

end



function setTheme6(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 6

  subthemeindex = 1

  optionsThemes()

end



function setTheme7(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 7

  subthemeindex = 1

  optionsThemes()

end



function setTheme8(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 8

  subthemeindex = 1

  optionsThemes()

end



function setTheme9(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 9

  subthemeindex = 1

  optionsThemes()

end



function setTheme10(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 10

  subthemeindex = 1

  optionsThemes()

end



function setTheme11(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 11

  subthemeindex = 1

  optionsThemes()

end



function setTheme12(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  themeindex = 12

  subthemeindex = 1

  optionsThemes()

end



function setSubtheme1(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 1

  optionsThemes()

end

function setSubtheme2(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 2

  optionsThemes()

end

function setSubtheme3(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 3

  optionsThemes()

end

function setSubtheme4(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 4

  optionsThemes()

end

function setSubtheme5(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 5

  optionsThemes()

end

function setSubtheme6(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 6

  optionsThemes()

end

function setSubtheme7(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 7

  optionsThemes()

end

function setSubtheme8(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 8

  optionsThemes()

end

function setSubtheme9(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 9

  optionsThemes()

end

function setSubtheme10(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 10

  optionsThemes()

end

function setSubtheme11(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 11

  optionsThemes()

end

function setSubtheme12(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  subthemeindex = 12

  optionsThemes()

end



function overlay1 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][1].diffuse)



end

function overlay2 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][2].diffuse)



end

function overlay3 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][3].diffuse)



end

function overlay4 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][4].diffuse)



end

function overlay5 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][5].diffuse)



end

function overlay6 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][6].diffuse)



end

function overlay7 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][7].diffuse)



end

function overlay8 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][8].diffuse)



end

function overlay9 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][9].diffuse)



end

function overlay10 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][10].diffuse)



end

function overlay11 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][11].diffuse)



end

function overlay12 (ob, pl)



  if not Player[pl].admin then

    return 1

  end



  changeOverlay(themes[themeindex][subthemeindex][12].diffuse)



end



function changeOverlay(diffuse)



  local custom = overlay.getCustomObject()

  custom.diffuse = diffuse



  overlay.setCustomObject(custom)

  overlay = overlay.reload()

  overlay.interactable = false

  overlay.setColorTint({1, 1, 1})



end



--[[ Destroy options panel --]]

function destroyOptionsPanel(ob, pl)



  if pl and not Player[pl].admin then

    return 1

  end



  optionspanel.clearButtons()

  optionspanel.destruct()

  optionspanel = nil

  if colorball ~= nil and colorball ~= null then

    colorball.destruct()

  end

end



function toggleBlindsSkipAFK(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  options.blindsskipafk = not options.blindsskipafk



  optionsHost()

end



function darkenOverlay(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  local color = overlay.getColorTint()

  for i, v in pairs (color) do

    if v >= 0.05 then

      color[i] = v - 0.05

    else

      color[i] = 0

    end

  end



  overlay.setColorTint(color)

end



function lightenOverlay(ob, pl)



  if not Player[pl].admin then

    return 1

  end



  local color = overlay.getColorTint()

  for i, v in pairs (color) do

    if v <= 1.95 then

      color[i] = v + 0.05

    else

      color[i] = 2

    end

  end



  overlay.setColorTint(color)

end



function changeCollectMethod(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  if options.collectmethod == 'move' then

    options.collectmethod = 'convert'

    print('Collect method set to: Convert. Bets will now be converted up when collected. Bets will be convert with at least a height of ' .. options.convertstackheight)

  elseif options.collectmethod == 'convert' then

    options.collectmethod = 'hybrid'

    print('Collect method set to: Hybrid. Bets will be converted up once the pot is over $'..options.hybridthreshold..'.')

  elseif options.collectmethod == 'hybrid' then

    options.collectmethod = 'move'

    print('Collect method set to: Move. Bets will be moved into the pot.')

  else

    options.collectmethod = 'move'

    print('Unknown collect method found: Collect method set to: Move. Bets will be moved into the pot.')

  end



  optionsHost()

end



function checkAndRespawnObjects(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  sidepotcalculated = false





  local meshes = {'http://pastebin.com/raw/133e1Z0L', 'http://pastebin.com/raw/U9rtcyua', 'http://pastebin.com/raw/uvvaV5Np', 'https://raw.githubusercontent.com/johnpenny/tts-poker-table-coverings/master/poker-table-boards.obj'}

  local diffuses = {'http://i.imgur.com/QinS8Hc.png', 'http://i.imgur.com/hIKi7Mq.png', 'http://i.imgur.com/novIseH.png', 'http://i.imgur.com/jPnTE9e.png'}

  local allobjects = getAllObjects()

  local objects = {'muck', 'boardobject', 'potobject', 'overlay'}

  local objectnames = {'Muck', 'Board', 'Pot', 'Overlay'}

  local objectexists = {false, false, false, false} -- muck, board, pot, overlay

  local positions = {{ - 9.175, 1.35, - 1.9}, {0, 1.35, - 2}, {0, 1.35, - 7.5}, {0, 0.7, 0}}

  local custom = {}

  local params = {}

  local textparams = {}

  textparams.type = '3DText'



  -- mark unlost objects as existing

  for i, v in ipairs (objects) do

    if Global.getVar(v) ~= nil and Global.getVar(v) ~= null then

      objectexists[i] = true

      --print (objectnames[i]..' exists.')

    end

  end



  -- search for objects and reassign any that are found

  for i, v in ipairs (allobjects) do

    custom = v.getCustomObject()

    for j, w in ipairs (meshes) do

      if custom.mesh == w then

        if not objectexists[j] then

          Global.setVar(objects[j], v)

          objectexists[j] = true

          print(objectnames[j]..' reassigned.')

        end

      end

    end

  end



  -- respawn nonexistent objects

  for i, v in ipairs (objectexists) do

    if not v then

      params.type = 'Custom_Model'

      params.position = positions[i]

      params.rotation = {0, 0, 0}



      custom.mesh = meshes[i]

      custom.diffuse = diffuses[i]

      custom.type = 4



      local o = spawnObject(params)

      o.setCustomObject(custom)



      if i ~= 4 then

        o.setLuaScript(scripts[i])

      else

        o.lock()

        o.interactable = false

        o.setName('Table Overlay')

      end



      Global.setVar(objects[i], o)



      print (objectnames[i]..' respawned.')

    end

  end

  local actionscript = "blubb"



  --[[ Check and respawn texts --]]

  if actiontext == nil or actiontext == null then

    textparams.position = {0, 0, 0}

    textparams.rotation = {0, 0, 0}

    actiontext = spawnObject(textparams)

    actiontext.TextTool.setValue('Action')

    actiontext.TextTool.setFontSize(68)

    actiontext.setLuaScript(scripts[4])

  end

  if pottext == nil or pottext == null then

    textparams.position = {0, 1.33, 0}

    textparams.callback = 'spawnTextCallback'

    pottext = spawnObject(textparams)

    pottext.TextTool.setFontSize(64)

  end

  if currentbettext == nil or currentbettext == null then

    textparams.position = {0, 1.33, 1}

    textparams.callback = 'spawnTextCallback'

    currentbettext = spawnObject(textparams)

    currentbettext.TextTool.setFontSize(64)

  end

  for i, v in ipairs(colors) do

    if bettext[v] == nil or bettext[v] == null then

      local playerhand = Player[v].getHandTransform(1)

      textparams.position = {playerhand.position.x + playerhand.forward.x * 10 + playerhand.right.x * 4, 1.4, playerhand.position.z + playerhand.forward.z * 10 + playerhand.right.z * 4}

      textparams.callback = 'spawnTextCallback'

      bettext[v] = spawnObject(textparams)

      bettext[v].TextTool.setFontSize(64)

      bettext[v].TextTool.setFontColor(fontcolors[v])

    end

    if sidepottext[v] == nil or sidepottext[v] == null then



      local playerhand = Player[v].getHandTransform(1)

      textparams.position = {playerhand.position.x + playerhand.forward.x * 10.8, 1.33, playerhand.position.z + playerhand.forward.z * 10.8}

      textparams.callback = 'spawnTextCallback'

      sidepottext[v] = spawnObject(textparams)

      sidepottext[v].TextTool.setFontSize(64)

      sidepottext[v].TextTool.setFontColor(fontcolors[v])

      sidepottext[v].setValue("spawned")

    end

    if tablezonetext[v] == nil or tablezonetext[v] == null then

      local chips = {}

      local playerhand = Player[v].getHandTransform(1)

      textparams.position = {playerhand.position.x + playerhand.forward.x * - 2.5 + playerhand.right.x * 4, 1.4, playerhand.position.z + playerhand.forward.z * - 2.5 + playerhand.right.z * 4}

      textparams.callback = 'spawnTextCallback'

      tablezonetext[v] = spawnObject(textparams)

      tablezonetext[v].TextTool.setFontSize(64)

      tablezonetext[v].TextTool.setFontColor({1, 1, 1}) -- Black



      if options.displayplayermoney then

        money = getChipValues(tablezones[v], chips)

        tablezonetext[v].setValue("$" .. money)

      else

        tablezonetext[v].setValue(" ")

      end



    end



  end



end



function spawnTextCallback()

  check = true

  if not (pottext == nil or pottext == null) then

    pottext.setRotation({90, 180, 0})

  else

    check = false

  end

  if not (currentbettext == nil or currentbettext == null) then

    currentbettext.setRotation({90, 180, 0})

  else

    check = false

  end

  for i, v in ipairs(colors) do

    local playerhand = getPlayerHandPositionAndRotation(v)

    if not (bettext[v] == nil or bettext[v] == null) then

      bettext[v].setRotation({90, playerhand['rot_y'], 0})

    else

      check = false

    end

    if not (sidepottext[v] == nil or sidepottext[v] == null or type(sidepottext[v]) == "string") then

      sidepottext[v].setRotation({90, playerhand['rot_y'], 0})

    else

      check = false

    end

    if not (tablezonetext[v] == nil or tablezonetext[v] == null) then

      tablezonetext[v].setRotation({90, playerhand['rot_y'], 0})

    else

      check = false

    end

  end

  if check then

    calculatePots()

  end

end



function togglePlayerClickAction(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  if options.playerclickaction then

    options.playerclickaction = false

    print ('The Action button will now remain in a static position for the host to click.')



    local buttons = actionbutton.getButtons()



    buttons[1].label = 'Action'



    actionbutton.editButton(buttons[1])

  else

    options.playerclickaction = true

    print ('The action button will now be moved in front of the player whose turn it is to act.')



    local buttons = actionbutton.getButtons()



    buttons[1].label = 'Done'



    actionbutton.editButton(buttons[1])

  end



  optionsHost()

end



function toggleEnforcePotLimit(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.enforcepotlimit = not options.enforcepotlimit



  optionsHost()

end



function toggleEnforceFoldInTurn(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.enforcefoldinturn = not options.enforcefoldinturn



  optionsHost()

end



function toggleEnforceDoubleRaise(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.enforcedoubleraise = not options.enforcedoubleraise



  optionsHost()

end



function toggleActionMessage(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.chatoptions.actionmessage = not options.chatoptions.actionmessage



  optionsChat()

end



function toggleActionBroadcast(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.chatoptions.actionbroadcast = not options.chatoptions.actionbroadcast



  optionsChat()

end



function toggleStageBroadcast(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.chatoptions.stage = not options.chatoptions.stage



  optionsChat()

end



function toggleCurrentBetMessage(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.chatoptions.currentbetmessage = not options.chatoptions.currentbetmessage



  optionsChat()

end



function toggleBetter(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.chatoptions.better = not options.chatoptions.better



  optionsChat()

end



function toggleAllinBroadcast(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  options.chatoptions.allinbroadcast = not options.chatoptions.allinbroadcast



  optionsChat()

end



function togglePotMessage(ob, pl)

  if not Player[pl].admin then

    return 1

  end



  if options.chatoptions.potmessage >= 2 then

    options.chatoptions.potmessage = 0

  else

    options.chatoptions.potmessage = options.chatoptions.potmessage + 1

  end



  optionsChat()

end



function printMessages()



  local p = ''



  for i, v in ipairs(colors) do

    if string.find(printstring, v) then

      p = v

      break

    end

  end



  if string.find(printstring, 'bet') or string.find(printstring, 'raise') then

    if options.chatoptions.currentbetmessage then

      local s = 'Current bet: $'..currentbet

      if options.chatoptions.better then

        if string.find(printstring, 'bet') then

          if Player[p].steam_name then

            s = s..', made by '..fontcolors[p].bbcode..Player[p].steam_name..'[ffffff].'

          else

            s = s..', made by '..fontcolors[p].bbcode..p..'[ffffff].'

          end

        else

          if Player[p].steam_name then

            s = s..', raised by '..fontcolors[p].bbcode..Player[p].steam_name..'[ffffff].'

          else

            s = s..', raised by '..fontcolors[p].bbcode..p..'[ffffff].'

          end

        end

      else

        s = s..'.'

      end



      printToAll(s, {1, 1, 1})

    end

  end





  if options.chatoptions.allinbroadcast and string.find(printstring, 'allin') then

    if string.find(printstring, p) then

      if Player[p].steam_name then

        broadcastToAll (fontcolors[p].bbcode..Player[p].steam_name..'[ffffff] is all in!', {1, 1, 1})

      else

        broadcastToAll (fontcolors[p].bbcode..p..'[ffffff] is all in!.', {1, 1, 1})

      end

    end

  end



  if string.find(printstring, 'action') and actionon then



    if options.chatoptions.actionmessage then

      if Player[actionon].steam_name then

        printToAll ("Action on "..fontcolors[actionon].bbcode..Player[actionon].steam_name..'[ffffff].', {1, 1, 1})

      else

        printToAll ("Action on "..fontcolors[actionon].bbcode..actionon..'[ffffff].', {1, 1, 1})

      end

    end



    if options.chatoptions.actionbroadcast and Player[actionon].seated then

      broadcastToColor("Action on you!", actionon, {1, 0, 0})

    end

  end



  if options.chatoptions.potmessage > 0 then

    if (options.chatoptions.potmessage >= 1 and string.find(printstring, 'collect')) or (options.chatoptions.potmessage > 1 and string.find(printstring, 'pot')) then

      printToAll('Pot: $'..pot..'.', {1, 1, 1})

    end

  end



  printstring = ''

end



function onObjectDropped(player, object)

  if handinprogress and object.tag == 'Card' then



    if handsshown[player] then return 0 end -- if the player already revealed their hand, then abort function. this is to prevent players from spamming chat by repeatedly picking up and dropping their cards

    for i, v in ipairs (colors) do

      for j, w in ipairs (Player[v].getHandObjects()) do

        if w == object then return 0 end -- they dropped it into their hand, so abort function

      end

    end

    local r = object.getRotation()

    if (r.x < 80 or r.x > 280) and (r.z < 80 or r.z > 280) then -- it's face-up

      for i, v in ipairs (holecards[player]) do

        if v == object.getGUID() then

          table.insert(revealedcards[player], table.remove(holecards[player], i))

          break

        end

      end

      if #holecards[player] == 0 then

        handsshown[player] = true

        evaluateHand(player)

      end

    end

  end



  if isCurrency(object) then

    for i, v in ipairs (colors) do

      local chips = {}

      local value = "$" .. getChipValues(tablezones[v], chips)





      if options.displayplayermoney then

        tablezonetext[v].setValue(value)

      end

      for j, w in ipairs (chips) do

        if w == object then

          object.setColorTint(chiptints[v])

          return 1

        end

      end

      for j, w in ipairs (backtablezones[v].getObjects()) do

        if w == object then

          object.setColorTint(chiptints[v])

          return 1

        end

      end

      for j, w in ipairs (betzones[v].getObjects()) do

        if w == object then

          object.setColorTint(chiptints[v])

          return 1

        end

      end

    end

    object.setColorTint({1, 1, 1})

  end

end



function onObjectSpawn(object)

  if isCurrency(object) then

    for i, v in ipairs (colors) do

      for j, w in ipairs (tablezones[v].getObjects()) do

        if w == object then

          object.setColorTint(chiptints[v])

          return 1

        end

      end

      for j, w in ipairs (backtablezones[v].getObjects()) do

        if w == object then

          object.setColorTint(chiptints[v])

          return 1

        end

      end

      for j, w in ipairs (betzones[v].getObjects()) do

        if w == object then

          object.setColorTint(chiptints[v])

          return 1

        end

      end

    end

    object.setColorTint({1, 1, 1})

  end

end



function isCurrency(object)

  if object.tag == 'Chip' then

    if object.getValue() then

      return true

    elseif currencyToNumber(object.getName()) ~= nil then

      if currencyToNumber(object.getName()) > 0 then

        return true

      end

    else

      return false

    end

  end

end

function getPlayersHoleCards()

  for i, v in ipairs (players) do

    for j, w in ipairs (Player[v].getHandObjects()) do

      table.insert(holecards[v], w.getGUID())

    end

  end

end



function evaluateHand(player)



  if options.gamemode == 'omaha' then return 0 end -- doesn't work for omaha since it doesn't consider which cards are in the player's hand and which are on the board.



  local sevencards = getSevenCards(player)



  if not sevencards then return 0 end



  local cards = {['Spades'] = {}, ['Hearts'] = {}, ['Clubs'] = {}, ['Diamonds'] = {}}

  local suits = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}

  local ranks = {'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Jack', 'Queen', 'King', 'Ace'}

  local handranks = {'Royal Flush', 'Straight Flush', 'Four of a Kind', 'Full House', 'Flush', 'Straight', 'Three of a Kind', 'Two Pairs', 'One Pair', 'High Card'}



  -- Populate cards table

  for i, v in ipairs (sevencards) do

    for j, w in ipairs (ranks) do

      if getConvertedName(v.getName()) == w then

        table.insert(cards[v.getDescription()], nameToValue(w))

        break

      end

    end

  end



  -- Sort tables

  for i, v in ipairs (suits) do

    table.sort(cards[v])

  end



  -- Check for each type of hand until a hand is found



  -- Royal flush



  local flushexists = false

  local flushsuit = ''



  for i, v in ipairs (suits) do

    if #cards[v] >= 5 then -- a flush exists at least

      flushexists = true

      flushsuit = v

      local value = 0

      for j = 1, 5 do

        value = value + cards[v][#cards[v] - (j - 1)]

      end

      if value == 60 then -- it's a royal flush!

        broadcastToAll(player..' shows a '..flushsuit..' Royal Flush!', {0, 1, 0})

        return 0

      end

    end

  end



  -- Straight Flush



  if flushexists then

    local consecutives = 0

    local highcard = 0

    local lowconsecutives = false

    local ace = false

    for i, v in ipairs (cards[flushsuit]) do

      if i == 1 then

        consecutives = 1

      else

        if v == (cards[flushsuit][i - 1] + 1) then

          consecutives = consecutives + 1

          if consecutives >= 5 then

            highcard = v

          elseif consecutives == 4 and v == 5 then

            lowconsecutives = true

          end

        else

          consecutives = 1

        end

        if v == 14 then

          ace = true

        end

      end

    end



    -- check for straight flush to the 5

    if highcard == 0 and ace and lowconsecutives then highcard = 5 end



    if highcard > 0 then

      broadcastToAll (fontcolors[player].bbcode..player..' shows a '..flushsuit..' Straight Flush to the '..valueToName(highcard), {1, 1, 1})

      return 0

    end

  end



  -- Create list of all cards based on rank to use in finding pairs, etc.



  local cards2 = {}



  for i, v in ipairs (suits) do

    for j, w in ipairs (cards[v]) do

      table.insert(cards2, w)

    end

  end



  table.sort(cards2)



  local quantities = {}



  for i, v in ipairs (cards2) do

    if not quantities[valueToName(v)] then

      quantities[valueToName(v)] = 1

    else

      quantities[valueToName(v)] = quantities[valueToName(v)] + 1

    end

  end



  local quads = {}

  local trips = {}

  local pairs = {}

  local singles = {}

  for i, v in ipairs (ranks) do

    if quantities[v] == 4 then table.insert(quads, v) end

    if quantities[v] == 3 then table.insert(trips, v) end

    if quantities[v] == 2 then table.insert(pairs, v) end

    if quantities[v] == 1 then table.insert(singles, v) end

  end



  -- Check for quads

  if #quads > 0 then

    broadcastToAll(fontcolors[player].bbcode..player..' shows Four of a Kind: '..quads[#quads]..'s!', {1, 1, 1})

    return 0

  end



  -- Check for full house

  if #trips > 0 and #trips + #pairs >= 2 then

    if #pairs > 0 then

      printToAll (fontcolors[player].bbcode..player..' shows a Full House: '..trips[#trips]..'s full of '..pairs[#pairs]..'s!', {1, 1, 1})

    else

      printToAll (fontcolors[player].bbcode..player..' shows a Full House: '..trips[#trips]..'s full of '..trips[#trips - 1]..'s!', {1, 1, 1})

    end

    return 0

  end



  -- Flush

  if flushexists then

    printToAll (fontcolors[player].bbcode..player..' shows a '..flushsuit..' Flush, '..valueToName(cards[flushsuit][#cards[flushsuit]])..' high!', {1, 1, 1})

    return 0

  end



  -- Check for Straight

  local consecutives = 0

  local highcard = 0

  local lowconsecutives = false

  local ace = false

  for i, v in ipairs (cards2) do

    if i == 1 then

      consecutives = 1

    else

      if v == (cards2[i - 1] + 1) then

        consecutives = consecutives + 1

        if consecutives >= 5 then

          highcard = v

        elseif consecutives == 4 and v == 5 then

          lowconsecutives = true

        end

      elseif v ~= cards2[i - 1] then

        consecutives = 1

      end

      if v == 14 then

        ace = true

      end

    end

  end



  -- check for straight flush to the 5

  if highcard == 0 and ace and lowconsecutives then highcard = 5 end



  if highcard > 0 then

    printToAll (fontcolors[player].bbcode..player..' shows a Straight to the '..valueToName(highcard)..'!', {1, 1, 1})

    return 0

  end



  -- Check for trips

  if #trips > 0 then

    printToAll (fontcolors[player].bbcode..player..' shows Three of a Kind: '..trips[#trips]..'s.', {1, 1, 1})

    return 0

  end



  -- Check for two pair

  if #pairs >= 2 then

    printToAll (fontcolors[player].bbcode..player..' shows Two Pair: '..pairs[#pairs]..'s and '..pairs[#pairs - 1]..'s.', {1, 1, 1})

    return 0

  end



  -- Check for one pair

  if #pairs == 1 then

    printToAll (fontcolors[player].bbcode..player..' shows One Pair: '..pairs[#pairs]..'s.', {1, 1, 1})

    return 0

  end



  -- High card

  printToAll (fontcolors[player].bbcode..player..' shows '..singles[#singles]..' High.', {1, 1, 1})



end



function getSevenCards(player)

  local sevencards = {}



  for i, v in ipairs (boardzone.getObjects()) do

    if v.tag == 'Card' then

      if v.getName() == '' or v.getDescription() == '' then return nil end

      sevencards[#sevencards + 1] = v

    end

  end

  for i, v in ipairs (revealedcards[player]) do

    local card = getObjectFromGUID(v)

    if card.tag == 'Card' then

      if card.getName() == '' or card.getDescription() == '' then return nil end

      sevencards[#sevencards + 1] = card

    end

  end



  return sevencards

end



function getConvertedName(name)

  if name == '2' then return 'Two' end

  if name == '3' then return 'Three' end

  if name == '4' then return 'Four' end

  if name == '5' then return 'Five' end

  if name == '6' then return 'Six' end

  if name == '7' then return 'Seven' end

  if name == '8' then return 'Eight' end

  if name == '9' then return 'Nine' end

  if name == '10' then return 'Ten' end

  return name

end



function nameToValue(name)

  if name == 'Two' then return 2 end

  if name == 'Three' then return 3 end

  if name == 'Four' then return 4 end

  if name == 'Five' then return 5 end

  if name == 'Six' then return 6 end

  if name == 'Seven' then return 7 end

  if name == 'Eight' then return 8 end

  if name == 'Nine' then return 9 end

  if name == 'Ten' then return 10 end

  if name == 'Jack' then return 11 end

  if name == 'Queen' then return 12 end

  if name == 'King' then return 13 end

  if name == 'Ace' then return 14 end

end



function valueToName(value)

  if value == 2 then return 'Two' end

  if value == 3 then return 'Three' end

  if value == 4 then return 'Four' end

  if value == 5 then return 'Five' end

  if value == 6 then return 'Six' end

  if value == 7 then return 'Seven' end

  if value == 8 then return 'Eight' end

  if value == 9 then return 'Nine' end

  if value == 10 then return 'Ten' end

  if value == 11 then return 'Jack' end

  if value == 12 then return 'Queen' end

  if value == 13 then return 'King' end

  if value == 14 then return 'Ace' end

end



function onObjectPickedUp(player, object)



  if Player[player].admin then return 0 end



  local r = object.getPosition()

  local description = ''



  if object.getName() ~= '' then

    description = object.getName()

  elseif object.getValue() then

    description = object.getValue()

  else

    description = object.tag

  end



  --[[ Check if the object is inside the dealer's area --]]

  if r.x < 8.5 and r.x > - 8.5 and r.z < - 16.5 and r.z > - 52 then

    object.translate({0, 1, 0})

    print (player..' has attempted to pick up an object ('..description..') in the dealer\'s area.')

    return 0

  end



  --[[ Check if the object is on another player's table or bet zone, and not in player's own table or betzone --]]



  if not objectExistsInList(tablezones[player].getObjects(), object) and not objectExistsInList(betzones[player].getObjects(), object) then

    for i, v in ipairs (colors) do

      if v ~= player then

        if objectExistsInList(tablezones[v].getObjects(), object) or objectExistsInList(betzones[v].getObjects(), object) or objectExistsInList(backtablezones[v].getObjects(), object) then

          object.translate({0, 1, 0})

          print (player..' has attempted to pick up an object ('..description..') on player '..v..'\'s table or bet square.')

          return 0

        end

      end

    end

  end



  --[[ If the object is a card and not in the player's own hand, then drop it. Only works with named cards. --]]



  local ranks = {['Ace'] = true, ['Two'] = true, ['Three'] = true, ['Four'] = true, ['Five'] = true, ['Six'] = true, ['Seven'] = true, ['Eight'] = true, ['Nine'] = true, ['Ten'] = true, ['Jack'] = true, ['Queen'] = true, ['King'] = true}

  if object.tag == 'Card' and ranks[getConvertedName(object.getName())] then

    for i, v in ipairs (Player[player].getHandObjects()) do

      if object == v then return 0 end

    end

    for i, v in ipairs (holecards[player]) do

      if object.getGUID() == v then return 0 end

    end

    for i, v in ipairs (revealedcards[player]) do

      if object.getGUID() == v then return 0 end

    end

    object.translate({0, 1, 0})

    print (player..' has attempted to pick up a card that does not belong to them.')

  end

end



function initializePot()

  local p = {}

  p = stacklayout[options.stacklayout]



  -- reset height

  for i, v in pairs (p) do

    v.height = 0

    v.x = 0

    v.y = 0

    v.z = 0

  end

  return p

end



function createSidepot(ob, pl)

  createSidepotPl = pl

  createSidepotOb = ob

  startLuaCoroutine(nil, "coCreateSidepot")

end



function coCreateSidepot()



  pl = createSidepotPl

  ob = createSidepotOb



  if sidepotfailcount > sidepotfailcountlimit then

    convertfailcount = 0

    print("Error in Sidepotcreations, chips were moved");

    return 1

  end



  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  -- cant build sidepots twice

  if sidepotcalculated then

    return 1

  end



  local chips1 = {}

  local positions1 = {}

  local rotations1 = {}

  for i, v in pairs (betzones) do

    objects = {}

    objects = v.getObjects()

    for j, w in ipairs (objects) do

      if w.tag == 'Chip' then

        if w.getValue() or currencyToNumber(w.getName()) ~= nil then

          chips1[#chips1 + 1] = w

        end

      end

    end

  end

  for i, v in ipairs (chips1) do

    positions1[#positions1 + 1] = v.getPosition()

    rotations1[#rotations1 + 1] = v.getRotation()

  end

  for i = 1, 2 do

    coroutine.yield(0)

  end

  local chips2 = {}

  local playerbets = {}

  local positions2 = {}

  local rotations2 = {}

  for i, v in ipairs (colors) do

    playerbets[i] = { getChipValues(betzones[v], chips2), betzones[v], v, 0}

  end

  for i, v in ipairs (chips2) do

    positions2[#positions2 + 1] = v.getPosition()

    rotations2[#rotations2 + 1] = v.getRotation()

  end

  --[[ Check chip positions --]]

  for i, v in ipairs(positions1) do

    if v.x ~= positions2[i].x or v.y ~= positions2[i].y or v.z ~= positions2[i].z then

      sidepotfailcount = sidepotfailcount + 1

      --startLuaCoroutine(nil, 'convertBetsToPot')

      print("error in convert")



      return 1

    end

  end

  table.sort(playerbets, compare)

  for i, v in ipairs (playerbets) do

    if i == #playerbets then

      v[4] = v[1] * i

    else

      v[4] = ( v[1] - playerbets[i + 1][1]) * i

    end

  end

  for i, v in ipairs (chips2) do

    v.destruct()

  end



  if clock ~= nil then

    clock.destruct()

  end



  local spawnedcolors = {}

  local params = {}

  params.type = "backgammon_piece_white"

  params.position = {5, 2, 1}

  params.rotation = {0, 180, 0}

  params.scale = {0.4, 0.2, 0.4}



  for i, v in ipairs (playerbets) do

    if v[1] > 0 then

      bettext[v[3]].setValue("Bet: $" .. tostring(v[1]))

      sidepottext[v[3]].setValue("Sidepot: $" .. tostring(v[4]))

      local p = {}

      local r = {}

      p = v[2].getPosition()

      r = v[2].getRotation()

      r.y = (r.y + 180) % 360

      spawnChips(v[4], p, r)

      local zoffset = -3

      local xoffset = -3

      p.x = p.x + (math.cos(math.rad(r.y)) * xoffset) + (math.sin(math.rad(r.y)) * zoffset)

      p.z = p.z - (math.sin(math.rad(r.y)) * xoffset) + (math.cos(math.rad(r.y)) * zoffset)

      local zoffset = 0

      local xoffset = 0.5

      spawnedcolors[#spawnedcolors + 1] = v[3]

      for k, w in ipairs(spawnedcolors) do



        p.x = p.x + (math.cos(math.rad(r.y)) * xoffset) + (math.sin(math.rad(r.y)) * zoffset)

        p.z = p.z - (math.sin(math.rad(r.y)) * xoffset) + (math.cos(math.rad(r.y)) * zoffset)

        params.position = p

        ob = spawnObject(params)

        ob.setColorTint(fontcolors[w])

        ob.setName("Sidepotmarker")

      end



    end

  end













  for j, v in ipairs (playerbets) do





  end

  sidepotcalculated = true

  return 1

end





-- chips should correspond to the chipstable, position, rotation is where the chips should move to

function moveChips(chips, p, r)

  local chipstack = initializePot()

  local h = {}

  local chips2 = {}

  for i, v in pairs (chipstack) do

    chips2[i] = {}

    h[i] = {}

  end

  for i, v in pairs(chipstack) do

    v.x = p.x + (math.cos(math.rad(r.y)) * v.xoffset) + (math.sin(math.rad(r.y)) * v.zoffset)

    v.z = p.z - (math.sin(math.rad(r.y)) * v.xoffset) + (math.cos(math.rad(r.y)) * v.zoffset)

    v.y = p.y + v.yoffset + v.height

  end



  -- move also chips within the potzone

  for j, w in ipairs (chips) do

    if w.tag == "Chip" and not w.held_by_color then

      local hit = false

      for k, x in pairs (currencies) do

        local stack

        if h[x.stack] == nil then

          stack = "misc"

        else

          stack = x.stack

        end

        if w.getValue() == x.value or w.getName() == x.name then

          hit = true

          chips2[stack][#chips2[stack] + 1] = w

          if w.getQuantity() > 0 then

            h[stack][#h[stack] + 1] = w.getQuantity() * x.height

          else

            h[stack][#h[stack] + 1] = x.height

          end

          break -- next object

        end

      end

      -- unknown chips

      if not hit then



        local x = currencies[#currencies] -- should be dummy value

        local stack = "misc"

        chips2[stack][#chips2[stack] + 1] = w

        if w.getQuantity() > 0 then

          h[stack][#h[stack] + 1] = w.getQuantity() * x.height

        else

          h[stack][#h[stack] + 1] = x.height

        end

      end

    end

  end



  for i, v in pairs (chips2) do

    for j, w in ipairs (v) do



      local rot = {0, 0, 0}

      for k, x in pairs (currencies) do

        if (w.getValue() == x.value) or (w.getName() == x.name) then

          rot.x = (r.x + x.params.rotation[1]) % 360

          rot.y = (r.y + x.params.rotation[2]) % 360

          rot.z = (r.z + x.params.rotation[3]) % 360

          rot[1] = rot.x

          rot[2] = rot.y

          rot[3] = rot.z

        end

      end

      w.setRotation(rot)

      w.setPosition(chipstack[i])

      w.translate({0, 0.1, 0})

      chipstack[i].y = chipstack[i].y + h[i][j]

      chipstack[i].height = chipstack[i].height + h[i][j]

    end

  end





  return 1

end



-- spawnChips(money, position, rotation)

function spawnChips(money, p, r, minheight)

  if minheight == nil or minheight == null then

    minheight = 0

  end

  money = money + 0.001 -- prevents rounding error

  money = comma_value(money) + 0



  local chipstack = {}



  local params = {}

  local custom = {}



  -- prevent spawning to much Chips

  if money > currencies[1].value * 50 then





    money = math.floor(money)

    params.position = p

    params.rotation = r

    params.scale = {1.12, 1.12, 1.12}

    params.params = {"$" .. string.format("%.0f", money) }

    params.type = 'Custom_Model'

    params.callback = nil

    custom.mesh = "http://cloud-3.steamusercontent.com/ugc/841461304086373873/9925B4E8ECFC5BBB13AB9FD1BB93E768C2DD3151/"

    custom.diffuse = "http://cloud-3.steamusercontent.com/ugc/841461304094020976/22277301EF8ACDDD4649BD6F382CF950967A8D50/"



    custom.type = 5

    custom.material = 1



    local obj = spawnObject(params)

    obj.setCustomObject(custom)

    obj.setName("$" .. comma_value(money) )

    printToAll('Conversion Limit reached, alternate Bar with the money value spawned', {1, 1, 0})

    return 1

  end







  chipstack = initializePot()





  for i, v in pairs(chipstack) do

    v.x = p.x + (math.cos(math.rad(r.y)) * v.xoffset) + (math.sin(math.rad(r.y)) * v.zoffset)

    v.z = p.z - (math.sin(math.rad(r.y)) * v.xoffset) + (math.cos(math.rad(r.y)) * v.zoffset)

    v.y = p.y + v.yoffset + v.height

  end



  params.rotation = r

  params.callback_owner = Global



  local i = #currencies

  while i > 0 do





    v = currencies[i]

    if not (v.value == -1) then

      params.rotation = v.params.rotation

      params.scale = v.params.scale

      params.params = {v.name}

      local rot = {}

      rot.x = (r.x + v.params.rotation[1]) % 360

      rot.y = (r.y + v.params.rotation[2]) % 360

      rot.z = (r.z + v.params.rotation[3]) % 360

      rot[1] = rot.x

      rot[2] = rot.y

      rot[3] = rot.z

      params.rotation = rot

      local stack = ''

      if chipstack[v.stack] == nil then

        stack = "misc"

      else

        stack = v.stack

      end

      if not v.standard then



        params.type = 'Custom_Model'

        params.callback_owner = Global

        custom.mesh = v.custom.mesh

        custom.diffuse = v.custom.diffuse

        custom.type = 5

        custom.material = 1





        local j = 0

        while (j < minheight) and (money >= v.value) do

          params.position = {}

          params.position.x = chipstack[stack].x

          params.position.y = chipstack[stack].y + chipstack[stack].height

          params.position.z = chipstack[stack].z

          local obj = spawnObject(params)

          obj.setCustomObject(custom)

          obj.setName(v.name)

          money = money - v.value

          chipstack[stack].height = chipstack[stack].height + v.height

          j = j + 1

        end

      else

        params.type = 'Chip_'.. v.value

        params.callback = nil

        params.callback_owner = Global

        params.params = nil

        local j = 0

        while (j < minheight) and (money >= v.value) do

          params.position = {}

          params.position.x = chipstack[stack].x

          params.position.y = chipstack[stack].y + chipstack[stack].height

          params.position.z = chipstack[stack].z

          spawnObject(params)

          money = money - v.value

          chipstack[stack].height = chipstack[stack].height + v.height

          j = j + 1

        end

      end

    end

    i = i - 1

  end





  for i, v in ipairs (currencies) do



    if v.value == -1 then

      break -- no dummy chips spawn

    end

    params.rotation = v.params.rotation

    params.scale = v.params.scale

    params.params = {v.name}

    if chipstack[v.stack] == nil then

      stack = "misc"

    else

      stack = v.stack

    end



    if not v.standard then

      params.type = 'Custom_Model'

      params.callback_owner = Global

      custom.mesh = v.custom.mesh

      custom.diffuse = v.custom.diffuse

      custom.type = 5

      custom.material = 1

      local rot = {}

      rot.x = (r.x + v.params.rotation[1]) % 360

      rot.y = (r.y + v.params.rotation[2]) % 360

      rot.z = (r.z + v.params.rotation[3]) % 360

      rot[1] = rot.x

      rot[2] = rot.y

      rot[3] = rot.z

      params.rotation = rot

      while money >= tonumber(v.value) do

        params.position = {}

        params.position.x = chipstack[stack].x

        params.position.y = chipstack[stack].y + chipstack[stack].height

        params.position.z = chipstack[stack].z

        local obj = spawnObject(params)

        obj.setCustomObject(custom)

        obj.setName(v.name)

        money = money - v.value

        chipstack[stack].height = chipstack[stack].height + v.height

      end

    else

      params.type = 'Chip_'.. v.value

      params.callback = nil

      params.callback_owner = Global

      params.params = nil

      while money >= v.value do

        params.position = {}

        params.position.x = chipstack[stack].x

        params.position.y = chipstack[stack].y + chipstack[stack].height

        params.position.z = chipstack[stack].z

        spawnObject(params)

        money = money - v.value

        chipstack[stack].height = chipstack[stack].height + v.height

      end

    end

  end

  return money -- returns the leftover money

end



function sortPlayerChips(ob, pl)

  if Player[pl].admin then

    pl = ob.getDescription()

  elseif ob.getDescription() ~= pl then

    return 1

  end



  local chips = {}

  local value

  value = "$" .. getChipValues(tablezones[pl], chips)

  if options.displayplayermoney then

    tablezonetext[pl].setValue(value)

  end



  p = tablezones[pl].getPosition()

  r = tablezones[pl].getRotation()



  xoffset = -1.15

  zoffset = 1

  x = p.x + (math.cos(math.rad(r.y)) * xoffset) + (math.sin(math.rad(r.y)) * zoffset)

  z = p.z - (math.sin(math.rad(r.y)) * xoffset) + (math.cos(math.rad(r.y)) * zoffset)

  y = p.y - 10



  pos = {x, y, z}

  pos.x = x

  pos.y = y

  pos.z = z



  r.y = (r.y + 180) % 360

  moveChips(chips, pos, r)





end



function quickConvertPlayerChips10(ob, pl)

  if Player[pl].admin then

    pl = ob.getDescription()

  elseif ob.getDescription() ~= pl then

    return 1

  end





  if quickConvertPlayerChips == true then

    -- if 15 seconds are over after the last convertion then start another one (function broke before)

    if (os.time() - quickConvertPlayerTime) < 15 then

      return

    else

      quickConvertPlayerTime = os.time()

    end

  else

    quickConvertPlayerChips = true

    quickConvertPlayerTime = os.time()

  end









  quickConvertPlayersPlayer = pl

  quickConvertPlayersObject = ob



  startLuaCoroutine(nil, 'quickConvertPlayerChips10Co')



end



function quickConvertPlayerChips10Co()





  local pl = quickConvertPlayersPlayer

  local ob = quickConvertPlayersObject









  local objects = {}

  local chips1 = {}

  local positions1 = {}

  local rotations1 = {}



  v = tablezones[pl]

  objects = {}

  objects = v.getObjects()

  for j, w in ipairs (objects) do

    if w.tag == 'Chip' then

      if w.getValue() or currencyToNumber(w.getName()) ~= nil then

        chips1[#chips1 + 1] = w

      end

    end

  end





  for i, v in ipairs (chips1) do

    positions1[#positions1 + 1] = v.getPosition()

    rotations1[#rotations1 + 1] = v.getRotation()

  end



  for i = 0, 2 do

    coroutine.yield(0)

  end





  objects = {}

  local chips2 = {}

  local positions2 = {}

  local rotations2 = {}



  v = tablezones[pl]

  objects = {}

  objects = v.getObjects()

  for j, w in ipairs (objects) do

    if w.tag == 'Chip' then

      if w.getValue() or currencyToNumber(w.getName()) ~= nil then

        chips2[#chips2 + 1] = w

      end

    end

  end





  if #chips2 ~= #chips1 then

    quickConvertPlayerChips = false

    return 1

  end



  for i = 0, 2 do

    coroutine.yield(0)

  end





  for i, v in ipairs (chips2) do

    positions2[#positions2 + 1] = v.getPosition()

    rotations2[#rotations2 + 1] = v.getRotation()

  end



  --[[ Check chip positions --]]

  for i, v in ipairs(positions1) do

    if v.x ~= positions2[i].x or v.y ~= positions2[i].y or v.z ~= positions2[i].z then

      quickConvertPlayerChips = false

      return 1

    end

  end



  --[[ Check chip rotations --]]

  for i, v in pairs(rotations1) do

    if v.x ~= rotations2[i].x or v.y ~= rotations2[i].y or v.z ~= rotations2[i].z then

      quickConvertPlayerChips = false

      return 1

    end

  end



  local chips = {}

  local money = 0





  money = getChipValues(tablezones[pl], chips)

  --[[ Destroy old chips --]]

  for i, v in ipairs (chips) do

    v.destruct()

  end



  for i = 0, 10 do

    coroutine.yield(0)

  end



  local p = tablezones[pl].getPosition()

  local r = tablezones[pl].getRotation()



  xoffset = -1.15

  zoffset = 1

  x = p.x + (math.cos(math.rad(r.y)) * xoffset) + (math.sin(math.rad(r.y)) * zoffset)

  z = p.z - (math.sin(math.rad(r.y)) * xoffset) + (math.cos(math.rad(r.y)) * zoffset)

  y = p.y - 10



  pos = {x, y, z}

  pos.x = x

  pos.y = y

  pos.z = z



  r.y = (r.y + 180) % 360



  spawnChips(money, pos, r, 10)





  --[[ Wait five frames to allow chips to spawn before updating pot values --]]



  quickConvertPlayerChips = false

  return 1

end



function quickConvertPlayerChips10_5(ob, pl)

  if Player[pl].admin then

    pl = ob.getDescription()

  elseif ob.getDescription() ~= pl then

    return 1

  end



  if quickConvertPlayerChips == true then

    -- if 30 seconds are over after the last convertion then start another one (function broke before)

    if (os.time() - quickConvertPlayerTime) < 30 then

      return

    else

      quickConvertPlayerTime = os.time()

    end

  else

    quickConvertPlayerChips = true

    quickConvertPlayerTime = os.time()

  end



  quickConvertPlayersPlayer = pl

  quickConvertPlayersObject = ob



  startLuaCoroutine(nil, 'quickConvertPlayerChips10_5Co')



end









function quickConvertPlayerChips10_5Co()

  local pl = quickConvertPlayersPlayer

  local ob = quickConvertPlayersObject









  local objects = {}

  local chips1 = {}

  local positions1 = {}

  local rotations1 = {}



  v = tablezones[pl]

  objects = {}

  objects = v.getObjects()

  for j, w in ipairs (objects) do

    if w.tag == 'Chip' then

      if w.getValue() or currencyToNumber(w.getName()) ~= nil then

        chips1[#chips1 + 1] = w

      end

    end

  end





  for i, v in ipairs (chips1) do

    positions1[#positions1 + 1] = v.getPosition()

    rotations1[#rotations1 + 1] = v.getRotation()

  end



  for i = 0, 2 do

    coroutine.yield(0)

  end





  objects = {}

  local chips2 = {}

  local positions2 = {}

  local rotations2 = {}



  v = tablezones[pl]

  objects = {}

  objects = v.getObjects()

  for j, w in ipairs (objects) do

    if w.tag == 'Chip' then

      if w.getValue() or currencyToNumber(w.getName()) ~= nil then

        chips2[#chips2 + 1] = w

      end

    end

  end





  if #chips2 ~= #chips1 then

    quickConvertPlayerChips = false

    return 1

  end



  for i = 0, 2 do

    coroutine.yield(0)

  end





  for i, v in ipairs (chips2) do

    positions2[#positions2 + 1] = v.getPosition()

    rotations2[#rotations2 + 1] = v.getRotation()

  end



  --[[ Check chip positions --]]

  for i, v in ipairs(positions1) do

    if v.x ~= positions2[i].x or v.y ~= positions2[i].y or v.z ~= positions2[i].z then

      quickConvertPlayerChips = false

      return 1

    end

  end



  --[[ Check chip rotations --]]

  for i, v in pairs(rotations1) do

    if v.x ~= rotations2[i].x or v.y ~= rotations2[i].y or v.z ~= rotations2[i].z then

      quickConvertPlayerChips = false

      return 1

    end

  end



  local chips = {}

  local money = 0





  money = getChipValues(tablezones[pl], chips)

  --[[ Destroy old chips --]]

  for i, v in ipairs (chips) do

    v.destruct()

  end



  for i = 0, 10 do

    coroutine.yield(0)

  end



  local p = tablezones[pl].getPosition()

  local r = tablezones[pl].getRotation()



  xoffset = -1.15

  zoffset = 1

  x = p.x + (math.cos(math.rad(r.y)) * xoffset) + (math.sin(math.rad(r.y)) * zoffset)

  z = p.z - (math.sin(math.rad(r.y)) * xoffset) + (math.cos(math.rad(r.y)) * zoffset)

  y = p.y - 10



  pos = {x, y, z}

  pos.x = x

  pos.y = y

  pos.z = z



  r.y = (r.y + 180) % 360



  local lowStackValue = 0

  lowStackValue = currencies[#currencies - 1].value * 5 + currencies[#currencies - 2].value * 5

  if money <= lowStackValue then

    spawnChips(money, pos, r, 10)

  else



    money = money - lowStackValue

    spawnChips(money, pos, r, 5)

    pos["y"] = pos["y"] + 5

    spawnChips(lowStackValue, pos, r, 5)





  end





  for i = 0, 10 do

    coroutine.yield(0)

  end

  -- update money display

  if options.displayplayermoney then

    local chips = {}

    tablezonetext[pl].setValue("$" .. getChipValues(tablezones[pl], chips))

    --[[ Wait five frames to allow chips to spawn before updating pot values --]]

    quickConvertPlayerChips = false

  end

  return 1

end







function splitPot2(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  splitPotObject = ob;

  splitPotPlayers = 2;



  local p = ob.getPosition()

  local r = ob.getRotation()

  local s = ob.getScale()

  params = {}

  params.type = 'ScriptingTrigger'

  params.callback = 'splitPot'

  params.scale = {s.x, 20, s.z * 1.9}

  params.position = {p.x, p.y + 10, p.z}

  params.rotation = r



  splitPotZone = spawnObject(params)

end



function splitPot3(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  splitPotObject = ob;

  splitPotPlayers = 3;



  local p = ob.getPosition()

  local r = ob.getRotation()

  local s = ob.getScale()

  params = {}

  params.type = 'ScriptingTrigger'

  params.callback = 'splitPot'

  params.scale = {s.x, 20, s.z * 1.9}

  params.position = {p.x, p.y + 10, p.z}

  params.rotation = r



  splitPotZone = spawnObject(params)

end



function splitPot4(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  splitPotObject = ob;

  splitPotPlayers = 4 ;



  local p = ob.getPosition()

  local r = ob.getRotation()

  local s = ob.getScale()

  params = {}

  params.type = 'ScriptingTrigger'

  params.callback = 'splitPot'

  params.scale = {s.x, 20, s.z * 1.9}

  params.position = {p.x, p.y + 10, p.z}

  params.rotation = r



  splitPotZone = spawnObject(params)

end



function splitPot5(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  splitPotObject = ob;

  splitPotPlayers = 5;



  local p = ob.getPosition()

  local r = ob.getRotation()

  local s = ob.getScale()

  params = {}

  params.type = 'ScriptingTrigger'

  params.callback = 'splitPot'

  params.scale = {s.x, 20, s.z * 1.9}

  params.position = {p.x, p.y + 10, p.z}

  params.rotation = r



  splitPotZone = spawnObject(params)

end



function splitPot6(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  splitPotObject = ob;

  splitPotPlayers = 6;



  local p = ob.getPosition()

  local r = ob.getRotation()

  local s = ob.getScale()

  params = {}

  params.type = 'ScriptingTrigger'

  params.callback = 'splitPot'

  params.scale = {s.x, 20, s.z * 1.9}

  params.position = {p.x, p.y + 10, p.z}

  params.rotation = r



  splitPotZone = spawnObject(params)

end



function splitPot7(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  splitPotObject = ob;

  splitPotPlayers = 7;



  local p = ob.getPosition()

  local r = ob.getRotation()

  local s = ob.getScale()

  params = {}

  params.type = 'ScriptingTrigger'

  params.callback = 'splitPot'

  params.scale = {s.x, 20, s.z * 1.9}

  params.position = {p.x, p.y + 10, p.z}

  params.rotation = r



  splitPotZone = spawnObject(params)

end



function splitPot8(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  splitPotObject = ob;

  splitPotPlayers = 8;



  local p = ob.getPosition()

  local r = ob.getRotation()

  local s = ob.getScale()

  params = {}

  params.type = 'ScriptingTrigger'

  params.callback = 'splitPot'

  params.scale = {s.x, 20, s.z * 1.9}

  params.position = {p.x, p.y + 10, p.z}

  params.rotation = r



  splitPotZone = spawnObject(params)

end



function splitPot9(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  splitPotObject = ob;

  splitPotPlayers = 9;



  local p = ob.getPosition()

  local r = ob.getRotation()

  local s = ob.getScale()

  params = {}

  params.type = 'ScriptingTrigger'

  params.callback = 'splitPot'

  params.scale = {s.x, 20, s.z * 1.9}

  params.position = {p.x, p.y + 10, p.z}

  params.rotation = r



  splitPotZone = spawnObject(params)

end





function splitPot10(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end



  splitPotObject = ob;

  splitPotPlayers = 10;



  local p = ob.getPosition()

  local r = ob.getRotation()

  local s = ob.getScale()

  params = {}

  params.type = 'ScriptingTrigger'

  params.callback = 'splitPot'

  params.scale = {s.x, 20, s.z * 1.9}

  params.position = {p.x, p.y + 10, p.z}

  params.rotation = r



  splitPotZone = spawnObject(params)

end





function splitPot()

  local chips = {}

  local value = 0;



  value = getChipValues(splitPotZone, chips)

  leftover = 0;

  local spawnvalue = value / splitPotPlayers



  for i, v in ipairs (chips) do

    v.destruct()

  end



  local p = splitPotObject.getPosition()

  local r = splitPotObject.getRotation()













  local xoffset = 5.5

  local zoffset = -9.8

  local pos = {}

  pos.x = p.x + (math.cos(math.rad(r.y)) * xoffset) + (math.sin(math.rad(r.y)) * zoffset)

  pos.z = p.z - (math.sin(math.rad(r.y)) * xoffset) + (math.cos(math.rad(r.y)) * zoffset)

  pos.y = p.y + 0.2

  r[2] = r.y



  local i = 0



  xoffset = 12

  zoffset = 6.5

  while i < splitPotPlayers do

    leftover = leftover + spawnChips(spawnvalue, pos, r)

    pos.x = pos.x + (math.sin(math.rad(r.y)) * zoffset)

    pos.z = pos.z + (math.cos(math.rad(r.y)) * zoffset)



    if i == 4 then

      pos.x = pos.x - (math.cos(math.rad(r.y)) * xoffset + (math.sin(math.rad(r.y)) * zoffset) * 5)

      pos.z = pos.z + (math.sin(math.rad(r.y)) * xoffset - (math.cos(math.rad(r.y)) * zoffset) * 5 )

    end





    i = i + 1

  end





  r = splitPotObject.getRotation()

  leftover = leftover + 0.1 -- avoid rounding errors for double number

  xoffset = -6.5

  zoffset = -14.8

  pos = {}

  pos.x = p.x + (math.cos(math.rad(r.y)) * xoffset) + (math.sin(math.rad(r.y)) * zoffset)

  pos.z = p.z - (math.sin(math.rad(r.y)) * xoffset) + (math.cos(math.rad(r.y)) * zoffset)

  pos.y = p.y + 0.2

  spawnChips(leftover, pos, r)





  splitPotZone.destruct()

end



function goAllIn(ob, pl)

  if ob.getDescription() ~= pl then

    return 1

  end



  if pl ~= actionon then

    return 0

  end



  local chips = {}

  getChipValues(betzones[pl], chips)

  getChipValues(tablezones[pl], chips)

  p = betzones[pl].getPosition()

  r = betzones[pl].getRotation()

  p.y = p.y - 10



  moveChips(chips, p, r)





end



function compare(a, b)

  return a[1] > b[1]

end



function goAFK(ob, pl)

  if Player[pl].admin then

    pl = ob.getDescription()

  elseif ob.getDescription() ~= pl then

    return 1

  end



  local objects = betzones[pl].getObjects()

  local x = 0

  local found = false



  for i, v in ipairs(objects) do

    if v.getName() == "AFK" then

      found = true

      v.destruct()

    end

  end

  if afkClock[pl] ~= nil then

    found = true

    afkClock[pl].destruct()

    afkClock[pl] = nil

  end



  if not found then

    local params = {}

    params.type = 'Custom_Model'

    params.position = betzones[pl].getPosition()

    params.scale = {1, 1, 1}

    params.rotation = betzones[pl].getPosition()



    local playerhand = getPlayerHandPositionAndRotation(pl)

    params.position = {playerhand['pos_x'] + playerhand['trigger_forward_x'] * 5, 1.4, playerhand['pos_z'] + playerhand['trigger_forward_z'] * 5}

    params.rotation = {0, playerhand['rot_y'], 0}

    params.callback = 'setAfkButton'

    afkButton = spawnObject(params)



    local custom = {}

    custom.mesh = 'pastebin.com/raw.php?i=qv6mnq65'

    custom.diffuse = 'http://cloud-3.steamusercontent.com/ugc/922552872558391998/0518FECF3F4FD1D5BEA34B793FE1C194EEF08483/'

    custom.type = 0



    afkButton.setCustomObject(custom)

    afkButton.setName('AFK')



    params = {}

    params.type = 'Digital_Clock'



    params.position = {playerhand['pos_x'] + playerhand['trigger_forward_x'] * 8, 0.5, playerhand['pos_z'] + playerhand['trigger_forward_z'] * 8}

    params.rotation = {90, playerhand['rot_y'], 0}



    params.callback = 'setAfkClockTimer'

    afkClock[pl] = spawnObject(params)



  end



end



function setAfkButton(ob, pl)

  ob.lock()

end



function setPlayerAfk(ob, pl)

  if pl then

    if not Player[pl].admin then

      return 1

    end

  end

  if actionon ~= nil then

    goAFK(ob, actionon)

  end

end





function setAfkClockTimer(ob, pl)

  ob.lock()

  ob.Clock.startStopwatch()

  ob.setColorTint({0.1, 0.1, 0.1})

  ob.setName("AFK")

  --afkClock[pl].lock()

  --afkClock[pl].Clock.startStopwatch()

end



function changeMachineButton1(ob, pl)

  if not converting then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 1

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end



function changeMachineButton2(ob, pl)

  if not converting then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 2

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end



function changeMachineButton3(ob, pl)

  if not converting then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 3

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end



function changeMachineButton4(ob, pl)

  if not converting then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 4

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end



function changeMachineButton5(ob, pl)

  if not converting then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 5

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end





function changeMachineButton6(ob, pl)

  if not converting then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 6

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end



function changeMachineButton7(ob, pl)

  if not convertingPlayer then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 7

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)



  end

end



function changeMachineButton8(ob, pl)

  if not convertingPlayer then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 8

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)



  end

end



function changeMachineButton9(ob, pl)

  if not convertingPlayer then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 9

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)



  end

end



function changeMachineButton10(ob, pl)

  if not convertingPlayer then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 10

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end





function changeMachineButton11(ob, pl)

  if not converting then

    clicker = player

    convertingPlayer = true

    conversionPlayerValue = 11

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end



function changeMachineButton12(ob, pl)

  if not converting then

    clicker = player

    convertingPlayer = true

    conversionPlayerValue = 12

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end



function changeMachineButton13(ob, pl)

  if not converting then

    clicker = player

    convertingPlayer = true

    conversionPlayerValue = 13

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end



function changeMachineButton14(ob, pl)

  if not converting then

    clicker = player

    convertingPlayer = true

    conversionPlayerValue = 14

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end



function changeMachineButton15(ob, pl)

  if not converting then

    clicker = player

    convertingPlayer = true

    conversionPlayerValue = 15

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end





function changeMachineButton16(ob, pl)

  if not converting then

    clicker = player

    convertingPlayer = true

    conversionPlayerValue = 16

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end



function changeMachineButton17(ob, pl)

  if not convertingPlayer then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 17

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)



  end

end



function changeMachineButton18(ob, pl)

  if not convertingPlayer then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 18

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)



  end

end



function changeMachineButton19(ob, pl)

  if not convertingPlayer then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 19

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)



  end

end



function changeMachineButton20(ob, pl)

  if not convertingPlayer then

    convertingPlayerColor = pl

    convertingPlayer = true

    conversionPlayerValue = 20

    ChangeMachineZone = spawnChangeMachineZone(ob, pl)

  end

end













function spawnChangeMachineZone(ob, pl)

  --[[spawn scripting zone on in surface--]]

  local p = ob.getPosition()

  local r = ob.getRotation()

  local s = ob.getScale()



  params = {}



  params.type = 'ScriptingTrigger'

  params.callback = 'checkChangeMachineZone'

  params.scale = {s.x * 2, 20, s.z}

  params.position = {p.x - ((s.z / 2) * math.sin(math.rad(r.y))), p.y + 9, p.z - ((s.z / 2) * math.cos(math.rad(r.y)))}

  params.rotation = ob.getRotation()



  changeMachineZone = spawnObject(params)

end



function checkChangeMachineZone()

  startLuaCoroutine(nil, 'checkChangeMachineZoneCoroutine')

end



function checkChangeMachineZoneCoroutine()

  local objects1 = changeMachineZone.getObjects()

  local positions1 = {}

  local rotations1 = {}



  for i, v in ipairs(objects1) do

    positions1[#positions1 + 1] = v.getPosition()

    rotations1[#rotations1 + 1] = v.getRotation()

  end



  for i = 1, 2 do

    coroutine.yield(0)

  end



  local objects2 = changeMachineZone.getObjects()

  local positions2 = {}

  local rotations2 = {}



  --[[ Abort if the amount of chips/stacks changed --]]

  if #objects1 ~= #objects2 then

    broadcastToColor('Conversion aborted. Please wait for chips to be at rest on the platform and try again.', convertingPlayerColor, {1, 0, 0})

    changeMachineZone.destruct()

    converting = false

    return 1

  end



  for i, v in ipairs(objects1) do

    positions2[#positions2 + 1] = v.getPosition()

    rotations2[#rotations2 + 1] = v.getRotation()

  end



  --[[ Abort if any chips/stacks are moving --]]

  for i, v in ipairs (positions1) do

    if v.x ~= positions2[i].x or v.y ~= positions2[i].y or v.z ~= positions2[i].z then

      broadcastToColor ('Conversion aborted. Please wait for chips to be at rest on the platform and try again.', convertingPlayerColor, {1, 0, 0})

      changeMachineZone.destruct()

      convertingPlayer = false

      return 1

    end



    if rotations1[i].x ~= rotations2[i].x or rotations1[i].y ~= rotations2[i].y or rotations1[i].z ~= rotations2[i].z then

      broadcastToColor ('Conversion aborted. Please wait for chips to be at rest on the platform and try again.', convertingPlayerColor, {1, 0, 0})

      changeMachineZone.destruct()

      convertingPlayer = false

      return 1

    end

  end



  local pos = changeMachineZone.getPosition()

  pos["y"] = 2

  local rot = changeMachineZone.getRotation()

  rot["y"] = (rot["y"] + 180) % 360

  local chips = {}

  money = getChipValues(changeMachineZone, chips)



  for i, v in ipairs(chips) do

    v.destruct()

  end



  convertchangeMachine(money, pos, rot, 25)



  changeMachineZone.destruct()

  convertingPlayer = false

  --calculateAndConvert()

  return 1

end







function convertchangeMachine(money, p, r, height)





  local chipstack = {}

  chipstack = initializePot()

  for i, v in pairs(chipstack) do

    v.x = p.x + (math.cos(math.rad(r.y)) * v.xoffset) + (math.sin(math.rad(r.y)) * v.zoffset)

    v.z = p.z - (math.sin(math.rad(r.y)) * v.xoffset) + (math.cos(math.rad(r.y)) * v.zoffset)

    v.y = p.y + v.yoffset + v.height

  end



  local v = {}

  v = currencies[conversionPlayerValue]

  local custom = {}

  if v.value > 0 then

    params.rotation = v.params.rotation

    params.scale = v.params.scale

    params.params = {v.name}

    local rot = {}

    rot.x = (r.x + v.params.rotation[1]) % 360

    rot.y = (r.y + v.params.rotation[2]) % 360

    rot.z = (r.z + v.params.rotation[3]) % 360

    rot[1] = rot.x

    rot[2] = rot.y

    rot[3] = rot.z

    params.rotation = rot

    if chipstack[v.stack] == nil then

      stack = "misc"

    else

      stack = v.stack

    end

    if not v.standard then

      params.type = 'Custom_Model'

      params.callback_owner = Global

      custom.mesh = v.custom.mesh

      custom.diffuse = v.custom.diffuse

      custom.type = 5

      custom.material = 1

      local i = 0

      while money >= tonumber(v.value) and i < height do

        params.position = {}

        params.position.x = chipstack[stack].x

        params.position.y = chipstack[stack].y + chipstack[stack].height

        params.position.z = chipstack[stack].z

        local obj = spawnObject(params)

        obj.setCustomObject(custom)

        obj.setName(v.name)

        money = money - v.value

        chipstack[stack].height = chipstack[stack].height + v.height

        i = i + 1

        if i >= height then

          broadcastToColor("Conversion limit reached. The difference is spawned with the least amount of chips as possible", convertingPlayerColor, {1, 1, 0})

        end

      end

    else

      params.type = 'Chip_'.. v.value

      params.callback = nil

      params.callback_owner = Global

      params.params = nil

      local i = 0

      while money >= v.value and i < height do

        params.position = {}

        params.position.x = chipstack[stack].x

        params.position.y = chipstack[stack].y + chipstack[stack].height

        params.position.z = chipstack[stack].z

        spawnObject(params)

        money = money - v.value

        chipstack[stack].height = chipstack[stack].height + v.height

        i = i + 1

        if i >= height then

          broadcastToColor("Conversion limit reached. The difference is spawned with the least amount of chips as possible", convertingPlayerColor, {1, 1, 0})

        end

      end

    end

  end



  p["y"] = 10

  spawnChips(money, p, r)

  convertingPlayer = false

end





function loadSaveBag(ob, pl)

  for i, v in ipairs(savebag.getObjects()) do



    if v.name == Player[pl].steam_name then

      local params = {}

      --params.position = Vector –Optional. Defaults to the container’s position + 2 in the x direction.

      --params.rotation = Vector –Optional. Defaults to the container’s rotation.

      params.position = tablezones[pl].getPosition()

      params.position.y = params.position.y - 8

      params.rotation = tablezones[pl].getRotation()

      params.callback_owner = Global

      --params.guid = v.guid

      params.index = v.index

      saves[pl] = savebag.takeObject(params)

      if saves[pl].getDescription() == "" then

        for i, v in ipairs (getSeatedPlayers()) do

          if Player[v].admin then

            broadcastToColor('Warning: Steamid not found on savebag for player ' .. Player[pl].steam_name, v, {1, 1, 0})

          end

        end

      elseif saves[pl].getDescription() ~= Player[pl].steam_id then

        for i, v in ipairs (getSeatedPlayers()) do

          if Player[v].admin then

            broadcastToColor('Warning: Steamid on savebag dont match the current player ' .. Player[pl].steam_name, v, {1, 1, 0})

          end

        end

      end

      return 1

    end

  end

  for i, v in ipairs (getSeatedPlayers()) do

    if Player[v].admin or v == pl then

      broadcastToColor('Warning: no save found for player ' .. Player[pl].steam_name .. '.', v, {1, 1, 0})

    end

  end

end







--[[ rPrint(struct, [limit], [indent]) Recursively print arbitrary data.

	Set limit (default 100) to stanch infinite loops.

	Indents tables as [KEY] VALUE, nested tables as [KEY] [KEY]...[KEY] VALUE

	Set indent ("") to prefix each line:    Mytable [KEY] [KEY]...[KEY] VALUE

--]]

function rPrint(s, l, i) -- recursive Print (structure, limit, indent)

  l = (l) or 100; i = i or ""; -- default item limit, indent string

  if (l < 1) then print "ERROR: Item limit reached."; return l - 1 end;

    local ts = type(s);

    if (ts ~= "table") then print (i, ts, s); return l - 1 end

    print (i, ts); -- print "table"

    for k, v in pairs(s) do -- print "[ KEY ] VALUE"

      l = rPrint(v, l, i.."\t[ "..tostring(k).." ]  ");

      if (l < 0) then break end

    end

    return l

  end



  function comma_value(n) -- credit http://richard.warburton.it

    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')

    return left..(num:reverse():gsub('(%d%d%d)', '%1,'):reverse())..right

  end



  --[[ a crude conversion function to convert a currency to a number. DOES NOT ACCOUNT FOR NEGATIVE NUMBERS. accounts for decimals (for example,  a crude conversion function to convert a currency to a number. DOES NOT ACCOUNT FOR NEGATIVE NUMBERS. accounts for decimals (for example, $2.50), but will return nil if multiple dots are found, as a valid number would only have one (using american formatting anyway). does not account for other characters, however, so a random string of mixed up numbers and letters will return a value. --]]

  function currencyToNumber(s)

    local value = 0 -- the value is updated as numbers are found in the string

    local dec = 1 -- the decimal places (is that the right term?), multiplied by 10 each time a number is found

    local decimalfound = false -- the first time a decimal point is found, used to check for invalid number strings if it finds multiple decimal points (like an ip address)

    local r = string.reverse(s) -- reverse the original string to simplify analysis

    for i = 1, string.len(r) do

      if tonumber(string.sub(r, i, i)) then -- if the character is a number, add its value times the decimal places to the 'value' variable

        value = value + (tonumber(string.sub(r, i, i)) * dec)

        dec = dec * 10

      elseif string.sub(r, i, i) == '.' then -- if the character is a decimal point, divide the value by the decimal places and reset the 'dec' variable to 1

        if decimalfound then return nil end

        value = value / dec

        dec = 1

        decimalfound = true

      end

    end

    if value ~= 0 then return value else return nil end -- return the value if it's not still 0, otherwise return nil

  end

