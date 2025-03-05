// Single global list to track collection card objects
var/global/list/collection_card_objects = list()

// Single card object type for all cards
/obj/item/card/collection_card
    name = "Yu-Gi-Oh Card"
    desc = "A trading card from the Yu-Gi-Oh trading card game."
    icon = 'yugioh_cards_1.dmi'
    var/datum/yugioh_card/card_data

    Click()
        ..()  // Call parent Click()
        if(!usr || !usr.client)
            return
        display_card_info()

    DblClick()
        ..()
        if(!usr || !usr.client)
            return

        var/mob/M = usr
        // Check if card is in collection
        if(M.card_collection.cards.Find(src))
            // Remove from collection
            M.card_collection.cards -= src

            // Add to appropriate deck based on type
            if(card_data.card_type in list("Synchro Monster", "Fusion Monster"))
                M.extra_deck.cards += src
                M << "[src.name] added to Extra Deck."
            else
                M.main_deck.cards += src
                M << "[src.name] added to Main Deck."

            // Update both grids
            M.update_collection_window()
            M.update_deck_window()
            M.update_extra_deck_window()
            return

        // Check if card is in main deck
        if(M.main_deck.cards.Find(src))
            M.main_deck.cards -= src
            M.card_collection.cards += src
            M << "[src.name] returned to Collection."
            M.update_collection_window()
            M.update_deck_window()
            return

        // Check if card is in extra deck
        if(M.extra_deck.cards.Find(src))
            M.extra_deck.cards -= src
            M.card_collection.cards += src
            M << "[src.name] returned to Collection."
            M.update_collection_window()
            M.update_extra_deck_window()
            return

    proc/display_card_info()
        if(!usr || !usr.client)
            return

        // Show the window
        winshow(usr, "card_info", 1)
        
        // Set background color and image based on card type
        var/background_color
        var/background_image
        var/star_image
        switch(card_data.card_type)
            if("Effect Monster")
                background_color = "#bc6e40"  // Bronze color for effect monsters
                background_image = 'frames/monster.png'
                star_image='frames/effectmonsterstar.png'
            if("Normal Monster")
                background_color = "#bc6e40"  // Orange-yellow for normal monsters
                background_image = 'frames/monster.png'
                star_image='frames/effectmonsterstar.png'
            if("Fusion Monster")
                background_color = "#92509c"  // Purple for fusion monsters
                background_image = 'frames/fusion_monster.png'
                star_image='frames/fusionmonsterstar.png'
            if("Synchro Monster")
                background_color = "#dededc"  // White for synchro monsters
                background_image = 'frames/synchro_monster.png'
                star_image='frames/synchromonsterstar.png'
            if("Ritual Monster")
                background_color = "#5478b7"  // Royal blue for ritual monsters
                background_image = 'frames/ritual_monster.png'
                star_image='frames/ritualmonsterstar.png'
            if("Spell Card")
                background_color = "#32CD32"  // Green for spell cards
                background_image = 'frames/spell_card.png'
            if("Trap Card")
                background_color = "#FF69B4"  // Pink for trap cards
                background_image = 'frames/trap_card.png'
            else
                background_color = "#bc6e40"  // Default to normal monster color
                background_image = 'frames/monster.png'
        
        // Set the background color and image
        winset(usr, "card_info.card_frame", "image=[background_image]")
        // You might need to add more elements depending on your interface structure
        
        // Output basic info that all cards have
        usr << output(name, "card_info.card_name")
        usr << output(desc, "card_info.effect_text")
        usr << output("[card_data.humanReadableCardType]", "card_info.card_type")

        // Handle monster-specific elements
        if(card_data.card_type in list("Effect Monster", "Normal Monster", "Synchro Monster", "Fusion Monster", "Ritual Monster"))
            // Show monster-specific elements
            winset(usr, "card_info.attribute_icon", "is-visible=true")
            winset(usr, "card_info.atk_label", "is-visible=true")
            winset(usr, "card_info.def_label", "is-visible=true")
            
            // Output monster stats
            usr << output(icon('stars_and_attributes.dmi', "[lowertext(card_data.attribute)]_attribute"), "card_info.attribute_icon")
            usr << output("ATK/[card_data.atk]", "card_info.atk_label")
            usr << output("DEF/[card_data.def]", "card_info.def_label")
            
            // Handle level stars
            for(var/i = 1 to 12)
                var/star_elem = "card_info.star[i]"
                if(i <= card_data.level)
                    winset(usr, "card_info.star[i]", "is-visible=true")
                    winset(usr, "card_info.star[i]", "background-color=[background_color]")
                    winset(usr, "card_info.star[i]", "image=[star_image]")
                else
                    winset(usr, star_elem, "is-visible=false")
        else
            // Hide monster-specific elements for Spells/Traps
            winset(usr, "card_info.attribute_icon", "is-visible=false")
            winset(usr, "card_info.atk_label", "is-visible=false")
            winset(usr, "card_info.def_label", "is-visible=false")
            
            // Hide starstab and all level stars
            winset(usr, "card_info.starstab", "is-visible=false")
            for(var/i = 1 to 12)
                winset(usr, "card_info.star[i]", "is-visible=false")

