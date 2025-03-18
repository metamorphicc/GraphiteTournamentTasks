require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/iSXgqHLD2kCyRs0epg5s_lwzlmBqMega",
      accounts: ["YOUR_PRIVATE_KEY"]
    }   
  },
  etherscan: {
    apiKey: {
      sepolia: 'XKSJ9UK3BE3DW5VPKN1KFS8Y2JM1FF5WM8'
    }
  }
};
