#include <iostream>
#include "monero_flutter.h"

int main(int argc, char** argv)
{
    const char *path = "/Users/dmytro/Documents/test_wallets/wallet1";
    const char *seed = "point nerves ungainly gather loudly theatrics october misery aphid website attire erected shelter ouch hesitate nouns suede omnibus folding last fruit upbeat haystack hedgehog gather";
    
    bool wallet_exists = is_wallet_exist(path);
	std::cout << "wallet_exists=" << wallet_exists << std::endl;
    
    ErrorBox error;
    restore_wallet_from_seed(path, "", seed, 0, &error);
    
	return 0;
}
