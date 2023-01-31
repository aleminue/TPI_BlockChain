// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract EthersWallet{

    address payable public owner;

    event LogWhitdrawTo(address fromWallet, address toWallet);

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "No tiene permisos para actualizar el precio");
        _;
        //la linea comentada debajo, es para quemar el addres
        //owner = address(0x0);
    }

    receive() external payable {}

    function deposit() external payable {}

    function withdrawAll() external onlyOwner{
        owner.transfer(address(this).balance);
    }

    function withdraw(uint256 _amount) external onlyOwner{
        require(address(this).balance >= _amount,"No se puede");
        owner.transfer(_amount);
    }

    function withdrawToWallet(address _wallet, uint256 _amount) external onlyOwner{
        require(address(this).balance >= _amount,"No se puede");
        payable(_wallet).transfer(_amount);
        emit LogWhitdrawTo(address(this), _wallet);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }



}