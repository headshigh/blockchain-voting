import { ethers } from "hardhat";
async function main() {
  const Voting = await ethers.getContractFactory("Voting");
  const voting = await Voting.deploy();
  await voting.waitForDeployment();
  console.log("Deployed to ", await voting.getAddress());
}
main().catch((err) => {
  console.log(err);
  process.exitCode = 1;
});
