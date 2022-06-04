const { ethers } = require("hardhat");
const { use, expect } = require("chai");
const { solidity } = require("ethereum-waffle");

use(solidity);

describe("My Dapp cool", function () {
  //   before((done) => {});

  describe("YourContract", function () {
    it("Should deploy YourContract", async function () {
      //       const YourContract = await ethers.getContractFactory("YourContract");
      //       myContract = await YourContract.deploy();
    });
  });
});
