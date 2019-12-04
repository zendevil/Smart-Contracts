pragma solidity >=0.4.22 <0.6.0;                                                                                                                                                                                                                                                              
contract Token {                                                                                                                                                                                                                                                                      
  mapping (address => uint) public balances;
    
  modifier condition(bool _condition) {
    require(_condition);
    _;
  }
  event Constructor();
  constructor() public {                                                                                                                                                                                                                                                                
    balances[msg.sender] = 1000000;                                                                                                        emit Constructor();                                                                                                                                       
  }                                                                                                                                                                                                                                                                                 
  function transfer(address _to, uint _amount) public 
    condition(balances[msg.sender] < _amount)
  {                                                                                                                                                                                                                                    
        
    balances[msg.sender] -= _amount;                                                                                                                                                                                                                                              
    balances[_to] += _amount;                                                                                                                                                                                                                                                     
  }                                                                                                                                                                                                                                                                                 
}         
