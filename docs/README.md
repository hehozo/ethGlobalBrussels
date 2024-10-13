### Using Chronicle Scribe Oracle with Scaffold-Eth-2

Chronicle offers many highly reliable Oracles across ethereum and Layer 2s (and beyond) which provide smart contracts with access to real-world pricing information to power DeFi use cases.

In this guide, we will walk through how to get set up with the Scaffold-Eth repository so that you can quickly experiment with dApps which leverage the power of Chronicle’s Scribe Oracles!

This guide is designed to be accessible to beginners.

## <summary>Dependencies</summary>

Before we download the Scaffold-Eth repository, make sure you have these installed:

- [Node (>= v18.17)](https://nodejs.org/en/download/) - if you don’t already have node installed, it’s recommended you install using ‘nvm’ (the node version manager). This will be the first option when you click on the link. *Note:* [Yarn](https://yarnpkg.com/getting-started/install) will be installed as part of Node, so you don’t need to install this separately.
- [Git](https://git-scm.com/downloads)
- [Foundry](https://book.getfoundry.sh/getting-started/installation) - Scaffold-Eth can run with Foundry or [HardHat](https://hardhat.org/hardhat-runner/docs/getting-started) but this guide will focus on Foundry.

Chronicle has no system dependencies for this implementation.

## <summary>Getting started with Scaffold-Eth-2</summary>

Now that we have Node, Foundry and Git installed, we can copy the Scaffold-Eth-2 repository and start setting it up! These steps are modified slightly from Option 2 in the [Scaffold-Eth Installation Guide](https://docs.scaffoldeth.io/quick-start/installation).

In your terminal, run the following to clone the repository.

<code>git clone https://github.com/scaffold-eth/scaffold-eth-2.git</code>

Navigate into the new repository and bootstrap the project.

<code>cd scaffold-eth-2
npx create-eth@latest</code>

