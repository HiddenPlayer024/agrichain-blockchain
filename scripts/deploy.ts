import { ethers } from "hardhat";
import * as fs from "fs"

async function main() {
  const CropBatch = await ethers.getContractFactory("CropBatch");
  const cropBatch = await CropBatch.deploy();
  await cropBatch.waitForDeployment();

  const address = await cropBatch.getAddress();

  console.log("CropBatch deployed to:", address);

  fs.writeFileSync(
    "DEPLOYED_ADDRESS.txt",
    address,
    { encoding: "utf-8" }
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