// Simplified card creation proc
/proc/create_card_object(datum/yugioh_card/data, turf/location)
    if(!data || !location)
        return null

    var/obj/item/card/collection_card/card = new(location)
    card.card_data = data
    card.name = data.card_name
    card.desc = data.description
    card.icon = data.icon
    card.icon_state = data.icon_state

    // Add to main collection list
    collection_card_objects += card

    return card

// Collection datum to store cards
/datum/card_collection
    var/list/cards = list()

// Add deck references to mobs
/mob
    var/datum/card_collection/card_collection
    var/datum/card_collection/main_deck
    var/datum/card_collection/extra_deck

// Initialize collections for new mobs
/mob/New()
    ..()
    card_collection = new
    main_deck = new
    extra_deck = new

// Update display procs
/mob/proc/update_collection_window()
    if(!client)
        return
    // Clear all cells first
    for(var/i = 1 to card_collection.cards.len + 1)  // +1 to ensure we clear the last cell
        src << output(null, "collection.collectiongrid:1,[i]")
    winset(src, "collection.collectiongrid", "cells=1x[card_collection.cards.len]")
    for(var/i = 1 to card_collection.cards.len)
        var/obj/item/card/collection_card/card = card_collection.cards[i]
        src << output(card, "collection.collectiongrid:1,[i]")

// Update deck display
/mob/proc/update_deck_window()
    if(!client)
        return
    // Clear all cells first
    for(var/i = 1 to main_deck.cards.len + 1)  // +1 to ensure we clear the last cell
        src << output(null, "collection.deckgrid:1,[i]")
    winset(src, "collection.deckgrid", "cells=1x[main_deck.cards.len]")
    for(var/i = 1 to main_deck.cards.len)
        var/obj/item/card/collection_card/card = main_deck.cards[i]
        src << output(card, "collection.deckgrid:1,[i]")

// Update extra deck display
/mob/proc/update_extra_deck_window()
    if(!client)
        return
    // Clear all cells first
    for(var/i = 1 to extra_deck.cards.len + 1)  // +1 to ensure we clear the last cell
        src << output(null, "collection.extradeckgrid:1,[i]")
    winset(src, "collection.extradeckgrid", "cells=1x[extra_deck.cards.len]")
    for(var/i = 1 to extra_deck.cards.len)
        var/obj/item/card/collection_card/card = extra_deck.cards[i]
        src << output(card, "collection.extradeckgrid:1,[i]")

// Collection viewing verb
/mob/verb/view_collection()
    set name = "View Card Collection"
    set category = "Cards"
    winshow(src, "collection", 1)  // Show the collection window
    update_collection_window()
    update_extra_deck_window()
    update_deck_window()
    
// Add to collection verb
/obj/item/card/collection_card/verb/add_to_collection()
    set name = "Add to Collection"
    set category = "Object"
    set src in view(1)

    var/mob/M = usr
    if(!M.card_collection)
        M.card_collection = new

    M.card_collection.cards += src
    src.loc = null  // Remove from game world
    M << "[src.name] has been added to your collection."
    M.update_collection_window()  // Update the display

// Modified spawn verb to use new card creation system
/client/verb/spawn_yugioh_card()
    set name = "Spawn Yu-Gi-Oh Card"
    set category = "Debug"

    if(!yugioh_cards.len)
        src << "No cards available."
        return

    var/search = input(usr, "Search for a card (leave blank to show all):", "Search Cards") as null|text
    if(isnull(search))
        return

    var/list/card_choices = list()
    for(var/datum/yugioh_card/card in yugioh_cards)
        if(!search || findtext(lowertext(card.card_name), lowertext(search)))
            card_choices[card.card_name] = card

    if(!card_choices.len)
        src << "No cards found matching your search."
        return

    var/choice = input(usr, "Select a card to spawn:", "Spawn Card") as null|anything in card_choices
    if(!choice)
        return

    var/obj/item/card/collection_card/new_card = create_card_object(card_choices[choice], usr.loc)
    if(new_card)
        src << "Spawned [choice]."
    else
        src << "Failed to spawn [choice]."