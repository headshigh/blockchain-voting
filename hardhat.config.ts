import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/bfc97f3228b54164a253f5e699262156",
      accounts: [
        "d63313159a7d359ab1538941c60b7a98da451353b2f9006436b498cc89f4fab6",
      ],
    },
  },
};

export default config;
