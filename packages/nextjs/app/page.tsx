"use client";

//import Link from "next/link";
import type { NextPage } from "next";
import { useAccount } from "wagmi";
import { Address } from "~~/components/scaffold-eth";

//import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();
  // const { writeContractAsync: writeDiamondHandsAsync } = useScaffoldWriteContract("DiamondHands");

  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="px-5">
          <h1 className="text-center">
            <span className="block text-2xl mb-2">Welcome to</span>
            <span className="block text-4xl font-bold">Scaffold-ETH 2</span>
          </h1>
          <div className="flex justify-center items-center space-x-2 flex-col sm:flex-row">
            <p className="my-2 font-medium">Connected Address:</p>
            <Address address={connectedAddress} />
          </div>
          <div className="flex justify-center items-center space-x-2 flex-col sm:flex-row">
            <p className="my-2 font-medium">Connected Oracle:</p>
            <p className="my-2 font-medium">placeholder</p>
          </div>
          {/* <button
            className="btn btn-primary"
            onClick={async () => {
              try {
                await writeDiamondHandsAsync({
                  functionName: "setMinimumPrice",
                  args: ["The value to set"],
                  value: parseEther("0.1"),
                });
              } catch (e) {
                console.error("Error setting greeting:", e);
              }
            }}
          >
            Set Minimum Price
          </button> */}
        </div>
      </div>
    </>
  );
};

export default Home;
