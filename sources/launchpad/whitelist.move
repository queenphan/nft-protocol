module nft_protocol::whitelist {
    use sui::transfer;
    use sui::object::{Self, ID , UID};
    use sui::tx_context::{Self, TxContext};
    
    use nft_protocol::err;
    use nft_protocol::sale::{Self, Sale};
    use nft_protocol::slingshot::{Self, Slingshot};

    struct Whitelist has key {
        id: UID,
        sale_id: ID,
    }

    public fun whitelist_address<T, Market>(
        launchpad: &Slingshot<T, Market>,
        sale: &Sale<T, Market>,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        assert!(
            tx_context::sender(ctx) == slingshot::admin(launchpad),
            err::wrong_launchpad_admin()
        );
        let sale_id = sale::id(sale);
        
        let whitelisting = Whitelist {
            id: object::new(ctx),
            sale_id: sale_id,
        };

        transfer::transfer(
            whitelisting,
            recipient,
        );
    }

    public fun burn_whitelist_token(
        whitelist_token: Whitelist,
    ) {
        let Whitelist {
            id,
            sale_id: _,
        } = whitelist_token;

        object::delete(id);
    }

    public fun sale_id(
        whitelist_token: &Whitelist,
    ): ID {
        whitelist_token.sale_id
    }
}