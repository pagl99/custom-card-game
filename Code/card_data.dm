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

// Improved browse proc with proper icon handling
/mob/verb/browse_yugioh_cards()
    set name = "Browse Yugioh Cards"
    set category = "Cards"

    if(!yugioh_cards.len)
        load_yugioh_cards()
        if(!yugioh_cards.len)
            src << "No cards available."
            return

    var/list/card_names = list()
    for(var/datum/yugioh_card/card in yugioh_cards)
        card_names[card.card_name] = card

    var/choice = input(src, "Select a card to view:", "Yugioh Cards") as null|anything in card_names
    if(!choice)
        return

    var/datum/yugioh_card/selected_card = card_names[choice]

    // Create a formatted message for chat output
    var/chat_message = {"
======================
[selected_card.card_name]
======================
ID: [selected_card.card_id]
Type: [selected_card.card_type]
Human Readable Type: [selected_card.humanReadableCardType]
[selected_card.race ? "Race: [selected_card.race]" : ""]
[selected_card.attribute ? "Attribute: [selected_card.attribute]" : ""]
[selected_card.level ? "Level: [selected_card.level]" : ""]
[selected_card.atk != null ? "ATK: [selected_card.atk]" : ""]
[selected_card.def != null ? "DEF: [selected_card.def]" : ""]

Description:
[selected_card.description]
======================"}

    // Send the formatted message to chat
    src << chat_message

    // Optional: Also show the HTML window with more detailed formatting
    var/html_start = {"<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 10px;
            background-color: #f0f0f0;
        }
        .card-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
        }
        .card-image {
            text-align: center;
            margin-bottom: 20px;
        }
        .card-image img {
            max-width: 100%;
            height: auto;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .card-details {
            margin-top: 20px;
            line-height: 1.6;
        }
        .card-label {
            font-weight: bold;
            color: #444;
        }
        .card-value {
            color: #666;
        }
    </style>
</head>
<body>"}
    var/html_end = {"</body>
</html>"}

    var/card_content = {"<div class='card-container'>
        <div class='card-details'>
            <div><span class='card-label'>Card ID:</span> <span class='card-value'>[selected_card.card_id]</span></div>
            <div><span class='card-label'>Name:</span> <span class='card-value'>[selected_card.card_name]</span></div>
            <div><span class='card-label'>Type:</span> <span class='card-value'>[selected_card.card_type]</span></div>
            <div><span class='card-label'>Human Readable Type:</span> <span class='card-value'>[selected_card.humanReadableCardType]</span></div>
            [selected_card.race ? "<div><span class='card-label'>Race:</span> <span class='card-value'>[selected_card.race]</span></div>" : ""]
            [selected_card.attribute ? "<div><span class='card-label'>Attribute:</span> <span class='card-value'>[selected_card.attribute]</span></div>" : ""]
            [selected_card.level ? "<div><span class='card-label'>Level:</span> <span class='card-value'>[selected_card.level]</span></div>" : ""]
            [selected_card.atk != null ? "<div><span class='card-label'>ATK:</span> <span class='card-value'>[selected_card.atk]</span></div>" : ""]
            [selected_card.def != null ? "<div><span class='card-label'>DEF:</span> <span class='card-value'>[selected_card.def]</span></div>" : ""]
            <div><span class='card-label'>Description:</span> <span class='card-value'>[selected_card.description]</span></div>
        </div>
    </div>"}

    var/complete_html = html_start + card_content + html_end
    src << browse(complete_html, "window=cardinfo;size=400x600")

// World initialization
/world/New()
    ..()
    load_yugioh_cards()