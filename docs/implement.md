---
layout: page
title: Implement
permalink: /implement/
---

### Creating a “Diamond Hands” Contract using Chronicle Oracle
Now that we have a <a href="{{ '/get_started' | relative_url }}">working scaffold-eth2 framework</a> connected to the Chronicle Scribe Oracle on Sepolia, we can build a contract that will actually use the information provided to us by the Oracle! 

Our smart contract will have a simple function: A user can deposit funds into the contract and declare a price in USD which they believe (or want) Eth to reach. The deposited funds will stay locked in the smart contract unless the Chronicle ETH_USD oracle reports that the price of Eth is above the set minimum. If the Chronicle price exceeds the minimum set by the user, they’ll be able to withdraw. If not, they’ll need to keep holding with their diamond hands (and the help of this smart contract).
<br />
<br />

---

#### Variables

We need a way to track the minimum price and the real Chronicle-reported price.
```solidity
uint256 public minimumPrice = 0;
uint256 public chroniclePrice = 0;
```

#### Functions
In order to get the real price of Eth into the smart contract, we need to use Chronicle’s Oracle. Here’s an example that **reads the value** and also stores it as a variable. *Note: since this function makes an edit to the state instead of just reading, it will cost gas.*
```solidity
// sets the chroniclePrice variable to the read value, then returns it
function getChroniclePrice() public returns (uint256) {
  chroniclePrice = chronicle.read();
  return chroniclePrice;
}
```

We need a way for the user to **deposit funds** into the contract and also **set the minimumPrice**. We’ll repurpose the Scaffold-Eth default function setGreeting and event greetingSetter to use our variable of minimumPrice instead:
```solidity
  event minimumPriceChange(
    address indexed priceSetter, uint256 newMinimumPrice, uint256 value
  );

  function setMinimumPrice(uint256 _newMinimumPrice) public payable {
    require(
      _newMinimumPrice > minimumPrice,
      "New minimum must be an increase from the current minimum"
    );
    console.logString("Setting new minimum price");
    console.logString(Strings.toString(_newMinimumPrice))
    minimumPrice = _newMinimumPrice;

    emit minimumPriceChange(msg.sender, _newMinimumPrice, msg.value);
  }
  ```

  Finally, we need a **withdraw function** which checks whether the Chronicle Oracle price has exceeded the minimum, and transfer the funds if so.
  ```solidity
    function withdraw() public onlyOwner {
    uint256 balance = address(this).balance;
    require(balance > 0, "No ether available to withdraw");
    chroniclePrice = chronicle.read();
    require(
      chroniclePrice >= minimumPrice,
      "Chronicle price is less than the minimum price! Keep holding!"
    );
    payable(owner()).transfer(balance);
  }
  ```

Hopefully these functions are enough to get you started on building our Diamond Hands holding smart contract powered by Chronicle’s Scribe Oracle. If you’d like to see a full code example using the above functions, <a href="https://github.com/hehozo/DiamondHands">you can find it here.</a>