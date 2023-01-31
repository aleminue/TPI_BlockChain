// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "./TaskStatus.sol";
import "./Task.sol";

contract ToDoList {
    uint256 TASK_PRICE = 100 wei;
    mapping(address => Task[]) tasks;
    address public owner;


    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "No tenes permiso");
        _;
    }

    modifier returnable() {
        _;
        if (msg.value > TASK_PRICE){
            payable(msg.sender).transfer(msg.value - TASK_PRICE);
        }
    }


    function updateTaskPrice(uint256 newPrice) public onlyOwner{
        TASK_PRICE = newPrice;
    }

    function withdraw() public onlyOwner{
        payable(owner).transfer(address(this).balance);
    }

    function create(string memory _text) public payable returnable {
        require(msg.value >= TASK_PRICE, "No te alcanza...");
        tasks[msg.sender].push(Task(_text, TaskStatus.ToDo));
    }

    function update(uint _index, string memory _text) public {
        // Opcion 1:
        // Task storage task = tasks[_index];
        // task.text = _text;

        // Opcion 2:
        tasks[msg.sender][_index].text = _text;

        // Para muchos valores clon en memoria
        // Tast memory task = tasks[_index] // ésto hace un clon del task en memoria, pero no lo guarda
        // task.text = _text; // Update del task en memoria
        // (...)
        // tasks[_index] = task; // Update del valor real en storage
    }

    function toDone(uint _index) public {
        _setStatus(_index, TaskStatus.Done);
    }

    function toDoing(uint _index) public {
        _setStatus(_index, TaskStatus.Doing);
    }

    function toToDo(uint _index) public {
        _setStatus(_index, TaskStatus.ToDo);
    }

    function _setStatus(uint _index, TaskStatus _status) internal {
        tasks[msg.sender][_index].status = _status;
    }

    function task(uint _index) public view returns (Task memory) {
        return tasks[msg.sender][_index];
    }
}