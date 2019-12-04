# Derivative Contracts created for the Ethereum blockchain

## Forward Contract

A forward contract consists of a long party, the party who agrees to buy the asset, and the short party, the party who agrees to sell the asset. The Solidity implementation consists of the following global variables: 

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

