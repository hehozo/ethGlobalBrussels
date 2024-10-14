---
layout: page
title: Get Started
permalink: /get_started/
---


### Using the Scribe Oracle with Scaffold-Eth-2

Chronicle offers many highly reliable Oracles across ethereum and Layer 2s (and beyond) which provide smart contracts with access to real-world pricing information to power DeFi use cases.

In this guide, we will walk through how to get set up with the Scaffold-Eth repository so that you can quickly experiment with dApps which leverage the power of Chronicle’s Scribe Oracles!

This guide is designed to be accessible to beginners.
<br />
<br />

---

### Dependencies

Before we download the Scaffold-Eth repository, make sure you have these installed:

- [Node (>= v18.17)](https://nodejs.org/en/download/) - if you don’t already have node installed, it’s recommended you install using ‘nvm’ (the node version manager). This will be the first option when you click on the link. *Note:* [Yarn](https://yarnpkg.com/getting-started/install) will be installed as part of Node, so you don’t need to install this separately.
- [Git](https://git-scm.com/downloads)
- [Foundry](https://book.getfoundry.sh/getting-started/installation) - Scaffold-Eth can run with Foundry or [HardHat](https://hardhat.org/hardhat-runner/docs/getting-started) but this guide will focus on Foundry.

Chronicle has no system dependencies for this implementation.
<br />
<br />

---

### Getting started with Scaffold-Eth-2

Now that we have Node, Foundry and Git installed, we can copy the Scaffold-Eth-2 repository and start setting it up! These steps are modified slightly from Option 2 in the [Scaffold-Eth Installation Guide](https://docs.scaffoldeth.io/quick-start/installation).

In your terminal, run the following to clone the repository.

``` shell
git clone https://github.com/scaffold-eth/scaffold-eth-2.git
```

Navigate into the new repository and bootstrap the project.

``` shell
cd scaffold-eth-2
npx create-eth@latest</code>
```

This will open a terminal dialogue which first asks you to input a project name, then select the solidity framework you want to use. Select **foundry**.

<img src="https://ik.imagekit.io/hehozo/ethGlobalBrussels/select_foundry.png" alt="select foundry" width="400">

Install the packages as prompted, then wait for your new project to be initialized.

<img src="https://ik.imagekit.io/hehozo/ethGlobalBrussels/install_packages.png" alt="install packages" width="400">

Once initialized, the process recommends next steps to start the Scaffold-Eth 2 dApp builder in your local network. However, we want to **connect to the Chronicle Oracles, which requires us to connect to a testnet instead.**

<details>
<summary>FYI: Forking a Sepolia TestNet</summary>

if you want to keep working on your local machine and also have access to the Chronicle Oracles, you can <a href="https://github.com/chronicleprotocol/scaffold-oracle-reader">follow this guide</a> to fork the Sepolia TestNet, which will allow you to still read oracle values from Chronicle.

This same method can be used for any test cases you put in your {YourContract}.t.sol test cases file. See the <a href="https://book.getfoundry.sh/forge/fork-testing">foundry docs on fork testing</a> for more in-depth information.
</details>
<br />


---
### Deploying to a Sepolia TestNet

Chronicle has Oracle Smart Contract Addresses on many different testNets including Ethereum Sepolia, Optimism Sepolia, Base Sepolia, Arbitrum Sepolia and zkSync Sepolia. See the full list of testNet smart contract addresses [here](https://docs.chroniclelabs.org/hackathons/eth-global-brussels-hackathon).

This tutorial will cover deploying our scaffold-eth smart contract directly to the Optimism Sepolia testNet in three main steps:

1. Generate a burner wallet using yarn generate from within your scaffold-eth directory:

    ```shell
    yarn generate
    ```
    <img src="https://ik.imagekit.io/hehozo/ethGlobalBrussels/yarn%20generate.png" alt="yarn generate" width="500">

    To get some testNet tokens into the new wallet, transfer from an existing wallet or use one of these faucets:
    - <a href="https://ethglobal.com/faucet">EthGlobal Faucet</a>
    - <a href="https://www.ethereum-ecosystem.com/faucets">ethereum-ecosystem.com</a>
    - <a href="https://sepoliafaucet.com/">Alchemy Sepolia Faucet</a>
    - <a href="https://learnweb3.io/faucets">learnweb3.io</a>

    You can always run yarn account to view the token balances and public address for your generated wallet:
    ```shell
    yarn account
    ```
    <img src="https://ik.imagekit.io/hehozo/ethGlobalBrussels/yarn_account.png" alt="yarn account" width="400">


2. Update the nextjs > scaffold.config.ts file line 13 to point to Optimism Sepolia (or other TestNet) instead of foundry.

    ç

3. Back in the terminal, run the following command to deploy the contract to Optimism Sepolia TestNet (or other TestNet)
    ```shell
    yarn deploy --network optimismSepolia
    ```

    Open a new terminal window and start up the scaffold!
    ```shell
    yarn start
    ```

Now head to http://localhost:3000 in a chrome browser to view the default scaffold-eth-2 contract and framework.
<br />
<br />

---

### Connecting to Chronicle Oracle

You will be working mostly on 2 files within the Scaffold-Eth-2 repository:

- **YourContract.sol** - the solidity smart contract. The Scaffold-Eth browser interface will show changes to this contract on the Debug tab, and you will need to re-deploy the contract to the TestNet blockchain in order for updates to be processed. Find it within the directory at packages/foundry/contracts/YourContract.sol
- **page.tsx** - the typescript file which controls the public frontend. The Scaffold-Eth browser interface will show this on the Home tab, and it will display updates as soon as the file is saved, since it does not live on the blockchain. Find it within the directory at packages/nextjs/app/page.tsx

Within the smart contract, we will need to make several edits to gain access to the Chronicle Oracles. Luckily, Chronicle has made this super easy for us (modified from the steps described in <a href="https://ethglobal.com/guides/a-complete-guide-to-oracles-xfcg7#7emn9">a complete guide to oracles</a>)

1. Define the Interface type IChronicle and the Interface type ISelfKisser outside of the contract definition.
    ```solidity
    // Copied from [chronicle-std](https://github.com/chronicleprotocol/chronicle-std/blob/main/src/IChronicle.sol).
    interface IChronicle {
        /** 
        * @notice Returns the oracle's current value.
        * @dev Reverts if no value set.
        * @return value The oracle's current value.
        */
        function read() external view returns (uint256 value);

        /** 
        * @notice Returns the oracle's current value and its age.
        * @dev Reverts if no value set.
        * @return value The oracle's current value using 18 decimals places.
        * @return age The value's age as a Unix Timestamp .
        * */
        function readWithAge() external view returns (uint256 value, uint256 age);
    }

    // Copied from [self-kisser](https://github.com/chronicleprotocol/self-kisser/blob/main/src/ISelfKisser.sol).
    interface ISelfKisser {
        /// @notice Kisses caller on oracle `oracle`.
        function selfKiss(address oracle) external;
    }
    ```
2. Define the public variable chronicle of type IChronicle and public variable selfKisser of type ISelfKisser within the contract definition.
    ```solidity
    // using the smart contract address for OptimismSepolia ETH_USD_1
    IChronicle public chronicle = IChronicle(address(0xc8A1F9461115EF3C1E84Da6515A88Ea49CA97660));

    // using the smart contract address for OptimismSepolia Selfkisser_1
    ISelfKisser public selfKisser = ISelfKisser(address(0xfF619a90cDa4020897808D74557ce3b648922C37));
    ```
3. Add the SelfKiss to the constructor within the contract definition
    ```solidity
    // within the constructor block, add the below
    // this will cause the selfkiss to occur when the contract is compiled
    selfKisser.selfKiss(address(chronicle));
    ```
4. We can also define a read() function to obtain the Chronicle Oracle’s value (this can be changed later, but defining it allows the result to be displayed in the debugger)
    ```solidity
        // defining read() using the built-in functions from interface type IChronicle
    function read() external view returns (uint256 val, uint256 age) {
    (val, age) = chronicle.readWithAge();
    }
    ```

Save these changes to the existing **YourContract.sol**, re-deploy using yarn, and check out your browser interface of Scaffold to see what’s changed!
<img src="https://ik.imagekit.io/hehozo/ethGlobalBrussels/your_contract.png" alt="your contract" width="400">

Thanks to the nifty interface provided by Scaffold-Eth-2, we’re able to confirm that our selfKiss authorization worked, and that the read of the chronicle oracle address was successful.

At this point, you can start playing around with the contract and typescript to create whatever dApp you want to use Chronicle’s Oracle in!

Feel free to also <a href="{{ '/implement' | relative_url }}">follow along with this example implementation</a> of the Chronicle Oracles being used in a "Diamond Hands" solidity smart contract if you'd like some ideas.
