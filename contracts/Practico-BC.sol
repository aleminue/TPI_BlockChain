// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./TaskStatus.sol";
import "./Task.sol";

contract ToDoList {

    uint256 TASK_PRICE = 100 wei;

    mapping(address => Task[]) tasks;

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "No tiene permisos para actualizar el precio");
        _;
        //la linea comentada debajo, es para quemar el addres
        //owner = address(0x0);
    }

    function task(uint _index) public view returns (Task memory){
        return tasks[msg.sender][_index];
    }

    function create(string memory _text) payable public {
        //El require hace un revert del contrato, mientras que el if no lo hace
        //Te consume la plata lo mismo el if
        require(msg.value >= TASK_PRICE, "No te alcanza...");
        tasks[msg.sender].push(Task(_text,TaskStatus.ToDo));
        if (msg.value > TASK_PRICE){
            payable(msg.sender).transfer(msg.value - TASK_PRICE);
        }
    }

    function updatePrice(uint256 _price) public onlyOwner {
        TASK_PRICE = _price;
    }

    function update(uint _index, string memory _text) public {
        //esta es una forma, sirve mas para cuando hay muchos valores a cambiar del objeto
        //entonces se instancia una vez y ya se cambian todos los valores
        // Task storage task = tasks[_index];
        // task.text = _text;

        //otra forma de modificar si los valores son pocos, es de manera directa
        tasks[msg.sender][_index].text = _text;
    }

    function toDone (uint _index) public {
        _updateStatus(_index, TaskStatus.Done);
    }

     function toToDo (uint _index) public {
        _updateStatus(_index, TaskStatus.ToDo);
    }

     function toDoing (uint _index) public {
        _updateStatus(_index, TaskStatus.Doing);
    }

    function _updateStatus(uint _index, TaskStatus _status) internal {
        tasks[msg.sender][_index].status = _status;
    }

    function withDraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

}