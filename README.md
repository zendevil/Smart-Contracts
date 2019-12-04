# Derivative Contracts created for the Ethereum blockchain

## Introduction
As described by the creator of Bitcoin, the so-called Satoshi Nakamoto, Bitcoin is a “Peer-to-Peer Electronic Cash System”. This is to say that transacting parties do not need a trusted party, like a bank, to avoid double-spending. Using old-fashioned physical cash for transactions doesn’t require a trusted party, but there was no way to do transactions electronically without a trusted party before the advent of Bitcoin. \cite{Bitcoin}
The Bitcoin protocol provides a Turing incomplete scripting language that can be used to create rudimentary “smart-contracts”, defined by Nick Szabo, who first conceived of them in 1996 as “a set of promises, specified in a digital form, including protocols within which the parties perform on these promises.” A simple example of a smart contract is a vending machine. The terms of the contract are automatically deployed when the certain state is encountered. In the case of the vending machine, the soda is deployed when the vending machine finds itself in the state of “coins inputted”. Since Bitcoin’s scripting language for smart contracts is Turing Incomplete, it cannot compute everything that is computable, suggesting that there are contracts that cannot be written in Bitcoin’s scripting language. Even if writing a certain contract is possible to write, Bitcoin’s scripting language isn’t user friendly. 
In 2009, the cryptocurrency Ethereum was launched. Ethereum provided a Turing Complete programming language, called Solidity, for writing smart contracts. With Solidity, it’s possible to create complex contracts involving derivatives and assets. We have implemented the forward contract using the Solidity language. These contracts are ubiquitous, but require a trusted party that acts as an intermediary. Our implementation makes sure that the buyer’s ether is put into an escrow, and is only delivered to the seller once the buyer confirms that he has received the asset. We also discuss the limitations and vulnerabilities of the implementations. \cite{Ethereum}
The full source code can be found at https://github.com/zendevil/Smart-Contracts.git


## Forward Contract

“A forward contract, or simply a forward, is an agreement between two counterparties to trade a specific asset, for example a stock, at a certain future time T and at a certain price K.”\cite{Blyth} A forward contract consists of a long party, the party who agrees to buy the asset, and the short party, the party who agrees to sell the asset. The Solidity implementation consists of the following global variables: 

```   	   	     
  uint public deliveryPrice;                                                                                                                                                                                                                  
  uint public stockPrice; // at time 0                                                                                                                                                                                                        
  uint public T; // maturity                                                                                                                                                                                                                  
                                                                                                                                                                                                                                              
  address longParty;                                                                                                                                                                                                                          
  address payable shortParty;        

```
And the possible states of the contract are Created, Offered, Agreed, Locked and Inactive. The contract is in the state Created when it is initialized, Short when it is shorted, Agreed when the terms of the contract are agreed upon by the long party, Locked when at maturity the long party confirms the purchase and the long party’s money is essentially goes into an escrow, and Inactive when the exchange of the asset and the delivery price (paid in ether) is complete. 
Outline of the contract

```	       
function short(uint _T, uint _deliveryPrice, uint _stockPrice)                                                                                                                                                                              
    public                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    inState(State.Created)
	```

When calling the function short, the shorting party passes in three parameters, _T, _deliveryPrice and _stockPrice. _T specifies the maturity of the contract, _deliveryPrice specifies the shorting party’s offered delivery price and the _stockPrice is the price of the stock at t = 0. The keyword public ensures that the function is callable from outside the contract source-file. inState(State.Created) ensures that the function is only callable in the state created. This would ensure, for example, that short cannot be called in the later stages of the contract.

```
  function long()                                                                                                                                                                                                                             
    public                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    inState(State.Offered)                                                                                                                                                                                                                    
    condition(msg.sender != shortParty) 

```
The long party calls the function long if it agrees to the contract terms set by the short party. This function also sets the state to Agreed. inState(State.Offered) modifier ensures that the function is only possible to call if the state of the contract is Offered. The modifier condition(msg.sender != shortParty) ensures that the short party is not the same as the long party. The sender in msg.sender refers to the caller of the function long(), the long party. 

function confirmPurchase()                                                                                                                                                                                                                  
    public                                                                                                                                                                                                                                    
    onlyAtMaturity                                                                                                                                                                                                                            
    onlyLongParty 
    inState(State.Agreed)                                                                                                                                                                                                          
    condition(msg.value >= deliveryPrice)        

The function confirmPurchase is only callable after maturity as indicated by the modifier onlyAtMaturity, since we want to have the transfer of cash at or after maturity and not before. Note that it is only the long party can call this function, since it is the one that’s buying the asset. The modifier condition(msg.value = deliveryPrice) ensures that the amount of ether sent by the long part is more than or equal to the deliverPrice set by the short party initially as we saw in the description of the function short() above. The confirmPurchase function changes the state of the contract to Locked. At this point, the short party hasn’t received long party’s money yet, and will only be able to receive it once the short party calls confirm received. 

```
  function confirmReceived()                                                                                                                                                                                                                  
    public                                                                                                                                                                                                                                    
    onlyLongParty                                                                                                                                                                                                                             
    inState(State.Locked)      

```
Once the short party receives the asset through an external channel, it calls confirmReceived and the money is released from the escrow and goes into the short party’s balance, thus completing the Forward Contract. The state is changed to Inactive.

Limitations and Improvements
As it stands, the long party may never call confirmReceived, even if it has received the asset, and the money will remain in the escrow. To remedy this, we suggest sending the asset in the form of a secret key (a password of a bank account that holds the asset, for instance) automatically to the long party once it calls confirmPurchase. Hence, elegantly, no external channel is required to trade the asset, and the trade of both the ether and the asset is built into the contract. 

## Smart Swaps


The smart swap implemented in Solidity has the following characteristics. 
// TODO README





## TODO

Smart Swaps
Smart Bonds
Security Vulnerabilities of all Contracts 

