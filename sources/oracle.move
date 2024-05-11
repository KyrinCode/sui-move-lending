module lending::oracle {

    //==============================================================================================
    // Dependencies
    //==============================================================================================

    public struct PriceFeed has key {
        id: UID, 
        prices: vector<u64>,
        decimals: vector<u8>
    }

    public fun init_module(ctx: &mut TxContext) {
        transfer::share_object(
            PriceFeed {
                id: object::new(ctx),
                prices: vector::empty(),
                decimals: vector::empty()
            }
        );
    }

    public fun add_new_coin(
        price: u64,
        decimals: u8,
        feed: &mut PriceFeed
    ) {
        vector::push_back(&mut feed.prices, price);
        vector::push_back(&mut feed.decimals, decimals);
    }

    public fun update_price(
        new_price: u64,
        coin_number: u64,
        feed: &mut PriceFeed
    ) {
        let existing_price = vector::borrow_mut(&mut feed.prices, coin_number);
        *existing_price = new_price;
    }

    public fun get_price_and_decimals(
        coin_number: u64,
        feed: &PriceFeed
    ): (u64, u8) {
        (*vector::borrow(&feed.prices, coin_number), *vector::borrow(&feed.decimals, coin_number))
    }
}