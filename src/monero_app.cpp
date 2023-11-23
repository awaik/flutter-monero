#include <iostream>
#include <unistd.h>
#include "monero_flutter.h"

int main(int argc, char** argv)
{
    const char *path = "/Users/dmytro/Documents/test_wallets/moneroWalletVer3";
    //const char *seed = "point nerves ungainly gather loudly theatrics october misery aphid website attire erected shelter ouch hesitate nouns suede omnibus folding last fruit upbeat haystack hedgehog gather";
    
    bool wallet_exists = is_wallet_exist(path);
	std::cout << "wallet_exists=" << wallet_exists << std::endl;
    
    ErrorBox error;
    
    //restore_wallet_from_seed(path, "", seed, 0, &error);
    
    load_wallet(path, "", 0, &error);
    
    auto address = get_address(0, 0, &error);
    std::cout << "address=" << address << std::endl;
    
    setup_node("xmrno.de:18089", "", "", &error);
    
    start_refresh(&error);
    
    store(&error);
    
    while (true)
    {
        auto syncing_height = get_syncing_height(&error);
        std::cout << "syncing_height=" << syncing_height << std::endl;
        sleep(1);
    }
    
	return 0;
}
