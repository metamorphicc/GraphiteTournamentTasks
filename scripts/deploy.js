const hre = require("hardhat");

async function main() {
    const ESGReputationManagement = await hre.ethers.getContractFactory("ESGReputationManagement");
    const contract = await ESGReputationManagement.deploy();

    await contract.waitForDeployment();
    console.log(`Contract deployed at: ${await contract.getAddress()}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
