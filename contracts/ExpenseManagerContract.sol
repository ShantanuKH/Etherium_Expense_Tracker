// SPDX-License-Identifier: MIT

// We are creating a contract


// Here we need to define the solidity version

pragma solidity ^0.8.19;
// pragma experimental ABIEncoderV2; 

contract ExpenseManagerContract {


    // Address of the owner
    address public owner;

      modifier onlyOwner(){
        require(msg.sender==owner,"Only owner can execute this");
        _;   // Closing Statement
    }


    // This is a simple transaction model
    struct Transaction{
        address user;
        uint amount;
        string reason;
        uint timestamp;

    }

    Transaction[] public transactions;

    constructor ( ) {
        owner = msg.sender;
    }


    // To see wheather the amount is lesser than the withdraw or not 
    mapping(address => uint )public balances;


    // Whenever we want to perform withdraw and deposite operation we have to create an event 
    event Deposite(address indexed _from, uint amount, string reason, uint timestamp);

    event Withdraw(address indexed _to, uint amount, string reason, uint timestamp);


    // Deposite function
    function deposite(uint _amount, string memory _reason)public payable{
            require(_amount>0, "Deposit amount should be greater than 0" );
            balances[msg.sender]+= _amount;
            transactions.push(Transaction(msg.sender, _amount, _reason, block.timestamp));

            emit Deposite(msg.sender, _amount, _reason, block.timestamp);
            
    }

    // Withdraw function
    function withdraw(uint _amount, string memory _reason)public{

        require(balances[msg.sender]>=_amount, "Insufficient Balance");
        balances[msg.sender]-= _amount;
        transactions.push(Transaction(msg.sender, _amount, _reason, block.timestamp));
        // This below line will make the transactions done payable
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount, _reason, block.timestamp);

    }


    // View means only can see data, Cannot update or say manipulate data
    function getBalance(address _account) public view returns (uint){
        return balances[_account];

    }

    function getTransactionCount() public view returns(uint){
        return transactions.length;

    }

    // address, amount, reason, timestamp
    function getTransaction(uint _index) public view returns(address, uint, string memory,  uint){
        require(_index < transactions.length,"Index out of bound");
        Transaction memory transaction = transactions[_index];
        return (transaction.user, transaction.amount, transaction.reason, transaction.timestamp);

    }

    //List of  (address, amount, reason, timestamp)
    function getAllTransaction()public view returns(address[] memory, uint[] memory, string[] memory, uint[] memory){
            address[] memory users = new address[](transactions.length);
            uint[] memory amounts = new uint[](transactions.length);
            string[] memory reasons = new string[](transactions.length);
            uint[] memory timestamps = new uint[](transactions.length);


            // Solidity cannot return direct list and so we have to iterate through each transaction
            for (uint i=0; i<transactions.length; i++ ){
                users[i]= transactions[i].user;
                amounts[i]= transactions[i].amount;
                reasons[i]= transactions[i].reason;
                timestamps[i]= transactions[i].timestamp;
            }

            return (users, amounts, reasons, timestamps);
    }


    function changeOwner(address _newOwner)public onlyOwner{
        owner=_newOwner;

    }

  
    
}




