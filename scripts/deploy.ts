import { ethers } from "hardhat";

async function main() {

  const FactoryClone = await ethers.getContractFactory("FactoryClone");
  const factory = await FactoryClone.deploy();

  await factory.deployed();

  console.log("Lock with 1 ETH deployed to:", factory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
