const main = async () => {
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();
    console.log("Contract deployed to:", waveContract.address);

    // Get contract balance
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract Balance:", hre.ethers.utils.formatEther(contractBalance));
    
 
    let waveTxn = await waveContract.wave("First message!");
    await waveTxn.wait();


    let waveTxn2 = await waveContract.wave("Second message!");
    await waveTxn2.wait();

    // const [_, randomPerson] = await hre.ethers.getSigners();
    // waveTxn = await waveContract.connect(randomPerson).wave("Another message, this time by random!");
    // await waveTxn.wait();
    // Get contract balance
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract Balance:", hre.ethers.utils.formatEther(contractBalance));

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);
}

const runMain = async () => {
    try {
        await main();
        process.exit(0); // exit Node process without error.
    } catch (error){
        console.log(error);
        process.exit(1); // uncaught fatal exception error.
    }
}

runMain();