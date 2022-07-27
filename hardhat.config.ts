import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();


const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    matic:{
      url: process.env.MATIC_RPC_URL || '',
      chainId: 137,
      accounts:[process.env.DEPLOY_PRIVATE_KEY || '']
    },

    mumbai:{
      url: process.env.MUMBAI_RPC_URL,
      chainId: 80001,
      accounts:[process.env.DEPLOY_PRIVATE_KEY || '']
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
};

export default config;
