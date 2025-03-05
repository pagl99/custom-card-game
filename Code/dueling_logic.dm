// ==========================================
// CARD TYPES
// ==========================================

// Base card type that all cards inherit from
/obj/card
    name = "Card"
    icon = 'yugioh_cards_1.dmi'
    var/datum/yugioh_card/card_data
    mouse_opacity = 1
    var/location
    var/stored_icon
    var/stored_icon_state
    var/stored_name
    var/face_state = "up"
    var/current_zone

// ----- Monster Cards -----
/obj/card/monster
    name = "Monster Card"
    var/position_state


/obj/card/monster/fusion
    name = "Fusion Monster"

/obj/card/monster/synchro
    name = "Synchro Monster"

/obj/card/monster/ritual
    name = "Ritual Monster"

// ----- Spell & Trap Cards -----
/obj/card/spell
    name = "Spell Card"

/obj/card/trap
    name = "Trap Card"

// ==========================================
// DECK DISPLAY SYSTEM
// ==========================================

/obj/duel_deck_display
    name = "Deck"
    icon = 'card_back.dmi'
    icon_state = "back"
    
    New()
        ..()
        icon_state = "back"
    layer = 20
    plane = 0
    var/mob/owner
    mouse_opacity = 1

    Click()
        ..()
        if(!usr || !usr.client) return
        
        var/mob/M = usr
        if(M.duel_main_deck?.cards.len > 0)
            M.draw_card()
        else
            usr << "No cards left in deck!"

// ==========================================
// DECK MANAGEMENT
// ==========================================

/datum/duel_deck
    var/mob/owner
    var/list/obj/card/cards = list()
    var/obj/duel_deck_display/deck_display

    New(mob/O)
        owner = O
        deck_display = new()
        deck_display.owner = O

    // ----- Card Creation Methods -----
    proc/create_card(obj/item/card/collection_card/C)
        var/obj/card/D
        var/type_lower = lowertext(C.card_data.card_type)
        
        if(findtext(type_lower, "fusion"))
            D = new /obj/card/monster/fusion()
        else if(findtext(type_lower, "synchro"))
            D = new /obj/card/monster/synchro()
        else if(findtext(type_lower, "ritual"))
            D = new /obj/card/monster/ritual()
        else if(findtext(type_lower, "spell"))
            D = new /obj/card/spell()
        else if(findtext(type_lower, "trap"))
            D = new /obj/card/trap()
        else if(findtext(type_lower, "monster"))
            D = new /obj/card/monster()
        
        if(D)
            D.card_data = C.card_data
            D.name = C.card_data.card_name
            D.icon_state = C.card_data.icon_state
            D.desc = C.card_data.description
            cards += D

    proc/create_from_collection(datum/card_collection/collection_deck)
        for(var/obj/item/card/collection_card/C in collection_deck.cards)
            create_card(C)

    // ----- Deck Operations -----
    proc/shuffle_deck()
        var/list/temp_deck = cards.Copy()
        cards.Cut()
        
        while(temp_deck.len > 0)
            var/picked_index = rand(1, temp_deck.len)
            cards += temp_deck[picked_index]
            temp_deck.Cut(picked_index, picked_index + 1)
            
        owner << "Your deck has been shuffled ([cards.len] cards)."

    // ----- Display Management -----
    proc/position_deck_display()
        if(!usr.client)
            return
            
        if(!deck_display)
            deck_display = new()
            deck_display.owner = owner
            deck_display.icon_state = "back"
            
        deck_display.screen_loc = "3,8"
        deck_display.layer = 20
        deck_display.plane = 1
        deck_display.icon_state = "back"
        usr.client.screen += deck_display

// ==========================================
// MOB FUNCTIONALITY
// ==========================================

