pragma solidity >0.4.22;

contract Forward {

  uint public deliveryPrice;
  uint public stockPrice; // at time 0
  uint public T; // maturity

  address longParty;
  address payable shortParty;
  
  enum State { Created, Offered, Agreed, Locked, Inactive }
  State public state;

  event AlreadyOffered();
  event Shorted();
  event Longed();
  

  modifier onlyLongParty() {
    require(
            msg.sender == buyer,
            "Only Long Party can call this."
	    );
    _;
  }


  modifier onlyShortParty() {
    require(
            msg.sender == seller,
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

  modifier onlyAtMaturity(S) {
    require(
            now >= T && state == State.Agreed,
            "Contract hasn't reached maturity."
	    );
    _;
  }
  
  constructor() public {
    state = State.Created;
  }
  
  function short(uint _T, uint _deliveryPrice, uint _stockPrice)
    public
    payable
    inState(State.Created)
  {
    shortParty = msg.sender;
    emit Shorted();
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
    state = State.Agreed;
    emit Longed();
  }

  function confirmPurchase()
    public
    onlyAtMaturity
    onlyLongParty
    inState(State.Agreed)
    condition(msg.value >= deliveryPrice)
    payable
  {
    state = State.Locked;
    emit PurchaseConfirmed();
  }

  function confirmReceived()
    public
    onlyLongParty
    inState(State.Locked)
  {
    emit AssetReceived();
    state = State.Inactive;

    longParty.transfer(deliveryPrice);
    shortParty.transfer(address(this).balance);
  }
 
}
