const hre = require("hardhat");

async function main() {
    const MedicalServices = await hre.ethers.getContractFactory("MedicalServices");
    const contract = await MedicalServices.deploy();

    await contract.waitForDeployment();
    console.log(`Contract deployed at: ${await contract.getAddress()}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
