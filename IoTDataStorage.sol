// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IoTDataStorage {
    struct DataEntry {
        string dataType;
        string value;
        uint256 timestamp;
    }

    address public owner;
    mapping(string => DataEntry[]) private deviceData;
    mapping(address => bool) public authorizedDevices;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedDevices[msg.sender], "Unauthorized");
        _;
    }

    function authorizeDevice(address device) public onlyOwner {
        authorizedDevices[device] = true;
    }

    function revokeDevice(address device) public onlyOwner {
        authorizedDevices[device] = false;
    }

    function storeData(string memory deviceID, string memory dataType, string memory value) public onlyAuthorized {
        require(bytes(deviceID).length > 0, "Invalid deviceID");
        require(bytes(dataType).length > 0, "Invalid dataType");
        require(bytes(value).length > 0, "Invalid value");

        DataEntry memory entry = DataEntry(dataType, value, block.timestamp);
        deviceData[deviceID].push(entry);
    }

    function getDataCount(string memory deviceID) public view returns (uint256) {
        return deviceData[deviceID].length;
    }

    function getDataByIndex(string memory deviceID, uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < deviceData[deviceID].length, "Index out of bounds");
        DataEntry memory entry = deviceData[deviceID][index];
        return (entry.dataType, entry.value, entry.timestamp);
    }
}
