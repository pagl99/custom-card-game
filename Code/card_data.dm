// Card datum definition
/datum/yugioh_card
    var/card_id
    var/card_name
    var/card_type
    var/humanReadableCardType    // New variable for human readable card type
    var/description
    var/icon
    var/icon_state
    var/level      // For monster card level
    var/atk        // New variable for attack points
    var/def        // New variable for defense points
    var/race       // New variable for card race
    var/attribute  // New variable for card attribute

// Global list for cards
var/global/list/yugioh_cards = list()

// Simplified helper proc without multi-file handling
/proc/find_card_icon(icon_state)
    var/icon_file = 'yugioh_cards_1.dmi'
    return list(icon_file, icon_states(icon_file).Find(icon_state))

// Modified load proc with improved error handling and new fields
/proc/load_yugioh_cards()
    var/json_text = file2text("cards.json")
    if(!json_text)
        world.log << "ERROR: Failed to load cards.json"
        return

    var/list/json_data
    try
        json_data = json_decode(json_text, ascii2text(34))
    catch(var/exception/e)
        world.log << "ERROR: Failed to decode JSON: [e]"
        return

    yugioh_cards.Cut()

    for(var/list/card_data in json_data)
        var/datum/yugioh_card/card = new
        card.card_id = "[card_data["id"]]"  // Keep as string
        card.card_name = card_data["name"]
        card.card_type = card_data["type"]
        card.description = card_data["desc"]
        card.humanReadableCardType = card_data["humanReadableCardType"]
        card.atk = text2num(card_data["atk"])  // Convert to number
        card.def = text2num(card_data["def"])  // Convert to number
        card.race = card_data["race"]          // Add race field
        card.attribute = card_data["attribute"] // Add attribute field
        if(card_data["level"])
            card.level = card_data["level"]


        card.icon_state = lowertext(card.card_name)
        card.icon_state = replacetext(card.icon_state, "b.e.s.", "bes_")    // Handle B.E.S. cards
        card.icon_state = replacetext(card.icon_state, "/assault mode", "assault_mode")  // Handle Assault Mode cards
        card.icon_state = replacetext(card.icon_state, " ", "_")     // Spaces to underscores
        card.icon_state = replacetext(card.icon_state, "'", "")      // Remove apostrophes
        card.icon_state = replacetext(card.icon_state, "\"", "")     // Remove quotes
        card.icon_state = replacetext(card.icon_state, "!", "")      // Remove exclamation marks
        card.icon_state = replacetext(card.icon_state, "?", "")      // Remove question marks
        card.icon_state = replacetext(card.icon_state, ":", "")      // Remove colons
        card.icon_state = replacetext(card.icon_state, ",", "")      // Remove commas
        card.icon_state = replacetext(card.icon_state, ".", "")      // Remove periods
        card.icon_state = replacetext(card.icon_state, "#", "")      // Remove hash symbols
        card.icon_state = replacetext(card.icon_state, "/", "")      // Remove forward slashes
        card.icon_state = replacetext(card.icon_state, "-", "_")     // Hyphens to underscores
        card.icon_state = replacetext(card.icon_state, "&", "")      // Remove ampersands
        card.icon_state = replacetext(card.icon_state, "=", "")      // Remove equals signs
        card.icon_state = replacetext(card.icon_state, "ü", "u")     // Replace ü with u
        card.icon_state = replacetext(card.icon_state, "ür", "r")    // Replace ür with r
        card.icon_state = replacetext(card.icon_state, "α", "a")     // Replace α with a
        card.icon_state = replacetext(card.icon_state, "%", "")      // Remove percent signs

        // Clean up multiple underscores
        while(findtext(card.icon_state, "__"))
            card.icon_state = replacetext(card.icon_state, "__", "_")

        // Find icon in single DMI file
        var/list/icon_result = find_card_icon(card.icon_state)
        if(!icon_result[2]) {  // Icon not found
            card.icon_state = "missing_card"
        }

        // Load the actual icon data
        src << "DEBUG: Loading icon for [card.card_name]"
        src << "DEBUG: Using icon_state: [card.icon_state]"
        src << "DEBUG: Icon file exists: [fexists(icon_result[1])]"
        card.icon = icon(icon_result[1], card.icon_state)
        src << "DEBUG: Icon loaded: [card.icon ? "YES" : "NO"]"

        yugioh_cards += card


// World initialization
/world/New()
    ..()
    load_yugioh_cards()