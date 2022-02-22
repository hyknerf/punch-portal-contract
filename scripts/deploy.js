const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const accountBalance = await deployer.getBalance();

  console.log("Deploying contracts with account: ", deployer.address);
  console.log("Account balance: ", accountBalance.toString());

  const factory = await hre.ethers.getContractFactory("PunchPortal");
  const contract = await factory.deploy(10, {
    value: hre.ethers.utils.parseEther("0.001"),
  });
  await contract.deployed();

  console.log("PunchPortal address: ", contract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();