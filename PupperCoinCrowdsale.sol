pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate, // rate in 1TKN per ETH or 1 TKNbit per wei
        address payable wallet, //sale and benficiary wallet address
        PupperCoin token,
        // uint cap, // Upper limit of tokens to be issued during sale
        uint openingTime, // defines time the sale starts in UTC timestamp
        uint closingTime,// defines time the sale ends in UTC timestamp
        uint goal // the minimum goal in wei units
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinCrowdsaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet, // will receive all Ether raised by the sale.
        uint goal // the minimum goal in wei units
    )
        public
    {
        //create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // create the PupperCoinCrowdsale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinCrowdsale pupper_sale = new PupperCoinCrowdsale(
                1, // 1 TKNbit per 1 wei
                wallet, 
                token, 
                now,
                now + 24 weeks, 
                goal); 
                
        token_sale_address = address(pupper_sale);
        
        // make the PupperCoinCrowdsale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}

        
