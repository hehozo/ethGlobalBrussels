pragma solidity >=0.8.0 <0.9.0;

import "forge-std/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Copied from [chronicle-std](https://github.com/chronicleprotocol/chronicle-std/blob/main/src/IChronicle.sol).
interface IChronicle {
  /// @notice Returns the oracle's current value.
  /// @dev Reverts if no value set.
  /// @return value The oracle's current value.
  function read() external view returns (uint256 value);

  /// @notice Returns the oracle's current value and its age.
  /// @dev Reverts if no value set.
  /// @return value The oracle's current value.
  /// @return age The value's age.
  function readWithAge() external view returns (uint256 value, uint256 age);
}

// Copied from [self-kisser](https://github.com/chronicleprotocol/self-kisser/blob/main/src/ISelfKisser.sol).
interface ISelfKisser {
  /// @notice Kisses caller on oracle `oracle`.
  function selfKiss(address oracle) external;
}

contract DiamondHands is Ownable {
  /// @notice The Chronicle oracle to read from.
  IChronicle public chronicle =
    IChronicle(address(0xc8A1F9461115EF3C1E84Da6515A88Ea49CA97660));

  /// @notice The SelfKisser granting access to Chronicle oracles.
  ISelfKisser public selfKisser =
    ISelfKisser(address(0xfF619a90cDa4020897808D74557ce3b648922C37));

  // variables
  uint256 public minimumPrice = 0;
  uint256 public chroniclePrice = 0;

  // events
  event minimumPriceChange(
    address indexed priceSetter, uint256 newMinimumPrice, uint256 value
  );


  // Constructor: Called once on contract deployment
  // Check packages/foundry/deploy/Deploy.s.sol
  constructor(address _owner) Ownable(_owner) {
    selfKisser.selfKiss(address(chronicle));
  }

  /**
   * Function that allows the owner to deposit ETH into the contract and set the minimum price
   */
  function setMinimumPrice(uint256 _newMinimumPrice) public payable {
    // Print data to the anvil chain console. Remove when deploying to a live network.
    require(
      _newMinimumPrice > minimumPrice,
      "New minimum must be an increase from the current minimum"
    );
    console.logString("Setting new minimum price");
    console.logString(Strings.toString(_newMinimumPrice));

    minimumPrice = _newMinimumPrice;

    emit minimumPriceChange(msg.sender, _newMinimumPrice, msg.value);
  }
  /**
   * Function that sets the chro
   */
  function getChroniclePrice() public returns (uint256) {
    chroniclePrice = chronicle.read();
    return chroniclePrice;
  }
  /**
   * Function that allows the owner to deposit ETH into the contract
   */
  function deposit() public payable {
    require(msg.value > 0, "No ether sent");
    chroniclePrice = chronicle.read();
    console.log("Deposit: ", msg.value);
    console.log("Balance: ", address(this).balance);
  }
  /**
   * Function that allows the contract to receive ETH
   */

  receive() external payable { }

  /**
   * Function that allows the owner to withdraw all the Ether in the contract
   * The function can only be called by the owner of the contract as defined by the isOwner modifier
   */
  function withdraw() public onlyOwner {
    uint256 balance = address(this).balance;
    require(balance > 0, "No ether available to withdraw");
    chroniclePrice = chronicle.read();
    require(
      chroniclePrice >= minimumPrice,
      "Chronicle price is less than the minimum price! Keep holding"
    );
    payable(owner()).transfer(balance);
  }

  /**
   * Function to read the latest data from the Chronicle oracle.
   * @return val The current value returned by the oracle.
   */
  function read() external view returns (uint256) {
    return chronicle.read();
  }
}
