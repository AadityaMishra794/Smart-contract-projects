// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract demo{
  struct Events{
    address organizer;
    string name ;
    uint date;
    uint price;
    uint ticket_count;
    uint ticket_remain;

  }
mapping (uint=>Events) public events;
mapping (address=>mapping (uint=>uint))public tickets;
uint public  nextId;


function create_event(string memory name, uint date,uint price, uint ticket_count) external{
  require(date>block.timestamp,"you can organise an event on future date");
  require(ticket_count>0,"you can organize only if u have more than 0 tickets");
  events[nextId]=Events(msg.sender,name,date,price,ticket_count,ticket_count);
  nextId++;

}
function buy_ticket(uint id, uint quantity) public payable {
  require(events[id].date!=0,"Event does not exsit");
  require(events[id].date>block.timestamp,"Eevent has already occured");
  Events storage _events = events[id];
  require(msg.value==(_events.price*quantity),"ether is not enough");
  require(_events.ticket_remain>=quantity,"not enough tickets");
  _events.ticket_remain-=quantity;
  
  


}

}

      