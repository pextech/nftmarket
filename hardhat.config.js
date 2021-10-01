require("@nomiclabs/hardhat-waffle");
const fs = require("fs");
const privateKey = fs.readFileSync(".secret").toString();
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();

//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });

const projectid = "f0c1756bf77c4d8eb525375aa106ebcc";


module.exports = {
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${projectid}`,
      accounts: [privateKey]
    },
    mainnet: {
      url: `https://polygon-mainnet.infura.io/v3/${projectid}`,
      accounts: [privateKey]
    }
  },
  solidity: "0.8.7",
};
