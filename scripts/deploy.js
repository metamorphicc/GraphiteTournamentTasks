const hre = require("hardhat");

async function main() {
    const ESGOracle = await hre.ethers.getContractFactory("ESGOracle");
    const contract = await ESGOracle.deploy();

    await contract.waitForDeployment();
    console.log(`Contract deployed at: ${await contract.getAddress()}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
