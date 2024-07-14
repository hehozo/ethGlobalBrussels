// //SPDX-License-Identifier: MIT
// pragma solidity >=0.8.0 <0.9.0;

// // Useful for debugging. Remove when deploying to a live network.
// import "forge-std/console.sol";
// // we'll need to use the oppenzeppelin function toString to convert the uint256 to a string
// // import "openzeppelin-contracts/utils/Strings.sol";

// // Use openzeppelin to inherit battle-tested implementations (ERC20, ERC721, etc)
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// /**
//  * A smart contract that allows changing a state variable of the contract and tracking the changes
//  * It also allows the owner to withdraw the Ether in the contract
//  * @author BuidlGuidl
//  */
// contract YourContract {
//   // State Variables
//   address public immutable owner;
//   string public greeting = "GM";
//   string public priceString = "0";
//   uint256 public  unlockValue = 0;
//   bool public isLucky = false;
//   uint256 public totalCounter = 0;
//   mapping(address => uint256) public userGreetingCounter;

//   // Events: a way to emit log statements from smart contract that can be listened to by external parties
//   event GreetingChange(
//     address indexed greetingSetter,
//     string newGreeting,
//     bool lucky,
//     uint256 value
//   );

//   // Constructor: Called once on contract deployment
//   // Check packages/foundry/deploy/Deploy.s.sol
//   constructor(address _owner) {
//     owner = _owner;
//     selfKisser.selfKiss(address(chronicle));
//   }

//   // Modifier: used to define a set of rules that must be met before or after a function is executed
//   // Check the withdraw() function
//   modifier isOwner() {
//     // msg.sender: predefined variable that represents address of the account that called the current function
//     require(msg.sender == owner, "Not the Owner");
//     _;
//   }
//   /// @notice The Chronicle oracle to read from.
//   IChronicle public chronicle = IChronicle(address(0x11E155b04f0498bc6B6EB0086A2148368F0b64F0));

//   /// @notice The SelfKisser granting access to Chronicle oracles.
//   ISelfKisser public selfKisser = ISelfKisser(address(0x70E58b7A1c884fFFE7dbce5249337603a28b8422));

//   /// @notice Function to read the latest data from the Chronicle oracle.
//   /// @return val The current value returned by the oracle.
//   /// @return age The timestamp of the last update from the oracle.
//   function read() external view returns (uint256 val, uint256 age) {
//       (val, age) = chronicle.readWithAge();
//   }

//   /**
//    * Function that allows anyone to change the state variable "greeting" of the contract and increase the counters
//    *
//    * @param _newGreeting (string memory) - new greeting to save on the contract
//    */
//   function setGreeting(string memory _newGreeting) public payable {
//     // Print data to the anvil chain console. Remove when deploying to a live network.

//     console.logString("Setting new greeting");
//     console.logString(_newGreeting);

//     greeting = _newGreeting;
//     totalCounter += 1;
//     userGreetingCounter[msg.sender] += 1;

//     // updated msg.value conditional to "isLucky" instead, we will search for lucky numbers
//     // msg.value: built-in global variable that represents the amount of ether sent with the transaction
//     //if (msg.value > 0) {

//     if (chronicle.read() > 3000*10**18){
//       isLucky = true;
//     } else {
//       isLucky = false;
//     }

//     // emit: keyword used to trigger an event
//     emit GreetingChange(msg.sender, _newGreeting, msg.value > 0, msg.value);
//   }

//   /**
//    * Function that allows anyone to change the state variable "luckyNumber"
//    * "luckyNumber" is stored as a string so we can do string search later
//    * @param _newLuckyNumber (string memory) - new luckyNumber to save on the contract
//    */
//   function setLuckyNumber(string memory _newLuckyNumber) public {
//     luckyNumber = _newLuckyNumber;
//   }

//   /**
//    * Function that allows the owner to withdraw all the Ether in the contract
//    * The function can only be called by the owner of the contract as defined by the isOwner modifier
//    */
//   function withdraw() public isOwner {
//     (bool success,) = owner.call{ value: address(this).balance }("");
//     require(success, "Failed to send Ether");
//   }

//   /**
//    * Function that allows the contract to receive ETH
//    */
//   receive() external payable { }
// }

// // Copied from [chronicle-std](https://github.com/chronicleprotocol/chronicle-std/blob/main/src/IChronicle.sol).
// interface IChronicle {
//     /// @notice Returns the oracle's current value.
//     /// @dev Reverts if no value set.
//     /// @return value The oracle's current value.
//     function read() external view returns (uint256 value);

//     /// @notice Returns the oracle's current value and its age.
//     /// @dev Reverts if no value set.
//     /// @return value The oracle's current value.
//     /// @return age The value's age.
//     function readWithAge() external view returns (uint256 value, uint256 age);
// }

// // Copied from [self-kisser](https://github.com/chronicleprotocol/self-kisser/blob/main/src/ISelfKisser.sol).
// interface ISelfKisser {
//     /// @notice Kisses caller on oracle `oracle`.
//     function selfKiss(address oracle) external;
// }
