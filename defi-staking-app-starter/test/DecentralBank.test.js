
const { Web3 } = require('rainbow-bridge-utils');

//const Web3= require('web3');


const Tether = artifacts.require('Tether');
const RWD = artifacts.require('RWD');
const DecentralBank = artifacts.require('DecentralBank');

require('chai')
.use(require('chai-as-promised'))
.should()

contract ('DecentralBank' , ([owner, customer]) =>{
    //before hooks and load contract here
    let tether, rwd,decentralBank;
    before(async ()=>{
        tether= await Tether.new()
        rwd= await RWD.new()
        decentralBank= await DecentralBank.new(rwd.address, tether.address)
        await rwd.transfer(decentralBank.address, Web3.utils.toWei('1000'))
        
        //tether token tansfer to custom account
        await tether.transfer(customer,Web3.utils.toWei('100'),{from:owner})

    })


    describe('Tether deveployment', async()=>{
        it('match is successfully', async()=>{
            // let tether= await Tether.new();
            const name= await tether.name();
            assert.equal(name, 'Tether Token');
        })
    })
    describe('Reward deveployment', async()=>{
        it('match is successfully', async()=>{
            // let rwd= await RWD.new();
            const name= await rwd.name();
            assert.equal(name, 'Reward Token');
        })
    })
    describe('Decentral Bank deveployment', async()=>{
        it('match is successfully', async()=>{
            // let rwd= await RWD.new();
            const name= await decentralBank.name();
            assert.equal(name, 'Decentral Bank');
        })
        it('contract has token', async()=>{
            // let rwd= await RWD.new();
            let balance= await rwd.balanceOf(decentralBank.address);
            assert.equal(balance, Web3.utils.toWei('1000'));
        })
    })
    describe('Yeild Farming', async()=>{
        it('Reward Token for staking', async()=>{
            let result
            result= await tether.balanceOf(customer)
            assert.equal(result.toString(),Web3.utils.toWei('100'),'customer balance before for staking')
               // check staking for customer 100 token
            await tether.approval(decentralBank.address,Web3.utils.toWei('100'),{from:customer})
            await decentralBank.depositToken(Web3.utils.toWei('100'),{from:customer})
            // check updated balance of customer
            result= await tether.balanceOf(customer)
            assert.equal(result.toString(),Web3.utils.toWei('0'),'update customer balance after for staking')
            
            
            // check updated blance of bank
            result= await tether.balanceOf(decentralBank.address)
            assert.equal(result.toString(),Web3.utils.toWei('100'),'update decentral bank balance customer for after staking')
        
            // result= await tether.balanceOf(decentralBank.address)
            // assert.equal(result.toString(),'true','Bank  staking balance')
          
             // is staking
            result = await decentralBank.isStaked(customer)
            assert.equal(result.toString(),'true','customer is statue after staking')

            //issue token 
            await decentralBank.issueTokens({from:owner})

            //only owner can issue
            await decentralBank.issueTokens({from:customer}).should.be.rejected;

            //unstake token

            await decentralBank.unstakingTokens({from:customer})

           // unstaking balance
           result= await tether.balanceOf(customer)
           assert.equal(result.toString(),Web3.utils.toWei('100'),'update customer balance after for unstaking')
           
           
           // check updated blance of bank
           result= await tether.balanceOf(decentralBank.address)
           assert.equal(result.toString(),Web3.utils.toWei('0'),'update decentral bank balance customer for after staking')
       
            // is staking
           result = await decentralBank.isStaked(customer)
           assert.equal(result.toString(),'false','customer is no longer statue after unstaking')
          
        })
    })
})