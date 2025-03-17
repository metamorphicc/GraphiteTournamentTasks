const hre = require("hardhat");

async function main() {
    const ReputationByLoans = await hre.ethers.getContractFactory("ReputationByLoans");
    const contract = await ReputationByLoans.deploy();

    await contract.waitForDeployment();
    console.log(`Contract deployed at: ${await contract.getAddress()}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
