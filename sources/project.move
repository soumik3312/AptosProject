module MyModule::RideSharing {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct Ride has store, key {
        fare: u64,      // Ride fare in tokens
        completed: bool, // Ride completion status
    }

    public fun register_ride(rider: &signer, fare: u64) {
        let ride = Ride {
            fare,
            completed: false,
        };
        move_to(rider, ride);
    }

    public fun complete_ride(driver: &signer, rider_address: address) acquires Ride {
        let ride = borrow_global_mut<Ride>(rider_address);
        assert(!ride.completed, 1);

        let payment = coin::withdraw<AptosCoin>(&signer, ride.fare);
        coin::deposit<AptosCoin>(signer::address_of(driver), payment);
        
        ride.completed = true;
    }
}