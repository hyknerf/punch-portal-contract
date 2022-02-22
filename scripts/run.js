const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const factory = await hre.ethers.getContractFactory("PunchPortal");
  const contract = await factory.deploy(20, {
    value: hre.ethers.utils.parseEther("0.01"),
  });
  await contract.deployed();

  console.log("Contract deployed to:", contract.address);
  console.log("Contract deployed by:", owner.address);

  let punchCount;
  punchCount = await contract.getTotalPunches();

  let tx = await contract.punch("Slapper!");
  await tx.wait();

  punchCount = await contract.getTotalPunches();

  tx = await contract.connect(randomPerson).punch("Bam!");
  await tx.wait();

  contractBalance = await hre.ethers.provider.getBalance(contract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  punchCount = await contract.getTotalPunches();

  let allPunches = await contract.getAllPunches();
  console.log(allPunches);
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