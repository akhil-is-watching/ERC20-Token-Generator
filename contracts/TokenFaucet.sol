// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract TokenFaucet is Ownable {

    using SafeMath for uint;
    using SafeERC20 for IERC20;

    
    uint defaultEthAllowance = 1 ether;
    uint defaultERC20Allowance = 50 ether;

    mapping(address => uint256) public ethLockTime;
    mapping(address => mapping(IERC20 => uint256)) public erc20LockTime;

    mapping(string => IERC20) public tokens;

    receive() external payable {}

    function addToken(string memory _name, address _token) onlyOwner public {
        tokens[_name] = IERC20(_token);
    } 

    function requestEther() public {
        require(address(this).balance >= defaultEthAllowance, "NOT ENOUGH FUNDS IN FAUCET");
        require(block.timestamp > ethLockTime[msg.sender]);
        (bool sent, bytes memory data) = msg.sender.call{value: defaultEthAllowance}("");
        require(sent, "Failed to send Ether");

        ethLockTime[msg.sender] = block.timestamp.add(900);
    }

    function requestERC20(string memory _name) public {
        IERC20 token = tokens[_name];
        require(block.timestamp > ethLockTime[msg.sender]);
        require(token.balanceOf(address(this)) >= defaultERC20Allowance, "NOT ENOUGH FUNDS IN FAUCET");
        token.safeTransfer(msg.sender, defaultERC20Allowance);

        erc20LockTime[msg.sender][token] = block.timestamp.add(900);
    }

    function ethWithdrawAdmin(uint _amount) onlyOwner public {
        _amount = _amount.mul(1e18);
        require(address(this).balance >= _amount, "NOT ENOUGH FUNDS IN FAUCET");
        (bool sent, bytes memory data) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    function erc20WithdrawAdmin(string memory _name, uint _amount) onlyOwner public {
        IERC20 token = tokens[_name];
        _amount = _amount.mul(1e18);
        require(token.balanceOf(address(this)) >= _amount, "NOT ENOUGH FUNDS IN FAUCET");
        token.safeTransfer(msg.sender, _amount);
    } 


}