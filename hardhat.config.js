require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/iSXgqHLD2kCyRs0epg5s_lwzlmBqMega",
      accounts: ["3b72a11498e41426b21a83d0926620d9e08b0080853344d6b388a5c5cfcbfe87"]
    }   
  },
  etherscan: {
    apiKey: {
      sepolia: 'XKSJ9UK3BE3DW5VPKN1KFS8Y2JM1FF5WM8'
    }
  }
};
