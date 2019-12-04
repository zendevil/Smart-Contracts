pragma solidity ^0.5.12;

contract Forward {

  uint public deliveryPrice;
  uint public stockPrice; // at time 0
  uint public T; // maturity
  bytes private key;
  address payable longParty;
  address payable shortParty;
  
  enum State { Created, Offered, Agreed, Locked, Inactive }
  State public state;

  event Created();
  event AlreadyOffered();
  event Shorted(uint maturity, uint deliveryPrice, uint stockPrice);
  event Longed(bytes key);
  event PurchaseConfirmed(uint amountSent, uint deliveryPrice);
  event AssetReceived();
  event CurrentTimeVsMaturity(uint current, uint maturity);
  modifier onlyLongParty() {
    require(
            msg.sender == longParty,
            "Only Long Party can call this."
	    );
    _;
  }


  modifier onlyShortParty() {
    require(
            msg.sender == shortParty,
            "Only Short Party can call this."
	    );
    _;
  }
  
  modifier inState(State _state) {
    require(
            state == _state,
            "Invalid state."
	    );
    _;
  }

  modifier condition(bool _condition) {
    require(_condition);
    _;
  }

  modifier onlyAtMaturity() {
    require(
            now >= T && state == State.Agreed,
            "Contract hasn't reached maturity."
  	    );
    _;
  }
  
  constructor() public {
    state = State.Created;
    emit Created();
  }
  
  function short(uint _T, uint _deliveryPrice, uint _stockPrice)
    public
    payable
    inState(State.Created)
  {
    shortParty = msg.sender;
    emit Shorted(_T, _deliveryPrice, _stockPrice);
    T = _T;
    deliveryPrice = _deliveryPrice;
    state = State.Offered;
    stockPrice = _stockPrice;
    
  }

  function long()
    public
    payable
    inState(State.Offered)
    condition(msg.sender != shortParty)
  {
    longParty = msg.sender;
    key = msg.data;
    state = State.Agreed;
    emit Longed(key);
  }

  function confirmPurchase()
    public
    onlyAtMaturity
    onlyShortParty
    inState(State.Agreed)
    condition(msg.value >= deliveryPrice)
    payable
  {
    state = State.Locked;
    emit PurchaseConfirmed(msg.value, deliveryPrice);
    emit CurrentTimeVsMaturity(now, T);
  }

  function confirmReceived()
    public
    onlyLongParty
    inState(State.Locked)
  {
    emit AssetReceived();
    state = State.Inactive;
    longParty.transfer(deliveryPrice);

    

  }
}
