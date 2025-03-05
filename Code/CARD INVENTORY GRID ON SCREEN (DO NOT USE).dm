// Card inventory datum to track player's cards
/datum/card_inventory
    var/mob/owner
    var/list/cards = list()              // List of card datums
    var/list/card_objects = list()       // List of card objects on screen
    var/cards_per_row = 5               // How many cards to show per row
    var/card_spacing = 32               // Pixels between cards
    var/current_page = 1               // Current page of cards being viewed
    var/cards_per_page = 25            // Cards shown per page (5x5 grid)

// Inventory card object that appears on screen
/obj/screen/inventory_card
    var/datum/yugioh_card/card_data
    icon = 'icons/ui/inventory.dmi'  // You'll need to create this icon file
    icon_state = "card_back"
    var/datum/card_inventory/parent_inventory

    MouseEntered(location, control, params)
        // Show tooltip with card info
        usr << browse({"
            <div style='background-color: #ffffff; padding: 5px; border: 1px solid #000000;'>
                <strong>[card_data.card_name]</strong><br>
                <em>[card_data.card_type]</em><br>
                [card_data.description]
            </div>
        "}, "window=cardtooltip;size=300x200")

    MouseExited()
        usr << browse(null, "window=cardtooltip")

    Click(location, control, params)
        parent_inventory.card_clicked(src)

// Add inventory datum to mob
/mob
    var/datum/card_inventory/card_inventory

// Initialize inventory
/mob/New()
    ..()
    card_inventory = new
    card_inventory.owner = src

// Add a card to inventory
/datum/card_inventory/proc/add_card(datum/yugioh_card/card)
    cards += card
    update_inventory_display()

// Remove a card from inventory
/datum/card_inventory/proc/remove_card(datum/yugioh_card/card)
    cards -= card
    update_inventory_display()

// Update the visual display of cards
/datum/card_inventory/proc/update_inventory_display()
    // Clear existing card objects
    for(var/obj/screen/inventory_card/C in card_objects)
        owner.client.screen -= C
    card_objects.Cut()

    // Calculate page bounds
    var/start_index = (current_page - 1) * cards_per_page + 1
    var/end_index = min(start_index + cards_per_page - 1, cards.len)

    // Create new card objects for current page
    for(var/i = start_index to end_index)
        var/datum/yugioh_card/card = cards[i]
        var/obj/screen/inventory_card/card_obj = new
        card_obj.card_data = card
        card_obj.icon = card.icon
        card_obj.icon_state = card.icon_state
        card_obj.parent_inventory = src

        // Calculate grid position
        var/relative_index = i - start_index
        var/row = round(relative_index / cards_per_row)
        var/col = relative_index % cards_per_row

        // Set screen location
        // Position cards in center of screen, offset upwards from bottom
        // Using SOUTH notation for vertical position, starting 3 tiles up from bottom
        card_obj.screen_loc = "CENTER-[round(cards_per_row/2)]+[col],SOUTH+[row+3]"

        card_objects += card_obj
        owner.client.screen += card_obj

// Handle clicking on a card
/datum/card_inventory/proc/card_clicked(obj/screen/inventory_card/clicked_card)
    // Add your card interaction logic here
    // For example, selecting cards for playing, trading, etc.
    owner << "Selected card: [clicked_card.card_data.card_name]"

// Navigation controls
/datum/card_inventory/proc/next_page()
    var/max_pages = ceil(cards.len / cards_per_page)
    if(current_page < max_pages)
        current_page++
        update_inventory_display()

/datum/card_inventory/proc/prev_page()
    if(current_page > 1)
        current_page--
        update_inventory_display()

// Verb to test adding cards to inventory
/mob/verb/add_test_cards()
    set name = "Add Test Cards"
    set category = "Cards"

    if(!yugioh_cards.len)
        load_yugioh_cards()

    // Add some random cards for testing
    for(var/i in 1 to 10)
        var/datum/yugioh_card/random_card = pick(yugioh_cards)
        card_inventory.add_card(random_card)

// Verb to show/refresh inventory
/mob/verb/show_card_inventory()
    set name = "Show Card Inventory"
    set category = "Cards"

    card_inventory.update_inventory_display()