/mob
    var/datum/duel_deck/duel_main_deck
    var/datum/duel_deck/duel_extra_deck
    var/list/obj/card/hand = list()

    // ----- Card Operations -----
    proc/draw_card()
        if(!duel_main_deck?.cards.len)
            return
            
        var/obj/card/drawn_card = duel_main_deck.cards[1]
        duel_main_deck.cards.Cut(1, 2)
        drawn_card.owner = src  // Add this line here
        drawn_card.location = "hand"
        hand += drawn_card
        update_hand_display()
        src << "You drew [drawn_card.name]!"
        
        if(!duel_main_deck.cards.len)
            duel_main_deck.deck_display.icon_state = "empty"

    // ----- Deck Management -----
    proc/create_duel_decks()
        src << "Creating duel decks for [src]"
        duel_main_deck = new(src)
        duel_extra_deck = new(src)
        
        duel_main_deck.create_from_collection(main_deck)
        duel_extra_deck.create_from_collection(extra_deck)

    proc/sync_duel_decks()
        if(!duel_main_deck || !duel_extra_deck)
            create_duel_decks()
            return

        duel_main_deck.cards.Cut()
        duel_main_deck.create_from_collection(main_deck)
        
        duel_extra_deck.cards.Cut()
        duel_extra_deck.create_from_collection(extra_deck)

// ==========================================
// VERBS
// ==========================================

/mob/verb/initiate_duel()
    set name = "DUEL!"
    set category = "Duel"
    hand = list()
    
    world << "[usr] raises their duel disk!"
    sync_duel_decks()

    if(!duel_main_deck)
        usr << "Error: No duel deck exists after sync"
        return
        
    duel_main_deck.position_deck_display()
    clear_duel_field()
    create_duel_field()
    shuffle_deck()

/mob/verb/end_duel()
    set name = "DEBUG END DUEL"
    set category = "Duel"
    clear_duel_field()

/mob/verb/show_deck_order()
    set name = "Show Deck Order"
    set category = "Duel"

    if(!duel_main_deck || !duel_extra_deck)
        create_duel_decks()

    src << "\n=== MAIN DECK (Top to Bottom) ==="
    var/card_num = 1
    for(var/obj/card/C in duel_main_deck.cards)
        src << "[card_num]. [C.name]"
        card_num++

    src << "\n=== EXTRA DECK ==="
    card_num = 1
    for(var/obj/card/C in duel_extra_deck.cards)
        src << "[card_num]. [C.name]"
        card_num++

/mob/verb/shuffle_deck()
    set name = "Shuffle Deck"
    set category = "Duel"

    if(!duel_main_deck)
        create_duel_decks()
        
    duel_main_deck.shuffle_deck()


/mob/proc/update_hand_display()
    // First remove any existing card displays
    if(client)
        for(var/obj/card/C in client.screen)
            client.screen -= C
            
    // Calculate starting position (leftmost card)
    var/cards_in_hand = hand.len
    var/card_width = 64  // Changed to 64 for larger spacing
    var/total_width = cards_in_hand * card_width
    var/start_x = -(total_width/2)
    
    // Place each card
    var/i = 0
    for(var/obj/card/C in hand)
        var/x_pos = start_x + (i * card_width)
        C.screen_loc = "CENTER:[x_pos],8"
        // Scale the card to 64x64 and store as original transform
        C.original_transform = matrix() * 2  // Store the scaled matrix
        C.transform = C.original_transform   // Apply it
        C.pixel_y = 0  // Reset base position
        client.screen += C
        i++

/obj/card
    var/is_hovering = FALSE
    var/mob/owner
    var/base_y = 8
    var/matrix/original_transform
    
    MouseEntered()
        if(!is_hovering && (src in owner.hand))
            is_hovering = TRUE
            
            // Create a new matrix based on the original (scaled) transform
            var/matrix/M = original_transform * 1  // Multiply by 1 to create a copy
            // Add the translation while preserving the scale
            M.Translate(0, 16)
            
            // Animate the transition
            animate(src, transform = M, time = 3, easing = SINE_EASING)

    MouseExited()
        if(is_hovering)
            is_hovering = FALSE
            
            // Animate back to original scaled position
            animate(src, transform = original_transform, time = 3, easing = SINE_EASING)